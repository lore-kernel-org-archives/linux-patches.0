Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FC618132F;
	Sun,  1 Sep 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207817; cv=none; b=iocaMNZ78UhCfnBWdztGlhvDHNW2OXN0L0+f1eQT9yh4c2AucJEJeLUKIqr/K0D/EB59l+AMtDzaEDxUGxbpSwH+Zvn2Ntc3bPP3V202QKpBXhV1IMDaODA1J8OtBkhpAr81G5DljGi3ZJxVidC0JUrKyogSf4sUCGMNzZkmKtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207817; c=relaxed/simple;
	bh=EglFBCo7+KpMEFiufHnU5H9TFQKp1/bgO4mQBTp5tSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRqV+KBagxRH45Cd0F3NDCwBAsYSHndjNHhfRx8oSNSLtAk7GaIE0OEGFBehVzpzalQ/AKwM4fF6dWYjl3q9dbn1p3LnQsnu4j5uLN3CODv/0XDmg4t/mFGG0VU7naxQbIgDzcymmMowCyk8MpRoefOUXktY8JEkNDzUNcE66Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V13Gxzg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V13Gxzg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0A0C4CEC3;
	Sun,  1 Sep 2024 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207817;
	bh=EglFBCo7+KpMEFiufHnU5H9TFQKp1/bgO4mQBTp5tSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V13Gxzg6GMAsq9pUo5Ght4s/wrvoJiSMRNT/KmT9RJ8u/iC5DH+vjpLipMo8e+fho
	 P2JbOseoDi1uMgr/dIRqKYzTH9Uc8r+64KseEwEbFKcCrITBIDCcJi7CCaOO4xaKGM
	 68ogdDJ9yijP6pwz6hmxXlasBeo6hZTrz78vi7jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghan Wang <wzhmmmmm@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 85/98] ida: Fix crash in ida_free when the bitmap is empty
Date: Sun,  1 Sep 2024 18:16:55 +0200
Message-ID: <20240901160806.903436876@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit af73483f4e8b6f5c68c9aa63257bdd929a9c194a upstream.

The IDA usually detects double-frees, but that detection failed to
consider the case when there are no nearby IDs allocated and so we have a
NULL bitmap rather than simply having a clear bit.  Add some tests to the
test-suite to be sure we don't inadvertently reintroduce this problem.
Unfortunately they're quite noisy so include a message to disregard
the warnings.

Reported-by: Zhenghan Wang <wzhmmmmm@gmail.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/idr.c      |    2 +-
 lib/test_ida.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -471,7 +471,7 @@ static void ida_remove(struct ida *ida,
 	} else {
 		btmp = bitmap->bitmap;
 	}
-	if (!test_bit(offset, btmp))
+	if (!bitmap || !test_bit(offset, btmp))
 		goto err;
 
 	__clear_bit(offset, btmp);
--- a/lib/test_ida.c
+++ b/lib/test_ida.c
@@ -150,6 +150,45 @@ static void ida_check_conv(struct ida *i
 	IDA_BUG_ON(ida, !ida_is_empty(ida));
 }
 
+/*
+ * Check various situations where we attempt to free an ID we don't own.
+ */
+static void ida_check_bad_free(struct ida *ida)
+{
+	unsigned long i;
+
+	printk("vvv Ignore \"not allocated\" warnings\n");
+	/* IDA is empty; all of these will fail */
+	ida_free(ida, 0);
+	for (i = 0; i < 31; i++)
+		ida_free(ida, 1 << i);
+
+	/* IDA contains a single value entry */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 3, GFP_KERNEL) != 3);
+	ida_free(ida, 0);
+	for (i = 0; i < 31; i++)
+		ida_free(ida, 1 << i);
+
+	/* IDA contains a single bitmap */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 1023, GFP_KERNEL) != 1023);
+	ida_free(ida, 0);
+	for (i = 0; i < 31; i++)
+		ida_free(ida, 1 << i);
+
+	/* IDA contains a tree */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, (1 << 20) - 1, GFP_KERNEL) != (1 << 20) - 1);
+	ida_free(ida, 0);
+	for (i = 0; i < 31; i++)
+		ida_free(ida, 1 << i);
+	printk("^^^ \"not allocated\" warnings over\n");
+
+	ida_free(ida, 3);
+	ida_free(ida, 1023);
+	ida_free(ida, (1 << 20) - 1);
+
+	IDA_BUG_ON(ida, !ida_is_empty(ida));
+}
+
 static DEFINE_IDA(ida);
 
 static int ida_checks(void)
@@ -162,6 +201,7 @@ static int ida_checks(void)
 	ida_check_leaf(&ida, 1024 * 64);
 	ida_check_max(&ida);
 	ida_check_conv(&ida);
+	ida_check_bad_free(&ida);
 
 	printk("IDA: %u of %u tests passed\n", tests_passed, tests_run);
 	return (tests_run != tests_passed) ? 0 : -EINVAL;


