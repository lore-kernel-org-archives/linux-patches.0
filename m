Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B678342501;
	Tue, 12 May 2026 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609710; cv=none; b=mWWqyyiXiL/+tjvyRg8RS5ADuW9WdXteJLXNYQ09DPmYWU/rwJPPx5WhPAaNnERVn1qqZKaww2uZfBL/eCsVks/l/7siFmhMNV45aQarbKpHRh0MjAiPjz4YwlsynrGP2oiOUhR1ZyHWdUB6YzMTaNpTgzb9icjpe5U3cIztf7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609710; c=relaxed/simple;
	bh=5UPApT0dws36Qmua9/up88lv/1U6UPjj+n9/XrR2ZdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOsXvTROqwUHqdZjMuz2kpWw0OzF7B1lvJpCOnv4I0xKW3PdIgktb0n5YVqoy7Xi3NXYb0AshoYZgckfQxo8xMWfNWTsHyP3XkrXysWlyYU/Yme2MqVsWGadoDmHh7pucRe4JEENY/Jhwhar6G47qOowOxegZHCW4nV4w3dNkiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqQVsEVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqQVsEVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3306CC2BCC7;
	Tue, 12 May 2026 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609710;
	bh=5UPApT0dws36Qmua9/up88lv/1U6UPjj+n9/XrR2ZdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqQVsEVYmdqn7k6dLvN6In6s37HLpKWGPE0S2SGhkMFJaRdVocm0ZQRT8iEIkYTBx
	 2wqy3mlKw2GCNYUhRks5CmUaORYnhVK2ElX1s6OoIqiZgN6J2haDoxWC8wd+zUIKOu
	 7FN87Z3fo72MJAbmrAMoxsgKAbXFICvnjV1yQMdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 302/307] printk: add print_hex_dump_devel()
Date: Tue, 12 May 2026 19:41:37 +0200
Message-ID: <20260512173946.507673520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d134feeb5df33fbf77f482f52a366a44642dba09 ]

Add print_hex_dump_devel() as the hex dump equivalent of pr_devel(),
which emits output only when DEBUG is enabled, but keeps call sites
compiled otherwise.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 177730a273b1 ("crypto: caam - guard HMAC key hex dumps in hash_digest_key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/printk.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -801,6 +801,19 @@ static inline void print_hex_dump_debug(
 }
 #endif
 
+#if defined(DEBUG)
+#define print_hex_dump_devel(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#else
+static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
+					int rowsize, int groupsize,
+					const void *buf, size_t len, bool ascii)
+{
+}
+#endif
+
 /**
  * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
  * @prefix_str: string to prefix each line with;


