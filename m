Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24AF1A6815;
	Mon, 23 Mar 2026 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274198; cv=none; b=dQHSHmcKiNrRWla20HKfiatGEUjGUPktj8wbXNr5qELEYXcowS9DjR/jY6I4jK1EHt35i+3sgM9h3IABMaJLBam+NVisaOQwJBiCFcG/NVwPN7wF839DXExJnGuCKQZJIX+gsZeczYoHApIrTsNczana++fiI5tE6Fo807shdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274198; c=relaxed/simple;
	bh=Um30luMYxWKuWS8dIm9gfKJFA154LC2TyQ10aDORglU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gaILcrKnXoYFZuN/95drBF90QNQUANPy6QX2OjcwlK6azp0CGIFTwr8i1i+mfjh2Z0EZX3XLB2a78OXTZpvIz9CJi/oKYleFxKOe8SJ6A2yRwNNttnZ51HZfMdMya4mRAiIODKnVdkOG/laQHYA9shNEQ+np/PI9ZkeC7TJgMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZPJ2O0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZPJ2O0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A73C2BC9E;
	Mon, 23 Mar 2026 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274198;
	bh=Um30luMYxWKuWS8dIm9gfKJFA154LC2TyQ10aDORglU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZPJ2O0nldtScfGpsgDzhwwUu7K/+nIGHQ84OEw7Ttqqg04GnNTzyucHz3KE+22Vm
	 bMIP6TsOTFniPiOTSN1RlPshrFNXmIUc1o6vP2k7s8VFYTNjK3j5JqWzPgzj5zx75p
	 MxNy/CsbpCK4OULvm+8qEmWZZArDAqje9HjxXIEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 141/220] netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()
Date: Mon, 23 Mar 2026 14:45:18 +0100
Message-ID: <20260323134509.020340452@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



