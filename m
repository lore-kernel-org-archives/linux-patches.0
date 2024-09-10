Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9018B488;
	Tue, 10 Sep 2024 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963911; cv=none; b=F9mkPjSIvR6Gf43onGQv29Odk7p4UqkeDA32+glV+LWRFxcRLtUiNumFHjrSKU7/ox+BH9i8pn837Rk+07VEoygPeOiamFNH5tKmL94Jd6rePQwyFSmPHidZsGFUB7maTjEC5gyNd1D8pCsvAqYs7C4+IQFgL+WkWzuGRsInnHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963911; c=relaxed/simple;
	bh=tEZG4ccmUCynyqM7ckIsvY1HQT44jD+WHtPMYt/jH4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZeD4jr/+aK9hnKqmMVHoNKPepraBfFZW45vVdQQjMlO8Dvd6H+hnWHC12RG9nOf0dWJgBW7gfyjTwNPhDMm/qUG65XV6M1GFSL8q8dUhOrqf9DWgKN7QNu5mJO98RXO8Rj1cTQTjZHt8fdHNF8JH44i6LxKhqsp12jl8DscehI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsu0o1BW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsu0o1BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F36C4CEC3;
	Tue, 10 Sep 2024 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963911;
	bh=tEZG4ccmUCynyqM7ckIsvY1HQT44jD+WHtPMYt/jH4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsu0o1BW918l0baKlwnpNvWbenWe9XpLTzKzglt+D6Io2qy6Z5faArMT487C7tb+1
	 1sLWaiaw9Rp8FUQgtmIDCYauj6g9U8ckdkUnMN+2KrpRRb5Q6XZ28I36ZfwNrluMRe
	 C5IphgcMxJ34tyfSXuL/IZXhXnvKvzQrEXTCY+gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 207/214] net: change maximum number of UDP segments to 128
Date: Tue, 10 Sep 2024 11:33:49 +0200
Message-ID: <20240910092606.970151688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Benditovich <yuri.benditovich@daynix.com>

[ Upstream commit 1382e3b6a3500c245e5278c66d210c02926f804f ]

The commit fc8b2a619469
("net: more strict VIRTIO_NET_HDR_GSO_UDP_L4 validation")
adds check of potential number of UDP segments vs
UDP_MAX_SEGMENTS in linux/virtio_net.h.
After this change certification test of USO guest-to-guest
transmit on Windows driver for virtio-net device fails,
for example with packet size of ~64K and mss of 536 bytes.
In general the USO should not be more restrictive than TSO.
Indeed, in case of unreasonably small mss a lot of segments
can cause queue overflow and packet loss on the destination.
Limit of 128 segments is good for any practical purpose,
with minimal meaningful mss of 536 the maximal UDP packet will
be divided to ~120 segments.
The number of segments for UDP packets is validated vs
UDP_MAX_SEGMENTS also in udp.c (v4,v6), this does not affect
quest-to-guest path but does affect packets sent to host, for
example.
It is important to mention that UDP_MAX_SEGMENTS is kernel-only
define and not available to user mode socket applications.
In order to request MSS smaller than MTU the applications
just uses setsockopt with SOL_UDP and UDP_SEGMENT and there is
no limitations on socket API level.

Fixes: fc8b2a619469 ("net: more strict VIRTIO_NET_HDR_GSO_UDP_L4 validation")
Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

[5.15-stable: fix conflict with neighboring but unrelated code from
              e2a4392b61f6 ("udp: introduce udp->udp_flags")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/udp.h                  |    2 +-
 tools/testing/selftests/net/udpgso.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -94,7 +94,7 @@ struct udp_sock {
 	int		forward_deficit;
 };
 
-#define UDP_MAX_SEGMENTS	(1 << 6UL)
+#define UDP_MAX_SEGMENTS	(1 << 7UL)
 
 static inline struct udp_sock *udp_sk(const struct sock *sk)
 {
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -34,7 +34,7 @@
 #endif
 
 #ifndef UDP_MAX_SEGMENTS
-#define UDP_MAX_SEGMENTS	(1 << 6UL)
+#define UDP_MAX_SEGMENTS	(1 << 7UL)
 #endif
 
 #define CONST_MTU_TEST	1500


