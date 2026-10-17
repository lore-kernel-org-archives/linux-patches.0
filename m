Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE47829BDB5;
	Sat, 17 Oct 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255924; cv=none; b=ai1eG9PmOrl8e030uSfZyAMGTTp8lyM6cyXi2oKb6oFEQtWPcJgG93udw8Ne/fNp5mILrr6ClXMOeUYXIfPVk7jFWEoO045GZcX0fPwIyL4guCNiB7/OGO1dadZn5xE7+Ig0XZwmWLpcF0JwKnQK2f9M1aoC1fYkiCPc0sHI5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255924; c=relaxed/simple;
	bh=5SlxkSBxDv7fNNLFeSoLzoAIc6YwqFBnA9+7BV2fQR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5Ngl/UgSedOZ2wzcan3hzAnsfByBuZVGdJz05pomwqAdEyediReauFyO1mXSfGaFfj+N04tB1fNfJU+ChSZF2QndT8YM9u2pEcHHAae8NZx+gtsYXolw9BgTcksNJBZ105NW1dxIcRJcjH6Wmd/TzkUJPXwNodE7elgdKAZyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSovLMBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSovLMBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DDD1F000C4;
	Sat, 17 Oct 2026 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255923;
	bh=bxVb3inmj0zUDbKJLHetA1ntmclQrj7jHB8lt9ZDbeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSovLMBJnMDNR6A6KyfuOiyBqNCipnv46xc4MJxJccpDy3j7r4r+VFOcUCO/WK5He
	 2/0F+G3TmvK1WCYx82PF/u9X281ulSdXrazdGfcQzdpFMbVcUViZiz4yoHnhSAdGsB
	 OOBncF5HEOZutMfU5xaHCSNF+RrzQEeRgzXrGPf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0064/1674] params: Do not go over the limit when getting the string length
Date: Sat, 17 Oct 2026 17:38:56 +0200
Message-ID: <20261017160432.782400717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fd0cd057a1b7351604daa6ffc91dfe28adf7225d ]

We can use strnlen() even on early stages and it prevents from
going over the string boundaries in case it's already too long.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 9d09ea99363fc..8992899996984 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -264,7 +264,10 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-	if (strlen(val) > 1024) {
+	size_t len, maxlen = 1024;
+
+	len = strnlen(val, maxlen + 1);
+	if (len == maxlen + 1) {
 		pr_err("%s: string parameter too long\n", kp->name);
 		return -ENOSPC;
 	}
@@ -274,7 +277,7 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 	/* This is a hack.  We can't kmalloc in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(strlen(val)+1);
+		*(char **)kp->arg = kmalloc_parameter(len + 1);
 		if (!*(char **)kp->arg)
 			return -ENOMEM;
 		strcpy(*(char **)kp->arg, val);
@@ -512,7 +515,7 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
-	if (strlen(val)+1 > kps->maxlen) {
+	if (strnlen(val, kps->maxlen) == kps->maxlen) {
 		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
 		return -ENOSPC;
-- 
2.53.0



