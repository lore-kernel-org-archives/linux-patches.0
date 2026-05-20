Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCD53ED5C8;
	Wed, 20 May 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299076; cv=none; b=Uv9yqbL7kEOXzilE+M170GexqD+NZti/ExQffNIv2KcURxOUOHT6mHwMMUOWlfd6aFp9PMSoInyQA4uiME7bi91P1rwBhD+mmGSBH1R0tTYNunaZIqZeiD/5pt+0x6E3ISmG64bY0m+NBrS+lT/H/33KlHEaQdOg9uQWs39KGYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299076; c=relaxed/simple;
	bh=VCr3qSwi7nja4acQiZhD4ezH/cSbqfWjDi9ZR6fh+zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3Ett+9GaLHmYetosZ8Smgy8G/F8Y1w2PLrj1YPB8NcrlLeRwRpB1kSDi8iuoRP5MJ9691r6Ry89+jjHIPYxPwFuYXE/l15TICeNkFfZ0QgzEd9pLR/pojP0c92gI6xZa2cIBZ/tO6CGEZzuxbDLT9d18MTAHxpSGNYFDw/aJrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIMC6Lbn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIMC6Lbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E01F000E9;
	Wed, 20 May 2026 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299074;
	bh=jmZgeAp67GjKsA3vhDr3p3AO14edVZtQZPk+u1FR/wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIMC6LbnAj6nXzxd34CX4XBlsZQ4XfkTdDnI9b2ZrPDxRb6Fws7TaNdFHSB9e3MCe
	 btXOyafNBjxDqJl8516vfiiNixLsrzeeV+n2MC6FDxTiqtbC+kUaIX2SklLbYRfJQP
	 cRNxn4lFZajkJrwzti3AwVTEclO/az7oAHtSdSAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 652/957] iavf: fix wrong VLAN mask for legacy Rx descriptors L2TAG2
Date: Wed, 20 May 2026 18:18:55 +0200
Message-ID: <20260520162148.671942085@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 496d9f91062fa07956702e0f234c5203f03a974d ]

The IAVF_RXD_LEGACY_L2TAG2_M mask was incorrectly defined as
GENMASK_ULL(63, 32), extracting 32 bits from qw2 instead of the
16-bit VLAN tag. In the legacy Rx descriptor layout, the 2nd L2TAG2
(VLAN tag) occupies bits 63:48 of qw2, not 63:32.

The oversized mask causes FIELD_GET to return a 32-bit value where the
actual VLAN tag sits in bits 31:16. When this value is passed to
iavf_receive_skb() as a u16 parameter, it gets truncated to the lower
16 bits (which contain the 1st L2TAG2, typically zero). As a result,
__vlan_hwaccel_put_tag() is never called and software VLAN interfaces
on VFs receive no traffic.

This affects VFs behind ice PF (VIRTCHNL VLAN v2) when the PF
advertises VLAN stripping into L2TAG2_2 and legacy descriptors are
used.

The flex descriptor path already uses the correct mask
(IAVF_RXD_FLEX_L2TAG2_2_M = GENMASK_ULL(63, 48)).

Reproducer:
 1. Create 2 VFs on ice PF (echo 2 > sriov_numvfs)
 2. Disable spoofchk on both VFs
 3. Move each VF into a separate network namespace
 4. On each VF: create VLAN interface (e.g. vlan 198), assign IP,
    bring up
 5. Set rx-vlan-offload OFF on both VFs
 6. Ping between VLAN interfaces -> expect PASS
    (VLAN tag stays in packet data, kernel matches in-band)
 7. Set rx-vlan-offload ON on both VFs
 8. Ping between VLAN interfaces -> expect FAIL if bug present
    (HW strips VLAN tag into descriptor L2TAG2 field, wrong mask
    extracts bits 47:32 instead of 63:48, truncated to u16 -> zero,
    __vlan_hwaccel_put_tag() never called, packet delivered to parent
    interface, not VLAN interface)

The reproducer requires legacy Rx descriptors. On modern ice + iavf
with full PTP support, flex descriptors are always negotiated and the
buggy legacy path is never reached. Flex descriptors require all of:
 - CONFIG_PTP_1588_CLOCK enabled
 - VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC granted by PF
 - PTP capabilities negotiated (VIRTCHNL_VF_CAP_PTP)
 - VIRTCHNL_1588_PTP_CAP_RX_TSTAMP supported
 - VIRTCHNL_RXDID_2_FLEX_SQ_NIC present in DDP profile

If any condition is not met, iavf_select_rx_desc_format() falls back
to legacy descriptors (RXDID=1) and the wrong L2TAG2 mask is hit.

Fixes: 2dc8e7c36d80 ("iavf: refactor iavf_clean_rx_irq to support legacy and flex descriptors")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-10-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index 1d8cf29cb65ac..5bb1de1cfd33b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -277,7 +277,7 @@ struct iavf_rx_desc {
 /* L2 Tag 2 Presence */
 #define IAVF_RXD_LEGACY_L2TAG2P_M		BIT(0)
 /* Stripped S-TAG VLAN from the receive packet */
-#define IAVF_RXD_LEGACY_L2TAG2_M		GENMASK_ULL(63, 32)
+#define IAVF_RXD_LEGACY_L2TAG2_M		GENMASK_ULL(63, 48)
 /* Stripped S-TAG VLAN from the receive packet */
 #define IAVF_RXD_FLEX_L2TAG2_2_M		GENMASK_ULL(63, 48)
 /* The packet is a UDP tunneled packet */
-- 
2.53.0



