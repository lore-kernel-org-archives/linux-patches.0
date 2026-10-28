Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211427;
	b=4TqIvaY9CdilP201NOI2Z1OnKRgBfGQGG6mmaznO10IHI1cK3xY1X97cB92nV8Ciup5L
	 4KCPvg/OW96fP4geHTTJX0V0Eclz221Uovh2ALMtn6nWPVEho9e6TApcuX47IzQseCZ7O
	 Hjalxjlsr7QJOp0HJVGyfHncVVLEUR2x79WghZEmm7vM2jBDxU0gYeiJs5TZjXERF5Huh
	 tkyd2gJLuOx1PD39R915AE6zXx6udxVEWR62Xn+9W2/ZjFlpUnRp8g1hk8woSbJyyWWG7
	 cHQuU2vQtKpoNv/xcDv/MCNTG6WtZ0V5WT0wr2cjEHV6iDzhuIsv2DAqnJ0VqEsMXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=clvKQo6iRQIItItnyAhB/WNHtXUaXN9JSBawe6Z9hTY=;
	b=biMcftFUYs1CauVwiMaut3+zE+FqkL0f6l0z1g0OkMt9G9eLBHshjGO2mTXcpvBcAVN2
	 m2peKRLwFAoGZ8kmYemHTWsmouN65+HbZSQzaiXskGakLLJVZh15OmSvOIjp1BGxGTdlx
	 ylaRWlFUjyjLD8qiu/4TIbZH9O+9zkEX3BD5S2xD6OZqa3SUN/BmnA1pugqJndCoNhXI3
	 drNTarCrpap/MSYQNIY2PJKeq7zteFkhJkdXpsVkm+dCNfqJWTLSrrqcCYjKOAEz/9fKQ
	 5LQkcXh8nFwXq9HCb0BOFMAvKE4uRQLWar4aWsvfCw5rOLyZTa4KTLBZmhLzp98exww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSI0Rny+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6F606A31D;
	Wed, 28 Oct 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSI0Rny+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF68D1F01825;
	Wed, 28 Oct 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211427;
	bh=clvKQo6iRQIItItnyAhB/WNHtXUaXN9JSBawe6Z9hTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSI0Rny+Ro1RH2s6rhRzqyusQ7CB2+dJdoe42VfwWGIim5rL207aGcyYd34JN/3Sx
	 r5SONgv/M4gl99noIwZYw2sXZ6vhXt6/+/ozSirSk6b5g2MTugtFIDE6ge6JRhoa/C
	 BT9Ne9f9XQ08oeMQGvMa88yTKNJ9EKEULyxG45xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Karl Bonde Torp <k.torp@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 375/571] nvme: fix swapped ZRASF zone state values for full and read only
Date: Wed, 28 Oct 2026 17:58:42 +0100
Message-ID: <20261028170016.910191211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Karl Bonde Torp <k.torp@samsung.com>

commit 564e46d9f6e87912effa03f123d37a511d520f09 upstream.

The Zone Management Receive command Zone Receive Action Specific (ZRASF)
reporting option values for the Full and Read Only zone states are swapped
compared to the NVM Express Zoned Namespace Command Set Specification,
Revision 1.5, Figure 35:

- 5h lists the zones in the ZSF:Full state.
- 6h lists the zones in the ZSRO:Read Only state.

The nvmet ZNS backend uses these constants to map the ZRASF value received
from the host to a block layer zone condition when filtering zones in
Report Zones. Because of the swap, a host asking for full zones was given
the read only zones, and a host asking for read only zones was given the
full zones.

Swap the values of NVME_ZRASF_ZONE_STATE_FULL and
NVME_ZRASF_ZONE_STATE_READONLY to match the specification.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Karl Bonde Torp <k.torp@samsung.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nvme.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -957,8 +957,8 @@ enum {
 	NVME_ZRASF_ZONE_STATE_IMP_OPEN	= 0x02,
 	NVME_ZRASF_ZONE_STATE_EXP_OPEN	= 0x03,
 	NVME_ZRASF_ZONE_STATE_CLOSED	= 0x04,
-	NVME_ZRASF_ZONE_STATE_READONLY	= 0x05,
-	NVME_ZRASF_ZONE_STATE_FULL	= 0x06,
+	NVME_ZRASF_ZONE_STATE_FULL	= 0x05,
+	NVME_ZRASF_ZONE_STATE_READONLY	= 0x06,
 	NVME_ZRASF_ZONE_STATE_OFFLINE	= 0x07,
 	NVME_REPORT_ZONE_PARTIAL	= 1,
 };


