Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A99D517;
	Tue, 27 Aug 2024 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772786; cv=none; b=j3PF7vYURMWI9X3qyL8bueq8f/Jr2HjTBywFLDYR9Hti3EHRvR1Np/YVcls7HTRctF1CzG7wsw5/lXL3Xh9pnTRphx9G2oD1Hj2fjJCAKcRRc9VPMZxz9RnqWa6D6komLXIpR9lAd0EK7xZkVzSQ/YFJYQrnEl74IoPLgWH/lMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772786; c=relaxed/simple;
	bh=WoUnFhe6DS+tZuSq0bTqhHA30XpnXoA4Fmj2KhmJb8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9kBRj7jrwNNFtcf0fORJoqIpfocSBPpjNnD+Zqy07zb+qBtTaFJBH4ZRcWXW/bT/4q5ut58YeW34roNF2qmBkoGxvO9lu8PazDLnlHSayqwLtVpuBI3s1cSkPLDXSOcJTNnfXBxhB5dc3sGQfMcmkeZSHvA3kY2tw+pmQ+lURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhtI/hIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhtI/hIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8BBC61050;
	Tue, 27 Aug 2024 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772785;
	bh=WoUnFhe6DS+tZuSq0bTqhHA30XpnXoA4Fmj2KhmJb8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhtI/hIf5bJYry2BnFvieJxtkCMndgR4FSJFzVV7bPCw2UoPP6h2l1aSrnyVcvx7f
	 CXhq2zDVD6xOYHo/I87ziNywOpClT8iCwAi3fLuZ9hWB1FIjPVMNzKXgAi8qcMhqRm
	 KhYmnsa0gUEHmP9WaWlKAAjGQoVZBjEQpe1VjBkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 319/321] net: change maximum number of UDP segments to 128
Date: Tue, 27 Aug 2024 16:40:27 +0200
Message-ID: <20240827143850.401502427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Benditovich <yuri.benditovich@daynix.com>

commit 1382e3b6a3500c245e5278c66d210c02926f804f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/udp.h                  |    2 +-
 tools/testing/selftests/net/udpgso.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -102,7 +102,7 @@ struct udp_sock {
 #define udp_assign_bit(nr, sk, val)		\
 	assign_bit(UDP_FLAGS_##nr, &udp_sk(sk)->udp_flags, val)
 
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


