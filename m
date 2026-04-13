Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7E30FF33;
	Mon, 13 Apr 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097779; cv=none; b=Rdau6RILBBNcypP6P0L36+UJTmmT6uHNQXOzssDoJFpkmfixZVB2Zqu5Ffq45UKL41zTIyrO3AJ0nh+KQMO9y2lE+kVXBglkbjB4q59T6BYZV8wgsjIEQUXJt9oEN35iXwhqRdD/8j5yqZ9XR2Osu7fmx57I/uvYSgaCaNbchSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097779; c=relaxed/simple;
	bh=vPJ1j5W+6Gpi7vXLSBNY4ynfoz0yHP7dMJxmfD2HZo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ebc0zvPFjHlj8VkFaNoGZXA2jWFSsBSb+JL5vmGc/RlQVj243GLIQYUT53xtvBBCC3IVJrCGw3t7RAqJ50nIFLoxCddzsPdU0/cLyRT4digLzyurGS5atXdgxtU24cyfsAMI9bOX7AOA6mc0hsUyPE9Q6AkM/62kw3huSHZCRSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D93CTA+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D93CTA+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7307EC2BCB6;
	Mon, 13 Apr 2026 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097779;
	bh=vPJ1j5W+6Gpi7vXLSBNY4ynfoz0yHP7dMJxmfD2HZo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D93CTA+ZeWrp+j9JJbG/EtWuXa7esRQbP2aJ1EXm1rdBfpZKJQlRZGVRwwzGmud5E
	 KJtxqgbvxvsG1Q1bB5BYY8Uab+bm9A3rbZwQKpLRa4E/x0+2sDq7dTYxUcVmvXuuBB
	 I77H0EDhhPLa+BhFQ+KkYsNZlakJVrHGuraAibQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/570] netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()
Date: Mon, 13 Apr 2026 17:56:33 +0200
Message-ID: <20260413155840.297238781@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



