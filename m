Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269BB78681;
	Wed, 21 Feb 2024 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522016; cv=none; b=GcTZtBO5NJCamS5E2Jg6fKV102eJ9cdbly0Vq6iRj3v5DvcPctgH/n/U3b5WegYOWdBtPzdr8RH7iRjV6QBthNdygAmDVf5SEs6YalQ1G5QhbwwBMpFdHqzTUGFNeT5AYrxO0t/9oSqV0Ae421O4c52dUhy6Ilcf0dhyc0Rc9n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522016; c=relaxed/simple;
	bh=vP5vJb/f2RV5AYiyHT29Z+XaJf+bGhja5TL4u6bqiPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrRd2XbkPE3caJNrtyShcVri+J1IzVQygWy+mKEWB/6dY6G2T4TnIlN5jLp2KT9vMp3X8y6DjJIJF6C5tuFcxtqEAX6mcjafpljaC8RDiR3NSSQQL15lDJ6/kKondGDCZ+4lzTjcXPZekZJVs6hERitcVt5/xDtAanEZyDJjSOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzPb7U9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzPb7U9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E08C433C7;
	Wed, 21 Feb 2024 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522016;
	bh=vP5vJb/f2RV5AYiyHT29Z+XaJf+bGhja5TL4u6bqiPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzPb7U9VDqa2uApLr1WSDGOguq/o7PorUIbvpSXc6DXKAOuqCxTN3hRsR/8KOKG2S
	 5DN39qb1pH9xWdkOj5MqV1HcD968XINdUppO95gLqa5PEq6c4qD88HCB7ddoeVMyaj
	 R/GSDa17xxtDHsITQWpG55xkFhnne/y7H2Q75cnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 5.15 027/476] async: Introduce async_schedule_dev_nocall()
Date: Wed, 21 Feb 2024 14:01:18 +0100
Message-ID: <20240221130008.923244240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7d4b5d7a37bdd63a5a3371b988744b060d5bb86f upstream.

In preparation for subsequent changes, introduce a specialized variant
of async_schedule_dev() that will not invoke the argument function
synchronously when it cannot be scheduled for asynchronous execution.

The new function, async_schedule_dev_nocall(), will be used for fixing
possible deadlocks in the system-wide power management core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com> for the series.
Tested-by: Youngmin Nam <youngmin.nam@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/async.h |    2 ++
 kernel/async.c        |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -90,6 +90,8 @@ async_schedule_dev(async_func_t func, st
 	return async_schedule_node(func, dev, dev_to_node(dev));
 }
 
+bool async_schedule_dev_nocall(async_func_t func, struct device *dev);
+
 /**
  * async_schedule_dev_domain - A device specific version of async_schedule_domain
  * @func: function to execute asynchronously
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -244,6 +244,35 @@ async_cookie_t async_schedule_node(async
 EXPORT_SYMBOL_GPL(async_schedule_node);
 
 /**
+ * async_schedule_dev_nocall - A simplified variant of async_schedule_dev()
+ * @func: function to execute asynchronously
+ * @dev: device argument to be passed to function
+ *
+ * @dev is used as both the argument for the function and to provide NUMA
+ * context for where to run the function.
+ *
+ * If the asynchronous execution of @func is scheduled successfully, return
+ * true. Otherwise, do nothing and return false, unlike async_schedule_dev()
+ * that will run the function synchronously then.
+ */
+bool async_schedule_dev_nocall(async_func_t func, struct device *dev)
+{
+	struct async_entry *entry;
+
+	entry = kzalloc(sizeof(struct async_entry), GFP_KERNEL);
+
+	/* Give up if there is no memory or too much work. */
+	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
+		kfree(entry);
+		return false;
+	}
+
+	__async_schedule_node_domain(func, dev, dev_to_node(dev),
+				     &async_dfl_domain, entry);
+	return true;
+}
+
+/**
  * async_synchronize_full - synchronize all asynchronous function calls
  *
  * This function waits until all asynchronous function calls have been done.


