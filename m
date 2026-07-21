Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2B245A2BE;
	Tue, 21 Jul 2026 21:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667907; cv=none; b=NGOeaj8MPQhrDs3IMFtjRdejlIoJI3R//CN2LnBwGbnht9wXIx3SNtAU/+qc7O8UFzZDZZd3Lja2q4okCNWqH9y1XN5L+vq5bRt+0trpGfIq01B0jhYgFgP2MZDBu4W0n78cKzeWNGufAJyWSITNnRbwY7cWof+MzFWbNphQNJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667907; c=relaxed/simple;
	bh=YjQM8/B5Z+4GjWq8FtHpax+KE7OYfHk4DAPY9HHL8y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plKhD7Vyy8IxoHE5pu5gmsV/3Fm/6Dm8J64xIGfJVcf0poJkrNQZmm01j7rsyqxvQrfoLKgOWa/3v2ns8jX26oLq5yB33ydH1xMcMxRHBIz/fAS3dCEU+Juk3PaCxGy+orRt9UEB7MbTCqzrl96w86oEH4+vxuflpHOOD3jEF+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzfnib5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzfnib5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DDC1F000E9;
	Tue, 21 Jul 2026 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667904;
	bh=d0Mjw772IOYCXtBmIMShPu3Dt5y2VItmn8I970CNGY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzfnib5lmtePobTruSCnX/2G6NoWERF6xjArlXq/cdbQSQMV8HseOd+DCa8Y6kZP4
	 XAw+3MMzVB+HvlABkRSaChjwM6NnNG0TM6ME3E6eC29L9LaSgks4m7sxqfbbJLBNTD
	 7M4XIB4s64eqIY0DhWbXY9ksAT4xnYUZUyGU4LKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1235/1266] audit: fix potential integer overflow in audit_log_n_hex()
Date: Tue, 21 Jul 2026 17:27:52 +0200
Message-ID: <20260721152509.447461110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ricardo Robaina <rrobaina@redhat.com>

[ Upstream commit 65dfde57d1e29ce2b76fc23dd565eccd5c0bc0f0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -59,6 +59,7 @@
 #include <net/netns/generic.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <linux/overflow.h>
 
 #include "audit.h"
 
@@ -2034,7 +2035,8 @@ void audit_log_format(struct audit_buffe
 void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 		size_t len)
 {
-	int i, avail, new_len;
+	int avail;
+	size_t i, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
 
@@ -2044,7 +2046,12 @@ void audit_log_n_hex(struct audit_buffer
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


