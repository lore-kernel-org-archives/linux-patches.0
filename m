Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778E92820D1;
	Mon, 22 Sep 2025 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569884; cv=none; b=WbQ7ygxIn3Z5Q93Hzt34ivuE46qa4KYHX+Q9RzlN+KylvGShJv7gxW0UwtQ1Ne2+p94YMfP+9Vgs0vUH3gnDNjKiFcDrPAXwEAgrEDGwmhWpyex4qwRO9JnK2fRxMM9ymyvazdqACGBw5smbTWqzqj+P6YTOzMU+UcNA6wMZKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569884; c=relaxed/simple;
	bh=2xb3jkZ/399W9CtrkGHeaHXFUi+aHzVCayV/i6p+RQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6+6arzRhEfVHrSOBqkjnU9yf/lAmXjf9a5+JqfBwln4hubEVFyJiz0OzcDwy2BQa5JdW/Wbc7o0MjzxlCXKeTK9HaCIYP8lCnXYDFUPoanTR8QdvGU3ekI7uii6B4d1E086j4LyTmXQwZxcNBLPH6i8e86hzvHo370QIgVHtt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOfKewyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOfKewyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F07CC4CEF5;
	Mon, 22 Sep 2025 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569884;
	bh=2xb3jkZ/399W9CtrkGHeaHXFUi+aHzVCayV/i6p+RQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOfKewyBlboT/hNJV+LzczHgobH6xJmGWwarmaB3m3zAWM5kwNWavW4TFVlOhiSXa
	 4ryfIGR8ynNRXeGCoKdfQoHKerjpL3w025idqd+EegzgktG0x4RZTbIJb8GA0uKXT8
	 hEhQYIhfrE4rvBM1368hSgO25GiI6CZXGkPyc6cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh B Edara <sedara@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/105] octeon_ep: fix VF MAC address lifecycle handling
Date: Mon, 22 Sep 2025 21:29:09 +0200
Message-ID: <20250922192409.596678812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathesh B Edara <sedara@marvell.com>

[ Upstream commit a72175c985132885573593222a7b088cf49b07ae ]

Currently, VF MAC address info is not updated when the MAC address is
configured from VF, and it is not cleared when the VF is removed. This
leads to stale or missing MAC information in the PF, which may cause
incorrect state tracking or inconsistencies when VFs are hot-plugged
or reassigned.

Fix this by:
 - storing the VF MAC address in the PF when it is set from VF
 - clearing the stored VF MAC address when the VF is removed

This ensures that the PF always has correct VF MAC state.

Fixes: cde29af9e68e ("octeon_ep: add PF-VF mailbox communication")
Signed-off-by: Sathesh B Edara <sedara@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250916133207.21737-1-sedara@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
index e6eb98d70f3c4..6334b68f28d79 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
@@ -177,6 +177,7 @@ static void octep_pfvf_get_mac_addr(struct octep_device *oct,  u32 vf_id,
 		dev_err(&oct->pdev->dev, "Get VF MAC address failed via host control Mbox\n");
 		return;
 	}
+	ether_addr_copy(oct->vf_info[vf_id].mac_addr, rsp->s_set_mac.mac_addr);
 	rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
 }
 
@@ -186,6 +187,8 @@ static void octep_pfvf_dev_remove(struct octep_device *oct,  u32 vf_id,
 {
 	int err;
 
+	/* Reset VF-specific information maintained by the PF */
+	memset(&oct->vf_info[vf_id], 0, sizeof(struct octep_pfvf_info));
 	err = octep_ctrl_net_dev_remove(oct, vf_id);
 	if (err) {
 		rsp->s.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
-- 
2.51.0



