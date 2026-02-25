Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D95D18B0A;
	Wed, 25 Feb 2026 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983311; cv=none; b=YNY5w6Kd6YNKnE3ZjjTsOvTAyQYlxfw8wRV+NS9EhMvdN9o22UgTVz7oY+IP3qtYHFISu3Bql5acmbsuAcd6tfggjyKK5Px2v4VHofNbIAIm2Bx/3DaOirGvglwoD50zgIUhxdYDdhcKo3svqwHH6dZ1Rs4kNG8pHd/uLSI9oOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983311; c=relaxed/simple;
	bh=irDwe8yRMji4YwO6LAsWlipahdLhe5e/ZsQnEBK4dyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsSmdI+Xknmeiv5ZpIJN0XnzeNPmVi4wCDwqjHrcOwaNU/c6mpReQv/wlpkD2ADbJjM0uQguv/zBoCUiTtZxHzwllQq2ZvG6za763wz6cGWPnId9GVBVvlS1kqrDoyHdtsbW8wVwEey5eTCSaf0qWq+S0Iv74mIXPkUWnLbe6Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivORkHBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivORkHBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDCBC116D0;
	Wed, 25 Feb 2026 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983310;
	bh=irDwe8yRMji4YwO6LAsWlipahdLhe5e/ZsQnEBK4dyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivORkHBVkrLGk8a1Am74ad8BwpYHs9wl7P5IAIAWEssmVvFUJ1exLdZ8lSSTAaKLW
	 kN+XSi2DQtjkFWOLMRie7bsVPvPg7p7Jl2b0qqKP87dIwsYKfCXSRIGD2u+MIwrMfk
	 wOJfI4Z44xQiUdxy/6rV6XKPRAfQv2zPMq8l/Gnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 437/781] octeontx2-pf: Unregister devlink on probe failure
Date: Tue, 24 Feb 2026 17:19:06 -0800
Message-ID: <20260225012410.421027569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6b2d8559f0eb1..444bb67494ab7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3315,6 +3315,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_sriov_cleannup:
 	otx2_sriov_vfcfg_cleanup(pf);
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0



