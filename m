Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE1207E14;
	Tue,  8 Apr 2025 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110860; cv=none; b=oia+YjJCE8TG/bKbLQKelYtk1mQmskAphkuOeBDe/uBDSEgPLnFZT9m7x9tlu/sAXafpx2HBysdswJaJ09Gi9uiyuwLLrf6cN3ejSSPDCWSYiIODl0araQhkKN58Fe7HOB5vErfD34c+F37Y27fkjOyJR2Wi3F2PAm/JI0ghI1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110860; c=relaxed/simple;
	bh=xWZxUu3gdShAsVsYHBPNXe4JPD70Wf31oihUVIG6eq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO8OcLnbAejOVswoEli3kdAKV9uUA3ggg2uWU2T31LNyPbCyeHxJNWtrWJuDnPeBlQM86WAxqvW6hp1W76qCsENozROPSSr20+uDbY3d2TTvY7CpZkj1JQqnODB8Vuwub2WqKYUVwB8G5s6HrTKO8tWhoKthVnQV/HctPk13Mmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/9f5yr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/9f5yr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1058C4CEE5;
	Tue,  8 Apr 2025 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110860;
	bh=xWZxUu3gdShAsVsYHBPNXe4JPD70Wf31oihUVIG6eq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/9f5yr6nMEeylZohJaGYc/d7AjRJ+GO6Q/D3wh/9xlt+f+eOfQzfoDfI6UaR1oOd
	 4OjJshs6mn7A2Rn7t8JUEVRr1Jh9a0galkCGxrGFCXouI+g/4PZgSyZmjtzi1mLmRA
	 L3dm/UD6oHOT7KaKBfNs2by4KWU1YYe6AaawhlQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 222/731] net: lan743x: reject unsupported external timestamp requests
Date: Tue,  8 Apr 2025 12:41:59 +0200
Message-ID: <20250408104919.444569746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit c0b4ddd30871c59043ed3592e6abeee55c3bf045 ]

The lan743x_ptp_io_event_cap_en() function checks that the given request
sets only one of PTP_RISING_EDGE or PTP_FALLING_EDGE, but not both.

However, this driver does not check whether other flags (such as
PTP_EXT_OFF) are set, nor whether any future unrecognized flags are set.

Fix this by adding the appropriate check to the lan743x_ptp_io_extts()
function.

Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250312-jk-net-fixes-supported-extts-flags-v2-3-ea930ba82459@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 4a777b449ecd0..0be44dcb33938 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -942,6 +942,12 @@ static int lan743x_ptp_io_extts(struct lan743x_adapter *adapter, int on,
 
 	extts = &ptp->extts[index];
 
+	if (extts_request->flags & ~(PTP_ENABLE_FEATURE |
+				     PTP_RISING_EDGE |
+				     PTP_FALLING_EDGE |
+				     PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
 	if (on) {
 		extts_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS, index);
 		if (extts_pin < 0)
-- 
2.39.5



