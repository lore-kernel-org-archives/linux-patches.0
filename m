Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C13255E43;
	Sat, 17 Oct 2026 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259468; cv=none; b=jLyx8RYsv5NdAvNGgVzUccT9f9aEBf/6YJgVtJDbsenvyhD7wWnkADZ1f1oDhfkzflhHv3AXKjqkJAG7pRZUZtd2J4ADO5gsXUnLxN6jtwm3Msqs8ben3H8AIxdQR34MMTHV3AsraTo/4DKR3jBlnZ/dVncsOs19QiVhM6s9v6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259468; c=relaxed/simple;
	bh=TgJNR57lGo13t1cT+fDkN+3DjGmZTisGkRFK4bIszQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkiR0Cx1BN2M8d2qYOsdMbIgNaYbVjqwP3lkk+/dbgxV5Y53bPRtKqFT4egAdB2u0bYQCxYSSuEihdFjoiaU5dZCQNbncRoWxDtB3k6oyPYsW/qtZSSRRgaaWYAefv6paDbwFgGRAoPFvTIr7u3G4lAyflNhi6fYQktLdmnqN4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akfS2ZSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akfS2ZSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DF81F000C4;
	Sat, 17 Oct 2026 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259467;
	bh=YPDK2+awK1fwiICvWRNdYpL4jFzQIIdc9JsaWrnKpWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akfS2ZSivRp4Cv4Fh87bDE117zJLXHJ7gZcvCos8Ro3n3lZ3Ma1KAjg2WWMu1hpWo
	 XtvaN7y2Qf/nx5BQFy2NC6rdk/FfDc7DCh54pK0AcpqC5tWjLzjMJFzcuBrDfuTjL4
	 R0UYH1Hsso0KTgsoP8jjiclz8RR2vRyxX8fVcbc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1223/1674] netfilter: synproxy: adjust duplicate timestamp options
Date: Sat, 17 Oct 2026 17:58:15 +0200
Message-ID: <20261017160502.534279989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22bb132cfb9b94847d52d73614284b8c5ea8d36e ]

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 992c20bc8a4a ("netfilter: synproxy: fix unaligned memory access in timestamp adjustment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index fb071401d5c33..52f1f30f95add 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -232,7 +232,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



