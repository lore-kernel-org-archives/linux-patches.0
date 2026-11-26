Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705388;
	b=twSkYQu26Ni4bmFt8/IU9k8xeNrWTVx0lzxdNLSE61zNWmM8U2d6vOG18qsSC/r9S6sn
	 T1ydzsq6Pt+SBGJjIfKev/fH8lAHjgt1mTAkiN5fvwHawaFlPte3VV045AvR9tvwIvnmG
	 Zw5lX1BJSoWJxbBNf1sRLh7cvDAc3kXkgjyXtw6Z7IWd/cO7+t6Rafjw8C0lsPqytMhTo
	 XpSFHGhxjDxZ9qiMv+QYCA4Z22X7W/exRoSzCmA6UjWhcl261Zz/Dr1Fqq6Zqa06HtPsV
	 6xLXxT6kd0g7H0GtvHB0qhCyw58XFholODsC38PUW/etsiv0YsEtZSRvu7nmGydBoLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hDDKx2R1pmrFyhgg/tAp+jsbGb7wA04uVk0w6lHyLYU=;
	b=vsrhD9e7Rlv4nCjv//xbM5c7KMQZG5IdbKnhz8tYU16GESw3PpQbSysz7P5PcjTw/pgK
	 IkC5HhabK1F8z2K8Yma2dj6X9hv/sqwBYBy5c/ibNiEwxfrPAwiXSlAzhk9FLKi1Zpuw0
	 ppohKMKIE9XeckZ9shd+g5mL6Y48Xa37hdf0ecyA7TF8WAbfXXpAyy0p52ouQE89qmpAL
	 JwkVagDN9WWIG+S5BmlCgd6vMyEXfe8XCTyP4hU5N9KdYXothVVQTltqK22xyT51EEnos
	 WWHOIXMTNI2fJYYxe336s1Ee2N3HXv3eeXaK1JlgBmOKHolIh1k9eux+4kYU059Lm4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/tPGOxj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820A606A31C;
	Thu, 26 Nov 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/tPGOxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933B01F000C0;
	Thu, 26 Nov 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705388;
	bh=hDDKx2R1pmrFyhgg/tAp+jsbGb7wA04uVk0w6lHyLYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/tPGOxjgkVUZFFzxZiqa24VDLoaMmkwwhGvXDaaH3XEuOHXcS6RyMCo5ySkV58tQ
	 7IlWZezjAqWag2h5Mjs/hNhMOW3xiGtyc9NDBr7Nh6KMx26FUzJK+oeYZHp1mMyhYI
	 PL6cLIEilEesXCoIxt+WvO7fio32g0uLUbmu02DU=
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
Subject: [PATCH 5.15 182/319] net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp
Date: Thu, 26 Nov 2026 15:39:10 +0100
Message-ID: <20261126144010.854227434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,6 +79,8 @@ static inline int skb_metadata_dst_cmp(c
 		return memcmp(&a->u.port_info, &b->u.port_info,
 			      sizeof(a->u.port_info));
 	case METADATA_IP_TUNNEL:
+		if (a->u.tun_info.options_len != b->u.tun_info.options_len)
+			return 1;
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);


