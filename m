Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805EB78B50;
	Wed, 21 Feb 2024 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523682; cv=none; b=L6SKUPL7rlyNep9pLMDS6AvK+lj67GZe/KADlzJSBbhmjVpDudgO/rPO5Bxxfk9zHvqxGWJ8k9V2eF1Oh8P3pkLkfUziw01tSETQ3X6Sczw70foK7BfQpqyek30Zx5Yx+OZc1aqDntxgtbjzOq+cn66gBReErwiw58Y4RGbIH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523682; c=relaxed/simple;
	bh=es4a31ldTUhN22l5d6F1qtx5NHD3EmG4DLBMTVXEgjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAK8+Mj0FmnhQcpPdOEhRwIc6EXpxxFob1VXCO90Q55APYlFaxuYJdJ272sY/guoGyBqXry7q5wNF/XPuftMpHRkuxs53yayMtdck9m/fK/A50twkLMJCVlbtwZ2k+JSp7I2wyoWKp+7kEdc/XYvJAmEOgCqsQN2iwbAB3XhXnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkRQ+aIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkRQ+aIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3738C433C7;
	Wed, 21 Feb 2024 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523682;
	bh=es4a31ldTUhN22l5d6F1qtx5NHD3EmG4DLBMTVXEgjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkRQ+aIxG/gnPWimvsUkTFw+m69nH28JMmei/PzGaJyEHdF9kQ6IZR5eojK6gN67u
	 4LI4R2osOTAEWqgyp7kF7Soe8INinynNfFNcWYyWc1n3oKINcjfM135HtW1sgniOHI
	 cqVyy+wFPwEck6EmtR/6AU1tUQUSykK6RP+0VSoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 5.10 026/379] async: Introduce async_schedule_dev_nocall()
Date: Wed, 21 Feb 2024 14:03:25 +0100
Message-ID: <20240221125955.692050236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


