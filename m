Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B460819AD5C;
	Tue,  8 Apr 2025 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112516; cv=none; b=fTUOOt2qxmsQG8jPyyvWLEm3hDmgB0+9mlYVgdHesjKBl6CpM2aQG7QEegI8OMYpZtkhRy64HnxKt42X4VaKICE6CowiOM5trNAfhsYgC4Jgk1L6kYCS5XftZHLwn+81V40jrFDUylIR71rgeq8AdY9QTsTgcZOvf1dLlJi4uUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112516; c=relaxed/simple;
	bh=djSNcjgswygU4fGG12XgfJleiGTSbGXFs4yhJejD4Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyuow9jecVBUnQAPNCekHjxqD2LnmQ+bYR5o3cx8oVmLBBsOjo+kZYVLaJG+Cvos5mj7ZX8qtJ4XhA657/KsSYelim4V8oTM03K/sh9mUYreYfHPYWYZ+HUWMCzCzlnawF9gufgpy/dnA8xCOHmHXWrjyaDOtMJW8Thr1TlJAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9wAYQeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9wAYQeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1AAC4CEE5;
	Tue,  8 Apr 2025 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112516;
	bh=djSNcjgswygU4fGG12XgfJleiGTSbGXFs4yhJejD4Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9wAYQeD5ub6jAECE99RW9NL1y8sYb/WOErdtT22/X37JQpMPZyx3Nyq/bnvZROQv
	 oy9ZlP7aa/kEGuY+CWsc/A2AWYH2gif9G4gvkL67cf2fyLA1jfJ4XXi0vhvSdzzP8L
	 Lpm5RW/aca9H85ZruWBzgKLLy5ourZ+uldkNuXIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/279] xfrm_output: Force software GSO only in tunnel mode
Date: Tue,  8 Apr 2025 12:47:43 +0200
Message-ID: <20250408104828.503036841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 0aae2867aa6067f73d066bc98385e23c8454a1d7 ]

The cited commit fixed a software GSO bug with VXLAN + IPSec in tunnel
mode. Unfortunately, it is slightly broader than necessary, as it also
severely affects performance for Geneve + IPSec transport mode over a
device capable of both HW GSO and IPSec crypto offload. In this case,
xfrm_output unnecessarily triggers software GSO instead of letting the
HW do it. In simple iperf3 tests over Geneve + IPSec transport mode over
a back-2-back pair of NICs with MTU 1500, the performance was observed
to be up to 6x worse when doing software GSO compared to leaving it to
the hardware.

This commit makes xfrm_output only trigger software GSO in crypto
offload cases for already encapsulated packets in tunnel mode, as not
doing so would then cause the inner tunnel skb->inner_networking_header
to be overwritten and break software GSO for that packet later if the
device turns out to not be capable of HW GSO.

Taking a closer look at the conditions for the original bug, to better
understand the reasons for this change:
- vxlan_build_skb -> iptunnel_handle_offloads sets inner_protocol and
  inner network header.
- then, udp_tunnel_xmit_skb -> ip_tunnel_xmit adds outer transport and
  network headers.
- later in the xmit path, xfrm_output -> xfrm_outer_mode_output ->
  xfrm4_prepare_output -> xfrm4_tunnel_encap_add overwrites the inner
  network header with the one set in ip_tunnel_xmit before adding the
  second outer header.
- __dev_queue_xmit -> validate_xmit_skb checks whether GSO segmentation
  needs to happen based on dev features. In the original bug, the hw
  couldn't segment the packets, so skb_gso_segment was invoked.
- deep in the .gso_segment callback machinery, __skb_udp_tunnel_segment
  tries to use the wrong inner network header, expecting the one set in
  iptunnel_handle_offloads but getting the one set by xfrm instead.
- a bit later, ipv6_gso_segment accesses the wrong memory based on that
  wrong inner network header.

With the new change, the original bug (or similar ones) cannot happen
again, as xfrm will now trigger software GSO before applying a tunnel.
This concern doesn't exist in packet offload mode, when the HW adds
encapsulation headers. For the non-offloaded packets (crypto in SW),
software GSO is still done unconditionally in the else branch.

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Fixes: a204aef9fd77 ("xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 4dc4a7bbe51cf..29ce7f6f16a09 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -737,7 +737,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-			if (skb->inner_protocol)
+			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
 				return xfrm_output_gso(net, sk, skb);
 
 			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
-- 
2.39.5



