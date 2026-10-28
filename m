Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210530;
	b=f0ozgHyIxyNPrgwZA61AC/lHCryF/oNNwF2qBnV8EDf9N/Imb4tRa7V6WR9l4U+G5GIj
	 f3wupjdkS4P7lWzPMo0gJUJr4koRnvY3xXL9rF6bClabCiJPPLcGLjjftY3kMSnXE1Nc8
	 gM7ZMcuA46JOdrn+yLymC0G/5FmQl1hWRyfXzGH9OCSTUcBL6vAyJji0WF3X3QzLZ4DQ+
	 9JFjvcEWdpZSFA8itDTj60yDt8DPCrGe2ehCxr6HckA2/16E6hD6sGM77/1CloKQIOCsn
	 zDjRlG33o6WpIkR738YuQ5VUNoFsPtPqnIIRQbnmHmeIEt64Hvd+JuERz7hDtm2fLTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEloBFv9bEU0IdiAZtLylJogjS/CVQgMA8n+HvcnaOI=;
	b=ivJ2LJ7L2zeU2Ur4+unTQuj+dThTCbw1BS4Bl7O/H6/tn1rZcEdQoGzcfo4gc4H9uhkd
	 eCVr+kDgjX1/DUAcZiYlhuWIqf5fRk5bQyX+AD2gtUdfth2+FRY5aXR/xK2wGxITMI8dL
	 9TPC8rA0q2oQLUTWwd/bSt0ayfeL/D6/KcF7g32jOGu/PdRrQ8jSZnlPQZmka8H0YTzGt
	 Zrh6VW5/vxtfR1w6VTU6UowQ7QuCnjjI5Y8lwu0yg/yJlABhTvKZ8LE2axUHurAT0ZTVj
	 oE4q035XjQVaRFFiEyHuA02zU+lZsOkDz2u91RnQRufYrkUIKtm52AA7ies8t+s6plA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4aIbe70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEAA606A31C;
	Wed, 28 Oct 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4aIbe70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBD51F01825;
	Wed, 28 Oct 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210529;
	bh=UEloBFv9bEU0IdiAZtLylJogjS/CVQgMA8n+HvcnaOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4aIbe705p7rEODUSPaIc0G9KkTWYN7GoQEXFVDucadXJswr/soRRg2slzW9tVPpm
	 AqPd5ug6QebbDaYsEPQDjyJx9zLjVox5amHv4+oI7Z5UF0KxhesGuJ48rik8chFECk
	 tl/3h4K2nE059ax10wuvoeO4a0MHLPXu9ZwUJScM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/571] params: Do not go over the limit when getting the string length
Date: Wed, 28 Oct 2026 17:53:25 +0100
Message-ID: <20261028170009.404003085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b904bd98dd01b..55541483d6d36 100644
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



