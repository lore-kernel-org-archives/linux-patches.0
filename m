Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0787349B0A;
	Thu, 15 Jan 2026 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496262; cv=none; b=EtnWylPfSS6SFeLNDVm7yHpfUnwifj4VoZ45tU05ao3IWLMdics68AMiVm4GE02W4E9TKCAa4ZIGGJNGn0qIYfUOet/exgVbPA3JI72FGooOKf1uX6tqterPWHKf8ZZocVFs5feCFG0Cm7AVTci6A/NgOeCICw11OemWJ6Z5HU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496262; c=relaxed/simple;
	bh=SGN7uERA7k8Wz0LUWmGxhKhxwRar5fn3/bO1GLwosWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+JFYf+keUCwWEelNMXN1RDbmKppkMPSVTs4xTT6QzE01ra0oaPRdwPEcUFIQvK70szELdoDlct/xXpkeaq/qb47kPnafJokP8izkXpQVDhQJbpORn3m9X9Z48YyXxlVIpoZgAviBBTumMBbaeLeKAtz4USMnfdxEQVQ0Iz+BFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nacSHApA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nacSHApA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DF1C116D0;
	Thu, 15 Jan 2026 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496262;
	bh=SGN7uERA7k8Wz0LUWmGxhKhxwRar5fn3/bO1GLwosWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nacSHApAKHF8RpJFkP2XSvN7C72KR9EhkJWCGghkLc9sDXMgdyWxTOJ7hC35b71ML
	 1KwzSFzZDgeFy9/cSIm6bSz1bewaKQ2CrxDNm1Dnfi75XEGOF0gMGZR/B2BRXd18Bg
	 QivuQyuvsaGCEpUrH1fnqiaBP7bgfrCu542rfkpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreedevi Joshi <sreedevi.joshi@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/181] idpf: Fix error handling in idpf_vport_open()
Date: Thu, 15 Jan 2026 17:47:51 +0100
Message-ID: <20260115164207.158285195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Sreedevi Joshi <sreedevi.joshi@intel.com>

[ Upstream commit 87b8ee64685bc096a087af833d4594b2332bfdb1 ]

Fix error handling to properly cleanup interrupts when
idpf_vport_queue_ids_init() or idpf_rx_bufs_init_all() fail. Jump to
'intr_deinit' instead of 'queues_rel' to ensure interrupts are cleaned up
before releasing other resources.

Fixes: d4d558718266 ("idpf: initialize interrupts and enable vport")
Signed-off-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 003bab3ce5ae6..131a8121839bd 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1524,14 +1524,14 @@ static int idpf_vport_open(struct idpf_vport *vport, bool rtnl)
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize queue registers for vport %u: %d\n",
 			vport->vport_id, err);
-		goto queues_rel;
+		goto intr_deinit;
 	}
 
 	err = idpf_rx_bufs_init_all(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize RX buffers for vport %u: %d\n",
 			vport->vport_id, err);
-		goto queues_rel;
+		goto intr_deinit;
 	}
 
 	idpf_rx_init_buf_tail(vport);
-- 
2.51.0



