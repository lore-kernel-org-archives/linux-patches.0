Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACB33DD849;
	Wed, 30 Sep 2026 19:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796302; cv=none; b=soKv4SkkYiZgAd1wLbl7nmM9HBWnFbhSImd/p3HztWQFTShvP9kAm+w4XD9d55sqYt5/+6HKtnP7rJvnwftitq3CwegZ8Ygi56KafB0tkKcQgAXgrYtO4uyfncD1BkYEU22PYgBWPmcvqqJ9ZfKMtAsOJ17oJ14EAU46ZU1N68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796302; c=relaxed/simple;
	bh=4wIHSIvScGbv/gYpmDQxuVOF4L08AGm5v79YTk4dSNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlXhg8gdQbZAm4QIQ2L/DAh4g/0j7iKB6p9rCPBvnuQvtJfH5tjFiKTAmzp1eUrsJzUJJV7KpLNiPVq+XOwydYcVc7koTAS+gezS3N7hnWO0VF4n+98DAWi3y7pW+pCs5tBhEKlK1e/jRYpBkQfILUPWq1gjo5NY88uKgGafUv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebNbbtKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebNbbtKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CCF1F000FF;
	Wed, 30 Sep 2026 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796301;
	bh=DkO86MPbo3ufOmtL09y/+OF9eKucYDUhvUBkBJqVkJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebNbbtKk96Njf3vGKGd6I0adY5EIWqBzHVZQsBwWXDVOUzI1B4D0yuR0yTIRf02jj
	 I+5AYZnVRiY7ijwmwAADkYjnyzwd46CcUfaFHNlSBt+zG92U7SUpiHrmuy18/yVYw8
	 r6un+8JBgjDn0yYIS8AWvwzy8eVXUqmKimejPNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0866/1193] net/packet: avoid truncating TPACKET_V3 private size
Date: Wed, 30 Sep 2026 17:25:50 +0200
Message-ID: <20260930152453.476122506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

commit 37213e61120297920ae4c937fcb326a360da5084 upstream.

tpacket_req3.tp_sizeof_priv is an unsigned int, and packet_set_ring()
validates the full value against the block size.  init_prb_bdqc() then
stores it in the unsigned short blk_sizeof_priv field.

Commit 2b6867c2ce76 ("net/packet: fix overflow in check for priv area
size") fixed the validation arithmetic, but an accepted value above
USHRT_MAX still narrows when it is stored.

For a 131072-byte block, tp_sizeof_priv=65536 is valid.  The narrowing
makes offset_to_first_pkt 48 instead of 65584, so packet records can be
placed in the private area that userspace asked the kernel to preserve.

blk_sizeof_priv is internal state, so widen it to hold the validated
UAPI value.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260913-b4-send-packet-private-v1-1-925eab2cd388@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -21,7 +21,7 @@ struct tpacket_kbdq_core {
 	unsigned char	reset_pending_on_curr_blk;
 	unsigned char   delete_blk_timer;
 	unsigned short	kactive_blk_num;
-	unsigned short	blk_sizeof_priv;
+	unsigned int	blk_sizeof_priv;
 
 	/* last_kactive_blk_num:
 	 * trick to see if user-space has caught up


