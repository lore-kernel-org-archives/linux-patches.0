Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75B4ED1B4;
	Tue, 13 Oct 2026 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892171; cv=none; b=Kdbk//3aiQS6jW52Z+3DMjUz9wlPJIBcXWTA4CUcEpylznjtZFKZYq5PFdjvm23E1HWJ+ZdeDJ5JhdPXfC9YZ8QcPoE1RjQ3HAGFm6RKKdgXWUeuWhEBoIZQ1fVNmQbP68blyuvwa3esQ1EODDxkUuRvzM70LXLHKmDhwDHD2Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892171; c=relaxed/simple;
	bh=Ou5A/oP8cCP6ZP71aPEHlS3X2jx9+bnkLGes9W/rXRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKGC9ThlYKydKjhpBbOu/YlKlEbsJmklk/xNdos63apJU6tRZzY3aElAhmaEs58XvFZyyY5VgRb1h4laWU6g24Tlex3MmrbqUchr0qEJ83HB2MXoZe8UW49721tRge+X7mrdIsYC71gGyaYVRQ8M3h0OGy31AyTMCYB/vRxsohc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrOY1EHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrOY1EHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B21F000FF;
	Tue, 13 Oct 2026 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892170;
	bh=ezeI5f2UdSD1+wCqsy2T7QDqfsg6HYjq3ggeSsmRWuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrOY1EHHVh1VDl5WjxFaXdFBXfRiFjFNmMT9H2ZRJZNelrkAie+ngjLPS5E0kfFrL
	 Kq8ISiNEwjNXxAEaYqgsXAdSvlmLps1EgEWotJPdvie0YHiaHboBNUgjSfYMFA4CVE
	 PxtAAR0n4RYiSyEFXvX1PsuJHtjO12+TYVK8BVVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 085/281] net: skbuff: dont leave stale bytes in skb_copy_and_csum_bits()
Date: Tue, 13 Oct 2026 13:36:41 +0200
Message-ID: <20261013112857.195384064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit ab9414ed70bd783e902a85c350620dee269bcb2b upstream.

When skb_copy_and_csum_bits() reaches unreadable frags it returns 0
after copying only the linear part, and the rest of the caller's buffer
is left as it was.  The callers copy into a buffer that is about to go
out on the wire: an ICMP error quoting the offending packet, or a
driver's TX bounce buffer in skb_copy_and_csum_dev().  Neither buffer
is zeroed beforehand, so whatever was in memory there gets sent.

Zero the part of the buffer we didn't fill.  The checksum usually
won't match the data any more, so the receiver will usually drop the
packet, but either way it no longer carries anything it shouldn't.
Only zero for a positive @len, a negative one from a broken caller must
not turn into a huge memset().

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20261007-b4-skb-copy-csum-stale-bytes-v1-1-adbbde033fb3@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3633,8 +3633,12 @@ __wsum skb_copy_and_csum_bits(const stru
 		pos	= copy;
 	}
 
-	if (!skb_frags_readable(skb))
+	if (!skb_frags_readable(skb)) {
+		/* Don't hand the caller a buffer with stale bytes in it. */
+		if (len > 0)
+			memset(to, 0, len);
 		return 0;
+	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		int end;


