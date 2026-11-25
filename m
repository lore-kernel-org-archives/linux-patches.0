Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622964;
	b=zPk2SCdbFAiL03zXsjVRKweIw0nKwA8/rQ0mKvaY7RYHLlIH/w7E1AKdaTvo+MFvmX9z
	 jvATxsgIVDjXhmyGorjgE9Rt/FvQpalkClufQXF9BaJ/2hCnHxceuNQ0qqPCcpuS2YTTK
	 kxKWlDRJTnCDXhAkU/qsAndejc8K1e6Xi/yMS6ZzuKpJIaCY5fC4L6db8JeIiVRJ8oJus
	 uw3jNHURiQc4ia0EP1EnRwSFXszNRkBTRKxb+uxI1wzfdpc5NbG+SyoCsAzLcSZSO9AYD
	 xXajakN1VXqGfLxH/RjoXGNI0hs7Mw/rNGnh/3rmEPW/CAhGL7dwdmu2lP0oVL4Binw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tO6Sb8MzESzhRDTH+PbmpCeofEVfsGmsNrAzLkCrdCE=;
	b=ipqqBQ8vQRlQMQ+Sq3ZyFbBcZxAtrxXJcx4Fso1eiwjqzLRylBHfGuLph8xtHhvAeq7S
	 DsXOtjop1CbEz9XhkC6sw+fbxnGvqEa8C/qnK4M2e/p/Y/uzgG7DgONEJVjmJVmRSGL4C
	 YOaRJhNu10fmR+wkwnbk4hdJydsrTSbqV/fKalyd11DJJNzz11J/wSUVgwOTOAzctWhFZ
	 +YQmbf5Uob9O45KOjt3ZjRaHExU7sHPUjEDHsl7bICTK7aw5dFVvs/Pmeg0gpb/sZICji
	 RXrCGUNrVS8EIBU13kfj3bqZdZzv7sR/IbmTaw9bQOy2iKuflv0u8dv8REvfvmrDg4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJjW06Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD2D606A321;
	Wed, 25 Nov 2026 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJjW06Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9361F000C6;
	Wed, 25 Nov 2026 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622964;
	bh=tO6Sb8MzESzhRDTH+PbmpCeofEVfsGmsNrAzLkCrdCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJjW06GkeKWeY876zgko4ZsfX93dagU665cbgrhaBMEAEGLEJxPxewV3qYNJTUrGK
	 XBR/mZQRcn6rLZ7VvwIVvorZZ4PiYY7q26LL7cbgGpyHL7d61ctTkKrHetG/louLLo
	 VKZ84oAVclerKgVahfTOHIR4yzk6T/YMEFVXHKAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Sasha Levin <sashal@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Kees Cook <kees@kernel.org>,
	Jean-Paul Sergent <jpsergent@gmail.com>
Subject: [PATCH 6.18 689/990] net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp
Date: Wed, 25 Nov 2026 15:34:16 +0100
Message-ID: <20261125143838.227807237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Paul Sergent <jpsergent@gmail.com>

commit 74a7db839308dd7d1c3f72dd1e3299784df3affb upstream.

Commit 3fcece12bc1b6 ("net: store port/representator id in
metadata_dst") dropped the options_len equality check when converting
skb_metadata_dst_cmp() to a type switch, so the memcmp length is taken
from skb a alone.  When skb b carries fewer options than a, the
comparison reads past b's allocation.

Hit in practice with Cilium geneve GRO aggregation, comparing an skb
carrying 12 bytes of tunnel options against one carrying none:

  memcmp: detected buffer overflow: 108 byte read of buffer size 96
  WARNING: CPU: 0 PID: 15 at lib/string_helpers.c:1036 __fortify_report
   __fortify_panic+0x9/0x10
   skb_metadata_dst_cmp+0x11b/0x120
   dev_gro_receive+0x303/0x620
   gro_cell_poll+0x67/0xa0

Restore the check: unequal options_len means different metadata and no
aggregation; the memcmp only runs when both sides carry the same
options length.

Fixes: 3fcece12bc1b6 ("net: store port/representator id in metadata_dst")
Cc: stable@vger.kernel.org
Cc: Ilya Maximets <i.maximets@ovn.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Jean-Paul Sergent <jpsergent@gmail.com>
Link: https://patch.msgid.link/20261109082410.206140-1-jpsergent@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst_metadata.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -116,6 +116,8 @@ static inline int skb_metadata_dst_cmp(c
 		return memcmp(&a->u.port_info, &b->u.port_info,
 			      sizeof(a->u.port_info));
 	case METADATA_IP_TUNNEL:
+		if (a->u.tun_info.options_len != b->u.tun_info.options_len)
+			return 1;
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);


