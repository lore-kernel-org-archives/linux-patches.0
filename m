Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7153AA4FD;
	Mon, 23 Mar 2026 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274876; cv=none; b=MaOiPYO1AGGdyJjKxx28ZYFmpbHLqxeEpeOsje4hPex9eB579iJUY64nK/uUZO27ungNNQ2kjhl8oyyC82qck+RIeJ0Vblu8uaMwhx4qnbmySgUvUvjXABYiW74/5pahR6gB1IcM/5R8tRN6VN4lz/MxArVknT/jm7tJDfpd40E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274876; c=relaxed/simple;
	bh=Zc2k4AY9EOXHdE7XyBmv32zSRerT3AjCsFy0ElMihoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGckS+gAKYgyxH+rPMsZlVQaSXg7PiMxhyArbh9C8ATDvjTU14CHotA++Oe6CRv2mXEVGJQBDfaZCeAclRsaT8AmgPBkClMO/3ory7dQLhLfe3aovEgA0Ql9OfYqWHORwOg/B2USkOM4YeKwdnuQbO7Nreync7Vnz7nrtAakiUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmiTJW5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmiTJW5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A082C2BCB3;
	Mon, 23 Mar 2026 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274876;
	bh=Zc2k4AY9EOXHdE7XyBmv32zSRerT3AjCsFy0ElMihoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmiTJW5zs/Um+FhAJbqy3vJPVnNW72qUjuxdNNcZcthyApe4eHvlIjooKCBqixOXX
	 sV3gYwUZG9o/k31og2WZMepGzut+nzP6+d3T/+PFCk7SnVTlVClRm92DAylyA+bJJa
	 6VP+fMxzrKnzTkM5MlNENNfOukR4pI/gGv+XwwBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/212] netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()
Date: Mon, 23 Mar 2026 14:46:02 +0100
Message-ID: <20260323134508.230356102@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit f173d0f4c0f689173f8cdac79991043a4a89bf66 ]

In DecodeQ931(), the UserUserIE code path reads a 16-bit length from
the packet, then decrements it by 1 to skip the protocol discriminator
byte before passing it to DecodeH323_UserInformation(). If the encoded
length is 0, the decrement wraps to -1, which is then passed as a
large value to the decoder, leading to an out-of-bounds read.

Add a check to ensure len is positive after the decrement.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index c972e9488e16f..7b1497ed97d26 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -924,6 +924,8 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 				break;
 			p++;
 			len--;
+			if (len <= 0)
+				break;
 			return DecodeH323_UserInformation(buf, p, len,
 							  &q931->UUIE);
 		}
-- 
2.51.0



