Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470F3F9EA;
	Mon, 29 Jan 2024 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548448; cv=none; b=iO5NGL2Ut9901kGatiaxz+6D7brmom578dlGTHk+WkD62P+/zlMUm7nM9FcmRRvGrTijkGhQAfQ2af81/ZHxq20WH72za5mzJBd7NjQrfL6maN6bFNp9A3fW7DUbNn5R01D8xeDp1dRF0mEdX8vw8SFFFOZyTlosRz2VumI/lag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548448; c=relaxed/simple;
	bh=C5XnXuiehvnM2i1KqX3VSg/fA4x4yegqwWWd3ynGUTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaV2TMU/HwlLqWQszO+jUSnsSxcl8dbDZ4saXb4oihEKY2kFEaq70dxqsk8vBU3JA4eDr5gwXvNgR94/jS4pNh56QtGmX4+P+g+l5ktcgse847UBNksKA2OCphnjttYLR04j8BwAya2TTsszt66p2Yl00NC1EeJKvgEK1lwprj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgyivusG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgyivusG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C192DC43390;
	Mon, 29 Jan 2024 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548447;
	bh=C5XnXuiehvnM2i1KqX3VSg/fA4x4yegqwWWd3ynGUTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgyivusGyfZXFDLBM8DzzQnny3iLL/97yZWIAHNh8gfk3fbGsC1JjCP8PNqwFIFu6
	 uFTS3+UeFsNLrJSXpqbZLlYAOPivlCqp7DH7Kq0CtTn1U82BJCYAo69PZLA+fJBwvF
	 E6WFz+GMbYj5a7FL3uGdc+ZXAQB6iRc9iWez2QMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 031/331] async: Split async_schedule_node_domain()
Date: Mon, 29 Jan 2024 09:01:35 -0800
Message-ID: <20240129170015.866293982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 6aa09a5bccd8e224d917afdb4c278fc66aacde4d upstream.

In preparation for subsequent changes, split async_schedule_node_domain()
in two pieces so as to allow the bottom part of it to be called from a
somewhat different code path.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Tested-by: Youngmin Nam <youngmin.nam@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/async.c |   56 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

--- a/kernel/async.c
+++ b/kernel/async.c
@@ -145,6 +145,39 @@ static void async_run_entry_fn(struct wo
 	wake_up(&async_done);
 }
 
+static async_cookie_t __async_schedule_node_domain(async_func_t func,
+						   void *data, int node,
+						   struct async_domain *domain,
+						   struct async_entry *entry)
+{
+	async_cookie_t newcookie;
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&entry->domain_list);
+	INIT_LIST_HEAD(&entry->global_list);
+	INIT_WORK(&entry->work, async_run_entry_fn);
+	entry->func = func;
+	entry->data = data;
+	entry->domain = domain;
+
+	spin_lock_irqsave(&async_lock, flags);
+
+	/* allocate cookie and queue */
+	newcookie = entry->cookie = next_cookie++;
+
+	list_add_tail(&entry->domain_list, &domain->pending);
+	if (domain->registered)
+		list_add_tail(&entry->global_list, &async_global_pending);
+
+	atomic_inc(&entry_count);
+	spin_unlock_irqrestore(&async_lock, flags);
+
+	/* schedule for execution */
+	queue_work_node(node, system_unbound_wq, &entry->work);
+
+	return newcookie;
+}
+
 /**
  * async_schedule_node_domain - NUMA specific version of async_schedule_domain
  * @func: function to execute asynchronously
@@ -186,29 +219,8 @@ async_cookie_t async_schedule_node_domai
 		func(data, newcookie);
 		return newcookie;
 	}
-	INIT_LIST_HEAD(&entry->domain_list);
-	INIT_LIST_HEAD(&entry->global_list);
-	INIT_WORK(&entry->work, async_run_entry_fn);
-	entry->func = func;
-	entry->data = data;
-	entry->domain = domain;
-
-	spin_lock_irqsave(&async_lock, flags);
 
-	/* allocate cookie and queue */
-	newcookie = entry->cookie = next_cookie++;
-
-	list_add_tail(&entry->domain_list, &domain->pending);
-	if (domain->registered)
-		list_add_tail(&entry->global_list, &async_global_pending);
-
-	atomic_inc(&entry_count);
-	spin_unlock_irqrestore(&async_lock, flags);
-
-	/* schedule for execution */
-	queue_work_node(node, system_unbound_wq, &entry->work);
-
-	return newcookie;
+	return __async_schedule_node_domain(func, data, node, domain, entry);
 }
 EXPORT_SYMBOL_GPL(async_schedule_node_domain);
 


