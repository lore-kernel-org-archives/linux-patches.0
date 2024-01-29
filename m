Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5010A15704F;
	Mon, 29 Jan 2024 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548036; cv=none; b=AR+e/60ruYjppbgFSFB45av4dtJau5lnyQRttau597LcxXhqEZ0V7uN8JsWPsNLcD8o6nbl/p4jOGvSzipAzdk4uOSru+LUUsXWzljVlsaulfEfIdDUKcSa/c3+g1jEXjIRMe69ZDtBbGZIZzv6qQQ0O8sxmgftwb4DaIew94G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548036; c=relaxed/simple;
	bh=4jgtOBgSQeQIYNCLhelMfVQiP0leJc2ccceQ2zf1ISM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZzcYrthSFtUHCAdwsXcpHN4MpnO5SR40e66wc4rjv/R+dvmrzAA58SO3sd/DdjwpYxJyQnXxRa0WfxKxqbWxCX+9ctnoxZ3DmIhJ7V3+4wA+CmF9tUZr/lnB7g6dfgWdtUUqEtRLd2O2DTOi1cZwJ5rqTGjY83G5Z09bmiJFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGVBPovm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGVBPovm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1411CC433F1;
	Mon, 29 Jan 2024 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548036;
	bh=4jgtOBgSQeQIYNCLhelMfVQiP0leJc2ccceQ2zf1ISM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGVBPovm7PeyLBsM/VEnOxeqLTcAmnEIRTaz+T0Zz/OuYS5NSty31tTXJSA6TQIWO
	 2wp2xcVeyqa0yOsQEcUWRmKDrX07ZrocdjNSdfzUKJknaDaN449FhHZVak6Rk1vsjA
	 +tX1gdXNQ4TUlIn1zDBMcdWnVN7/6RlUfXz9H5OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 008/346] async: Split async_schedule_node_domain()
Date: Mon, 29 Jan 2024 09:00:39 -0800
Message-ID: <20240129170016.599187162@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 


