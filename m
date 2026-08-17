Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E785A43CE65;
	Mon, 17 Aug 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976064; cv=none; b=HKYjH4qoGG/eK1y4p20vgCq6Q4RoCxVneS0WPTmHP2WC3yQlf+ewVZXzqmUdmysbWuGlOjKXGSkc2VGLFWY+e8ax3QpsAZP/+9FGyWZBRiXy//6Vi9oQ2grG1grFC+fsuT+rIusmWTRuH9jdMyTLA0duR4e6wFh/LQbpK+KLtgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976064; c=relaxed/simple;
	bh=QJjRWv1jxCjQ9yzffcT2+/8CPJoEAHpJd78tzyLEiu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE6m6aIdd4Xm4shjJ/LrVD2dFJgPiT/BarlZh3Fcw4O1SYXK2GDcLqnzVFJUjxD1/cZ6xC9gpO1PV11aKd3MTfyQx6TOzizpxpx/exwqD81q0CFAhqRObbW97QD0yozmmqs8PhPLhro8NOrzvcX3Qq96PquH0hgq22owQ1wQ64I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLQJGHPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLQJGHPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D5D1F000E9;
	Mon, 17 Aug 2026 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976062;
	bh=CmjUCPR1z8epNcqciFTBvEbRRix57nvuZBaSbgZnVJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLQJGHPGtELHOVpgpuvAWNVCU5W1QsZ3c0RBE9nbLlJeE6miCd5KEA5i4QlDwT3k0
	 mQsHrK5rdwYwQi8KmEYsJKZXkDW7SWf3ZRhiWn5jp3QXBFk5nj3svfrJwLxK1JHbMh
	 IKXrJVOcEndhGYWui/BQMWLg0DNHKgXrNQWpGtFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 245/389] audit: fix potential integer overflow in audit_log_n_string()
Date: Mon, 17 Aug 2026 15:31:24 +0200
Message-ID: <20260817132548.842592720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit f865c143629d4094866a811dba5f329250bad486 upstream.

audit_log_n_string() computes new_len as "slen + 3" (enclosing quotes
plus the NUL terminator) and stores it into an int, while slen is a
size_t.  For a sufficiently large slen the addition can overflow and/or
the result be truncated when assigned to the int new_len, so the
"new_len > avail" check can be bypassed and the subsequent
memcpy(ptr, string, slen) can write past the skb tail.

This is the same class of bug that was fixed for the hex sibling in
commit 65dfde57d1e2 ("audit: fix potential integer overflow in
audit_log_n_hex()"); both helpers are reached through
audit_log_n_untrustedstring() with the same length source.

Make new_len a size_t and use check_add_overflow() to catch the
overflow, mirroring the audit_log_n_hex() fix.  No functional change for
the in-tree callers, which all pass bounded lengths.

Cc: stable@vger.kernel.org
Fixes: 168b7173959f ("AUDIT: Clean up logging of untrusted strings")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2074,7 +2074,8 @@ void audit_log_n_hex(struct audit_buffer
 void audit_log_n_string(struct audit_buffer *ab, const char *string,
 			size_t slen)
 {
-	int avail, new_len;
+	int avail;
+	size_t new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
 
@@ -2084,7 +2085,13 @@ void audit_log_n_string(struct audit_buf
 	BUG_ON(!ab->skb);
 	skb = ab->skb;
 	avail = skb_tailroom(skb);
-	new_len = slen + 3;	/* enclosing quotes + null terminator */
+
+	/* enclosing quotes + null terminator */
+	if (check_add_overflow(slen, 3, &new_len)) {
+		audit_log_format(ab, "?");
+		return;
+	}
+
 	if (new_len > avail) {
 		avail = audit_expand(ab, new_len);
 		if (!avail)


