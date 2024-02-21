Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28323D0A1;
	Wed, 21 Feb 2024 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524757; cv=none; b=sH6xvmPID4+nbrUbneLqSdivyGnxNzXoOnPgf5WJ19CeFpktRi7H344ZhSbhXNxj7cOfrAXT56ylVqOqhxCCuchAflxkOFTYSIThOg+uvgIt3A8dGmYb4K5NgZm/iNtDe/0J5cKRnJFkGDltsjIkx5s5VkH5IINnrG7CNSdaGAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524757; c=relaxed/simple;
	bh=3LF2Nu+JyFyH+DbnW7/OQeALxdH2IL7J8d1D5KngKts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLokfuqGlBi3bFbnTt8gjtiu0ESchOtEcpi56Noc/9WmfFzPVvseM21wJbsH4p+mKdTZgfbTi0kdRVOUICXmN8jrzyf8aY2E3gNYq0D5aDBsUQD4L3TDCwcRcXS/OyjnH453pdGDoateY2hCa6QMB/0aX8tD5M6/eM2lCUq5Mkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnjoLGT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnjoLGT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51164C433F1;
	Wed, 21 Feb 2024 14:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524756;
	bh=3LF2Nu+JyFyH+DbnW7/OQeALxdH2IL7J8d1D5KngKts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnjoLGT5n0P5NKv1LGRCN84Vza2Wl4He45L+SuFUu/aMsPPLUJIHAJt2T+joxoHqz
	 nntoYMZDgpklmig6hkPoTALYee6E/ZaWv8poA4FaQsZJA8usJi1QWOC1fy7sVELf5F
	 bEAMW9VxbW6zD8OmqDrmt2JR8FWzbZQEysBxtlZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Basilio <daniel.basilio@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 338/379] nfp: use correct macro for LengthSelect in BAR config
Date: Wed, 21 Feb 2024 14:08:37 +0100
Message-ID: <20240221130004.978483580@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Basilio <daniel.basilio@corigine.com>

commit b3d4f7f2288901ed2392695919b3c0e24c1b4084 upstream.

The 1st and 2nd expansion BAR configuration registers are configured,
when the driver starts up, in variables 'barcfg_msix_general' and
'barcfg_msix_xpb', respectively. The 'LengthSelect' field is ORed in
from bit 0, which is incorrect. The 'LengthSelect' field should
start from bit 27.

This has largely gone un-noticed because
NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT happens to be 0.

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")
Cc: stable@vger.kernel.org # 4.11+
Signed-off-by: Daniel Basilio <daniel.basilio@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -542,11 +542,13 @@ static int enable_bars(struct nfp6000_pc
 	const u32 barcfg_msix_general =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_GENERAL) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT;
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT);
 	const u32 barcfg_msix_xpb =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_BULK) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT |
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT) |
 		NFP_PCIE_BAR_PCIE2CPP_Target_BaseAddress(
 			NFP_CPP_TARGET_ISLAND_XPB);
 	const u32 barcfg_explicit[4] = {


