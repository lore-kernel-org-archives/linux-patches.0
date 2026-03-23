Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6D39EF1E;
	Mon, 23 Mar 2026 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276956; cv=none; b=ODop3QnuVlWO9wEwe5BzBx80yc7+FDFzfuaBp8GjlLMPPInXk4+HGUqsHqBbRXreekxTQ+ywks7XFT8XTyF6ZUNCrdLA+30z300e/Ph+7VqWGDgtlp984u/nKVeQQO2LmwahLYljSLCZ8bIoAwcwWD9TauGBmUn8ElCj8WyyzQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276956; c=relaxed/simple;
	bh=p3LYv4WO5zPii5nONiS0MIsQjGcRI+tWelbAjs5IyQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8v5JI9nqD0uf8IeKyZj7BMqFiQu5TrYL0oV7iAP6sa04eFhd3kdn6avOF0SbXRqA3KOFoxTXEJP7HlVDmGKeI85s4FR0WVH+5TaThy0ORI1fvWk24KurlWhqxwCFHggaIhWE0C6osmMPNo0L1izFjoA1WRPSioAXCgBFUoFG9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsdSOoBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsdSOoBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F520C2BC9E;
	Mon, 23 Mar 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276955;
	bh=p3LYv4WO5zPii5nONiS0MIsQjGcRI+tWelbAjs5IyQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsdSOoBr4YVmicUkJ3nyX0ThmRpfGL9nGouwVL27tx7Qn7Cbpz8v2BxpXfmwhvNg1
	 fZMsDcM5gjLTgOWj4SuDgAnoqzNpRDVkBCWDnGUc91A8pp/PZg10fnrW1zV6bo3HHD
	 a/yYKSUagtzkDUX+IuZ8ZEtH6wfzuLZx5nVH4UlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/460] cleanup: Provide retain_and_null_ptr()
Date: Mon, 23 Mar 2026 14:43:57 +0100
Message-ID: <20260323134532.429027134@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 092d00ead733563f6d278295e0b5c5f97558b726 ]

In cases where an allocation is consumed by another function, the
allocation needs to be retained on success or freed on failure. The code
pattern is usually:

	struct foo *f = kzalloc(sizeof(*f), GFP_KERNEL);
	struct bar *b;

	,,,
	// Initialize f
	...
	if (ret)
		goto free;
        ...
	bar = bar_create(f);
	if (!bar) {
		ret = -ENOMEM;
	   	goto free;
	}
	...
	return 0;
free:
	kfree(f);
	return ret;

This prevents using __free(kfree) on @f because there is no canonical way
to tell the cleanup code that the allocation should not be freed.

Abusing no_free_ptr() by force ignoring the return value is not really a
sensible option either.

Provide an explicit macro retain_and_null_ptr(), which NULLs the cleanup
pointer. That makes it easy to analyze and reason about.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Link: https://lore.kernel.org/all/20250319105506.083538907@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cleanup.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -216,6 +216,25 @@ const volatile void * __must_check_fn(co
 
 #define return_ptr(p)	return no_free_ptr(p)
 
+/*
+ * Only for situations where an allocation is handed in to another function
+ * and consumed by that function on success.
+ *
+ *	struct foo *f __free(kfree) = kzalloc(sizeof(*f), GFP_KERNEL);
+ *
+ *	setup(f);
+ *	if (some_condition)
+ *		return -EINVAL;
+ *	....
+ *	ret = bar(f);
+ *	if (!ret)
+ *		retain_and_null_ptr(f);
+ *	return ret;
+ *
+ * After retain_and_null_ptr(f) the variable f is NULL and cannot be
+ * dereferenced anymore.
+ */
+#define retain_and_null_ptr(p)		((void)__get_and_null(p, NULL))
 
 /*
  * DEFINE_CLASS(name, type, exit, init, init_args...):


