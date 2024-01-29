Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA53F9EA;
	Mon, 29 Jan 2024 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548448; cv=none; b=rpNyez9fcwO5QBFOQEglb3paIvYbPgij0xJ8ot+1U00zgO0SuCcStqfbDMnf/VanOc+9ZEQruGAIIx9KEM8MUpTaxHDzjvPX3cKIk/8RGJayjf/KrNgRlVtOIFGCDKhT4AFeSddVtzurE1yv68JT6Faw0CWZXbv3faAOn95q5AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548448; c=relaxed/simple;
	bh=IJyP73m/EVLOA8uQfV/61laEnkLQ5TYnHoV3A8R8U+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqbMQbneXR+vuZbDxtaQ6Tvt+iNenaDH0HjmjIWACa1Uw7osYr7QOZKQkqvG+C0INfvikalvbcXn0ixwHdxLQWNaZPm9/i9I/80lXSajqlHYF7EEKrm/O1OFg4Fne3X/A+X3FKheMMD+LsK8tnR1vx30yInOlfkkr14sUbLgqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD3F6JZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD3F6JZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7723DC433F1;
	Mon, 29 Jan 2024 17:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548448;
	bh=IJyP73m/EVLOA8uQfV/61laEnkLQ5TYnHoV3A8R8U+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD3F6JZVOLOY6qNtCnt2NQSbX9WzZ2OTyqaQkBwaTwZKtsSAq1a5hBOIzC3L3L9NA
	 jLViQy2ciBSfrDq4UaTdY4K4feICnA5+otttaKGv4VoO1rm4WWFJy2/l8ZKTlYdaQi
	 X0o98M77mfHyIm20JV3LfyltLmpn21NgiN76tv2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.6 032/331] async: Introduce async_schedule_dev_nocall()
Date: Mon, 29 Jan 2024 09:01:36 -0800
Message-ID: <20240129170015.889210767@linuxfoundation.org>
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


