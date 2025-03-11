Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6812D1C5D77;
	Tue, 11 Mar 2025 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705740; cv=none; b=s4jqfT2MfhHor7r6sSAtztlwY7mFp35uKjkyVv+7TLqJJQAgwB8grO3X13pzlfmjtkso5WweGcHN3XUBBzxYozwllyGI9kVfzNUs0t3Q6Tqf6mDO4l9PPTzNpBZQlO0DmiGElEhsV0nyPmAxztRoVAH7AI89OxxzSZTSkhJRa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705740; c=relaxed/simple;
	bh=KjAEpoEANOgQ/2p8YJZmD6OTvNmPuTQbOLx3v8pyR7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmle6WTNsiiZKfyAQpn3VsHuRewRPMAMt4re3bJXHUSbIIkGoQfTVRvlZflDS0P4vj6YKEcmx1Ypb8bcSUhELxX0igsdcOyU7eiexDfBZjgY0nfGekdk6hy3RC2RzBgHZ6/bIj8JMN6PN8gAybyO26auiQZ19aH+yOo9wRV0ngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXOJ3qid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXOJ3qid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C6CC4CEE9;
	Tue, 11 Mar 2025 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705740;
	bh=KjAEpoEANOgQ/2p8YJZmD6OTvNmPuTQbOLx3v8pyR7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXOJ3qid7LLEwsn90MBEzno+vWfIWFgxR3bj9NsML6ZuRIHRz9ThqvAkHG5VkrWys
	 fSU3bO4jCmDncYSSt03tUovAXiGEClNOSARfqKnrZHR3h/FtGcNH2mLPL49tf8Pdys
	 KSKVtnQc3jf8bemd7lnpnqCILOpsmp2q/6NfZ4W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.4 121/328] binfmt_flat: Fix integer overflow bug on 32 bit systems
Date: Tue, 11 Mar 2025 15:58:11 +0100
Message-ID: <20250311145719.705766710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 55cf2f4b945f6a6416cc2524ba740b83cc9af25a upstream.

Most of these sizes and counts are capped at 256MB so the math doesn't
result in an integer overflow.  The "relocs" count needs to be checked
as well.  Otherwise on 32bit systems the calculation of "full_data"
could be wrong.

	full_data = data_len + relocs * sizeof(unsigned long);

Fixes: c995ee28d29d ("binfmt_flat: prevent kernel dammage from corrupted executable headers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/5be17f6c-5338-43be-91ef-650153b975cb@stanley.mountain
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -529,7 +529,7 @@ static int load_flat_file(struct linux_b
 	 * 28 bits (256 MB) is way more than reasonable in this case.
 	 * If some top bits are set we have probable binary corruption.
 	*/
-	if ((text_len | data_len | bss_len | stack_len | full_data) >> 28) {
+	if ((text_len | data_len | bss_len | stack_len | relocs | full_data) >> 28) {
 		pr_err("bad header\n");
 		ret = -ENOEXEC;
 		goto err;


