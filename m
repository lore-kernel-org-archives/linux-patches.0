Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD53239E85;
	Tue, 17 Jun 2025 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177435; cv=none; b=RTvyjwoF0rvIXzPBr7KfFNdxE1NbdhK6fGyYfuE48d+zw/gW1pfA+SPj2Jqi4xeOcfGVqzNg2NxI9RbHTzSUTjC1Sk4POB5oXNN3ouP1bfRufi7INC9PKEcRnoMrVk3keTX08Cp6XBE0PafRtPP3d9yLK/1FJyOco+Etychb37I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177435; c=relaxed/simple;
	bh=4C9vBGGk+6Ot4jCSx/E/P2/5cmv6SE9TOfXmQa8Xrag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgIEuE5nltj4XJAlP3R5Sd1hrVzOpJNjlRbHPFBxFgNk98lmg2S5TcbjLeUBZ/72tWZejaal51DP3+EYZL1psYpB+XPPG5vUbS6EQtCCawn+wxFKfS8IVXAHHnZsO9oQELyZ64dIZFeW6io/ITrwbBdBFLcxZ2a8QCdkHdr0bOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTzFLyuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTzFLyuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783FCC4CEE3;
	Tue, 17 Jun 2025 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177434;
	bh=4C9vBGGk+6Ot4jCSx/E/P2/5cmv6SE9TOfXmQa8Xrag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTzFLyuQDGn9xla2pEe2bGlQFHL1eM/CG2Aq9kYqmRuduXzOAreWz9j5DGbN5T60V
	 Q+zTgatL3xPU9cqa0fNlgtwfLr3aciXqFU6zDxItlQE9Ep/nEDpvc0+dblM3weFXAg
	 2XFuw8nNv8OV3h0LWj+E8CRC27FXAtvxjaeYGrzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 283/780] scsi: mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter() to return IOC pointer
Date: Tue, 17 Jun 2025 17:19:51 +0200
Message-ID: <20250617152502.999789587@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 9ad5249b37b59baaf2da1014f397c2e23b605075 ]

Fix _ctl_get_mpt_mctp_passthru_adapter() to return the correct IOC
pointer to caller based on dev_index.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Link: https://lore.kernel.org/r/1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com
Fixes: c72be4b5bb7c ("scsi: mpt3sas: Add support for MCTP Passthrough commands")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 063b10dd82514..02fc204b9bf7b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2869,8 +2869,9 @@ _ctl_get_mpt_mctp_passthru_adapter(int dev_index)
 		if (ioc->facts.IOCCapabilities & MPI26_IOCFACTS_CAPABILITY_MCTP_PASSTHRU) {
 			if (count == dev_index) {
 				spin_unlock(&gioc_lock);
-				return 0;
+				return ioc;
 			}
+			count++;
 		}
 	}
 	spin_unlock(&gioc_lock);
-- 
2.39.5



