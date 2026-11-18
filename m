Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041886;
	b=gLeJPR2zZWZ1ecvfRCPUlIsdfJuvLFZmAQ2k06IMfwxWa0TIijZpdrKkkbmkuA/dNMzw
	 zOQjPzlSHlvtf6ITD8hhmTjpllSUuq9LUd5lwxAQeF06MHHDgQb5YEmX+biSjq10lT7EZ
	 PXJWBZ84HsqdwP1E3Tb5MpJi04EcHSIkYjkT564Mw7SRN+7dqdtb/Ia+bGfar1C9q6iwL
	 xqWq/48oygJfTlKLwCtOj2w++9Bc1lzLgu7pOTAh+vEv0PEi8Ptd5kr7ecwy24hi5jMsO
	 Zto89Z08krTFqAJ3hD15gJ8m4pWBoLheTnzgeEZLm5ekwb7rnGLqqOKbRceIVwSjk2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Zekr+C7p+3nsjjr1nvhfd3YpQC1yHmbNATBXXQYUEQ=;
	b=5XVOK8jY3XXyC0Vy3vJCLsP5PHJoY8ol+24fJuqf1VptJafv5eXGRKhugND4BrZcDVn1
	 G+zFW82utXJUQcANuC2NXCpnmVbrCXi3JYkE3XRWFJLdYbPPPkgKbMWKc7A0e2yZOMfAu
	 +gvxYWsV1rnRQHiuiy7p4JYs4NAZzZyIHvhnwX8y6ODZrYTX+wuJWTkIVJONnZ6IUsZzr
	 qtMBgKdWP1T7BJZYSNoCTA3DhcOVIKwVv7+4rdTdXZZsorBQIqQy3FbCVXyXGEj7oVUb7
	 Ur5hpAuRupBsVE6HqBscgJkjW/Bq4u0veUnKxrFKkE4c3BJZF72BX0cOTPOU28X4qqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STy1R9aH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A774606A31C;
	Wed, 18 Nov 2026 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STy1R9aH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E651F000C5;
	Wed, 18 Nov 2026 22:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041885;
	bh=9Zekr+C7p+3nsjjr1nvhfd3YpQC1yHmbNATBXXQYUEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STy1R9aH02InyKkNyy5TuWWRno9PXwyk/lO2z3f/lKYsackyyAJ94eH7qTXL7yZ4A
	 nkfTG/5ZS9WGblRwd91c8Qg09+dEx3qv1Wg/TzkrZKoCahiRIMVNTPT+EpdkHZvAkP
	 vA5/X3dd5+unwjGtZ6mUyvsxhFiHvwSEsIL8gDIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Melikov <mail@gmelikov.ru>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2972/3318] bnx2x: fix header length calculation for encapsulated TSO
Date: Wed, 18 Nov 2026 15:59:54 +0100
Message-ID: <20261118150449.445388378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Melikov <mail@gmelikov.ru>

[ Upstream commit 4fc1d5bb448dfab391a96f949d02ad03ad8cda5c ]

Commit 80bfab79b835 ("net: adopt skb_network_offset() and similar helpers")
replaced the difference between the inner transport header and the outer
network header with skb_inner_transport_offset().
The helper is relative to skb->data, so the new calculation incorrectly
includes the outer Ethernet header in fw_ip_hdr_to_payload_w.

On a BCM57810 transmitting TCP over VXLAN with an outer MTU of 1500,
hardware segmentation emits packets declaring an outer IPv4 total length
of 1514 while the actual IP packet is only 1500 bytes long. The receiver
drops these malformed packets, severely degrading TCP connectivity.

Subtract skb_network_offset() to restore the original calculation of the
length from the outer network header to the inner TCP payload.

Reproduced with plain kernel VXLAN and one TCP flow on kernel
7.0.0-31-generic: 50 of 200 captured packets had an invalid outer IP length
with the original driver, versus none with this fix. Disabling TSO/GSO on
the test VXLAN device also eliminated the error with the original driver.

Fixes: 80bfab79b835 ("net: adopt skb_network_offset() and similar helpers")
Signed-off-by: George Melikov <mail@gmelikov.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261009-bnx2x-tso-fix-v1-1-1ebea422422d@gmelikov.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 7bab74cfb37ee..b83210f22a364 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3667,7 +3667,8 @@ static void bnx2x_update_pbds_gso_enc(struct sk_buff *skb,
 	u8 outerip_off, outerip_len = 0;
 
 	/* from outer IP to transport */
-	hlen_w = skb_inner_transport_offset(skb) >> 1;
+	hlen_w = (skb_inner_transport_offset(skb) -
+		  skb_network_offset(skb)) >> 1;
 
 	/* transport len */
 	hlen_w += inner_tcp_hdrlen(skb) >> 1;
-- 
2.53.0



