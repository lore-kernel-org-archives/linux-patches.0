Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F974F393E;
	Tue, 13 Oct 2026 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895822; cv=none; b=Ia73iY67fMnP62HH+xSan2OaXdzExub84fk4JxZniESh6JqGblXYbIlR5Klv13O3xTDZsue8X7b9Q8b6ODELlmtQH1lpdzHX/oO5Sx2y8btnD+XKNagTOtQX7/xa1Bk7aP5mPlpjjElNZp+08T6Cb1gF9A1D1vXQbC3E2GQGcSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895822; c=relaxed/simple;
	bh=9XFIianswF5iJCvIorwZAie1syCPJl51i+ZUl6VSNSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez+h+LPP0Btf0h1sF5SXGp1VQRtq8GZ54TRue4F5WkRb3ZZpC1z70qlf/l+IhWjwKiny/mbpVIqhz39bpw/NR/T4xH52PDLCHXzeR7c4FGNu6dm2xwzK0MC8o6GSLZAyvjuV5gNuU2g8KwRJkdxOApdGTq7I4qOKX2k/ZSp4KOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zbb830VN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zbb830VN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A057E1F000FF;
	Tue, 13 Oct 2026 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895821;
	bh=kwFkLBflllgYa8hmPCkuxdQfixfXw8kJzKTGOFDqG50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zbb830VNA07DU0gafzHV6O7MtOC8oDcbhyi0Bukq3dW9zywvqiz22O2ygOMXU6Idh
	 C98Vh1ytPoVnjUKwk7X9HPtEcRPkkMvBhMqXBCEG5PzOiqiUIKk+WDRxxyALSXl8El
	 NNFwmZa14VJgfaLX20IBh6vrvjCMrYJoHa7tttqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 403/497] net: skbuff: dont leave stale bytes in skb_copy_and_csum_bits()
Date: Tue, 13 Oct 2026 13:39:30 +0200
Message-ID: <20261013112917.455608167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3616,8 +3616,12 @@ __wsum skb_copy_and_csum_bits(const stru
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


