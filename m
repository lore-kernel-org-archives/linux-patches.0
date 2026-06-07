Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A9D2D3A69;
	Sun,  7 Jun 2026 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828706; cv=none; b=TQXcMJUxBsOFFvIAmelpIPIDkCxsz56mR/hBUon7lPUaF4r+KNHf/SGUOvJ0zEt8G1oNzlmViLt9Y3MMH0WIeDupK5/4k7bejdGnd30xtEeMKOjH2B6RNZrqIrpkb5Z6nru1POSM6bKWkHp464U2/NLRe+q2yq0iXaVHjBSJ+DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828706; c=relaxed/simple;
	bh=87e8ItxBtgjyNhNx+O2t0WNKkJlxlGrZKxr337TuBY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuEa94mmakiXbLrJ0Y6H6jNEVihnkouhI11USQ64TYsYh9Bb69X62MQFwgzlH/5/hipEkPS5dqwFZ3iETXj1IsM0ok8br4yV/CzgMv78G7OrBhNnJXS3N0wncoEsFsvpfn1Krbh0pu0EVNob71hJJhQl6Uag5xdEWHOTwO9aUqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKLxN0cT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKLxN0cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D00B1F00893;
	Sun,  7 Jun 2026 10:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828705;
	bh=Yv8CDsTFHrJPjEmfZLwQO/r5ftKh8vKqguwZxQ89P+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKLxN0cTLthf84rBN1qMxKrqF28HeHMzuDlKLK/8xeUQ7JHXtwhBRHBlhXiZUF3Bu
	 xsUvPMXYarwVyvonQTLh0V2WBNDaaTIrzlSG8mtcDB5niQ5wQSlvO7OenlJm5dOpno
	 9YFL+UYpRwWtzbM53+SmTzjYGoWSGnYG+zdOgjZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 184/315] wireguard: send: append trailer after expanding head
Date: Sun,  7 Jun 2026 11:59:31 +0200
Message-ID: <20260607095734.339841135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit f75e3eb08fe31d30a9af6ed80cdd22e6772837e2 upstream.

With how this is currently written, we add the trailer, zero it out, and
then add the header space on. If that header space requires a
reallocation + copy, the zeros in the trailer aren't copied, because the
skb len hasn't actually been yet expanded to cover that. Instead add the
padding at the end of the process rather than at the beginning.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20260529173134.3080773-2-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/send.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -177,16 +177,6 @@ static bool encrypt_packet(struct sk_buf
 	trailer_len = padding_len + noise_encrypted_len(0);
 	plaintext_len = skb->len + padding_len;
 
-	/* Expand data section to have room for padding and auth tag. */
-	num_frags = skb_cow_data(skb, trailer_len, &trailer);
-	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
-		return false;
-
-	/* Set the padding to zeros, and make sure it and the auth tag are part
-	 * of the skb.
-	 */
-	memset(skb_tail_pointer(trailer), 0, padding_len);
-
 	/* Expand head section to have room for our header and the network
 	 * stack's headers.
 	 */
@@ -198,6 +188,16 @@ static bool encrypt_packet(struct sk_buf
 		     skb_checksum_help(skb)))
 		return false;
 
+	/* Expand data section to have room for padding and auth tag. */
+	num_frags = skb_cow_data(skb, trailer_len, &trailer);
+	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
+		return false;
+
+	/* Set the padding to zeros, and make sure it and the auth tag are part
+	 * of the skb.
+	 */
+	memset(skb_tail_pointer(trailer), 0, padding_len);
+
 	/* Only after checksumming can we safely add on the padding at the end
 	 * and the header.
 	 */


