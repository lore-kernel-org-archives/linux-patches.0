Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062459;
	b=diE7MA9Tmb/xTbZIhw1Ks9iS7AJCigcDXlSUidd4QI4kkdTP7586QJLHyKvxQuomDi9U
	 4Ia4RW4zUS25qgGJwEYvlw5+fL5xZWfL8O28No1k7DPy7XDvZMyCisuvoV3P7F3Sbuvvc
	 pqONTbTDcRThxpWZ82pcxiVbR6LGZLoU/544J0SQWVky2j1USmqMQYw873DDPf384M2CB
	 CKUW/RTtLMqQWumabEDE3KQT+u/KL/v6zui2lhzcVCMKQZHfXo+GOGFtS4Rujumt86md4
	 sPzBobqc2U/o9bwX62QFLrvic+zQ563C5YyZjppJ1RCzH4Bi/7PN+uk5xxmqSDMpnxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ED/E+VnlaKtVOJqi+gO8yQD+HZtYxbT9sQnWAEDn7/M=;
	b=gfhIB9d2vIBPaibKQIOSPQg/dUXsWoiQpIdf+eiecmapCilZpARVANBulraoS0sEr0Qv
	 vLWKXOMen6z/Mf3ryaLhLbcoomzrjHTKYFGttboeLm+lkrwUHLSu60pQJOqHal7KUgPmH
	 RyvWqZea8/3iw7/hxCxqNyx+tDtgb/rqKeUMGGmOkV0eoG0hOPPxNLYymTB4RzceRyNA5
	 G5NH3dekWmGmrVdtYY47XX0XDj1OhuTofZBuxccNPgi7u5tglmSdzxhvVP27COspmwwRF
	 mgCaFxcu0jmXJaTYA1mZkdtAl314udg7aJaYAR5XcIlg9S/ydAwSR/wacZJ8RdLNMnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guJTSE2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798E606A642;
	Sat,  7 Nov 2026 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guJTSE2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CB1F0089F;
	Sat,  7 Nov 2026 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062458;
	bh=ED/E+VnlaKtVOJqi+gO8yQD+HZtYxbT9sQnWAEDn7/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guJTSE2tttoxJvU+9A+aEFHPBsIAcN0S8FwAcCYRc9nSz2g2Ud/lHEzWpOBEJZtQL
	 QBngmLxk2FyMXERoinIEP64G+lo2vUX7KSpyMlFEdnEBVsMWAAetfuWnQDc80SYZ6f
	 JxSABwc9Fk6XRcGgQf8ZyXSLrQ1VoqmOJanME28g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1327/1536] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Sat,  7 Nov 2026 08:55:43 -0500
Message-ID: <20261107135035.088238911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 56453199d28f0072a8196fba14b2d702632e2219 ]

skb_copy_and_csum_dev() copies everything up to the checksum start out
of the linear area, and BUG()s if the checksum start is past the end of
the linear area.  It misses the other direction: a CHECKSUM_PARTIAL skb
that has been pulled past its csum_start gives a negative offset, which
gets past the check and becomes a ~4GB copy.  It also trusts
csum_offset when it stores the folded checksum.  So far
skb_copy_and_csum_bits() BUG()ing on a short skb has covered for that,
but once it returns instead, a bad csum_offset would write past the end
of the caller's buffer.

The function returns void and its callers are drivers copying a frame
into a bounce buffer just before handing it to the hardware.  There's
nothing for them to back out of, so check both ends of csum_start and
that the checksum field fits in the frame, and if not, copy the whole
frame with skb_copy_bits() without filling in the checksum, with a
DEBUG_NET_WARN_ON_ONCE() for debug kernels.  The frame
goes out with a bad checksum and is dropped by the receiver.  If even
that copy fails, zero the buffer so the driver doesn't send stale bytes.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable? The trailers only have Assisted-by: and Signed-off-by:. No
Link: https://patch.msgid.link/20261007-b4-skbuff-bug-on-v2-5-b9a5f732895b@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6d7e2d48cc492..04862f052adcf 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3887,7 +3887,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
 	else
 		csstart = skb_headlen(skb);
 
-	BUG_ON(csstart > skb_headlen(skb));
+	if (unlikely(csstart < 0 || csstart > skb_headlen(skb) ||
+		     (skb->ip_summed == CHECKSUM_PARTIAL &&
+		      csstart + skb->csum_offset + sizeof(__sum16) >
+		      skb->len))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		/* Send the frame without the checksum filled in, or send
+		 * zeroes if we can't even copy it.
+		 */
+		if (skb_copy_bits(skb, 0, to, skb->len))
+			memset(to, 0, skb->len);
+		return;
+	}
 
 	skb_copy_from_linear_data(skb, to, csstart);
 
-- 
2.53.0



