Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47CC429CD6;
	Thu, 16 Jul 2026 14:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211345; cv=none; b=WFnF7nnyFHc5GkqO3quHHXYWtNoIT0tPr9aktpjDydvi+UlqbTbH9aon7+n2G6f5ctQp4L0q0QECIsf8VeGVPEvT088dmm++7OJWupocAMkwpG5cy0xTl6oNZfN4nQjR/mXrtZRaiHEary19zaTskSulANr4c8RBZTHVtsmG6dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211345; c=relaxed/simple;
	bh=XULeThDUnXtRm9dMzTu40gn2+likskVsvt8qleSEqHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO+ZbuY7kcJwn7UuzyERNGuVGpJp7HpzCbn4CFw6VaqB50pO58hj/UqdDeT3TvMkU0I6sRbLf86zNtAeeuVYN4pd8LrIm25B8R7ptZ5xuSC+B0kxWlv4t7/g7KoSq63MNA9NIPBhsi3JDMhqn13C/YuJIHKOOjFxt3YoYu0UfTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5GXfvAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5GXfvAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B8D1F000E9;
	Thu, 16 Jul 2026 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211343;
	bh=ImKVltXYk43cNepZaLLLuETN//rLWyjtHjUaZaeXG0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5GXfvAV1SqcRmaR5MM0KcKCitbJYc+VZSVJPR2k8njIJKAAPBTg14s7Ddm/NihQs
	 iaOQ7PjcauBCW7YNOSu42CMt/57BXzEt8XODjDTeAvrIEC3PyYmG+7G94O73YkXoXR
	 hW3hpuJixnI2LJaVIBDZs9rrRDRpfjJVr0UIrlEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 392/480] audit: fix potential integer overflow in audit_log_n_hex()
Date: Thu, 16 Jul 2026 15:32:19 +0200
Message-ID: <20260716133053.280365165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Robaina <rrobaina@redhat.com>

commit 65dfde57d1e29ce2b76fc23dd565eccd5c0bc0f0 upstream.

The function calculates new_len as len << 1 for hex encoding. This
has two overflow risks: the shift itself can overflow when len is
large, and the result can be truncated when assigned to new_len
(declared as int) from the size_t calculation.

Fix by using check_shl_overflow() to catch shift overflow and
changing new_len and loop counter i to size_t to prevent truncation.

Cc: stable@vger.kernel.org
Fixes: 168b7173959f ("AUDIT: Clean up logging of untrusted strings")
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
[PM: remove vertical whitspace noise]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -47,6 +47,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/pid.h>
+#include <linux/overflow.h>
 
 #include <linux/audit.h>
 
@@ -2075,7 +2076,8 @@ void audit_log_format(struct audit_buffe
 void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 		size_t len)
 {
-	int i, avail, new_len;
+	int avail;
+	size_t i, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
 
@@ -2085,7 +2087,12 @@ void audit_log_n_hex(struct audit_buffer
 	BUG_ON(!ab->skb);
 	skb = ab->skb;
 	avail = skb_tailroom(skb);
-	new_len = len<<1;
+
+	if (check_shl_overflow(len, 1, &new_len)) {
+		audit_log_format(ab, "?");
+		return;
+	}
+
 	if (new_len >= avail) {
 		/* Round the buffer request up to the next multiple */
 		new_len = AUDIT_BUFSIZ*(((new_len-avail)/AUDIT_BUFSIZ) + 1);


