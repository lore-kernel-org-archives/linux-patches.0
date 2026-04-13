Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C2B317152;
	Mon, 13 Apr 2026 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099194; cv=none; b=lOEl3iC/y+cmRK2CansQ1MRnGAxrsrYwCoT8oG6RjGDoC3SLwIOJmVtAYoYpeffr6kmF9j0yVXqTH9fHfrb1hfF3qWVY3QoEPjvgpEsQc+0GpsPQAqVoXb1Kw61eSJLQbyaXysw/eLh2atCltpnhMlMvxu/AtcLcK9yYMVKkF8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099194; c=relaxed/simple;
	bh=UntfPqHRcibJ3Na9iZKMes1xMFYrmDGsy1XqY99Aho8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZiwW0idT/vDMfZDFR5ZDPekosE1gw53lhzk/F68ZliR7j0j/sEkS7BFtoRw0zKg8iMEkm38rVRZD5Wu9yfLgz8tWh/5ki7BRcbvNs4nWQ3TXt7YxmFvm8xIMB9xCFp0ohFmj0MTw1qlYORkB0vtPnFNpof1QZ9e3Z6Eveuy2ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU0x18hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU0x18hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE89DC2BCAF;
	Mon, 13 Apr 2026 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099194;
	bh=UntfPqHRcibJ3Na9iZKMes1xMFYrmDGsy1XqY99Aho8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU0x18hMiMGCIsqZw1dnRwBmI7VXfe3Uhh2h8ntaWLgfiUic9GSYeQPVBXAkq4iyu
	 XM/5ply/pxmx9lv/GCGm5zZHqb6GdMQDTR8fXn/sObAJYshhgH83cOPH/yf1+PO0Dk
	 Siat70vc8167XUdJ1/OPQJN0RVuq11VFrtDuYo8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/491] netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()
Date: Mon, 13 Apr 2026 17:57:38 +0200
Message-ID: <20260413155827.041158713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



