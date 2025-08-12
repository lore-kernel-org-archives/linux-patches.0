Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEDC2FAC02;
	Tue, 12 Aug 2025 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021488; cv=none; b=MaO8d3e4EzkHBekwUdd9iaWvTbeKekq5R4DewI/e4wW51eon6POF+o8mCTfZK7robViO0IgxeB/o7XAX8Af0+YOFuIIMD0kzvaKdaGnCs5jkME+kCl82Y44lYMty4Ov+7C+PqU3kHorx1O3REaXI1znBchA/bEoshONAe8VEMFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021488; c=relaxed/simple;
	bh=HnqV6fWkbcTphMIiToW9ApFLMVIkNirX0P3tTL/RXeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvp3xgTNATOEZTOMEqvAygJmVTZXih+QnPtpoAdzFvEKxo6mC24lAHgAvJavPGJ/Ho9L+VJkEEg8FA8/eNqYxSoKHmZvZI2/PdK3BLnVLyFXdo6k2Kp62AGGG7x/eMzjU0OvhQuMEyz8/6RgYZm8mAywLe30h+m+G1PdWm8RM+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m02Iip6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m02Iip6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EEAC4CEF0;
	Tue, 12 Aug 2025 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021487;
	bh=HnqV6fWkbcTphMIiToW9ApFLMVIkNirX0P3tTL/RXeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m02Iip6pVOisRPFGEFTwV+dGp+wlIyUC1DjgJYwYhWx5zFv4s7pZHld4Rsq8u2sKH
	 arAgebuLwEJO9sv7IxJlzjKgVVj6RaYJpT2FKiBXffQWco2/iw3fMJnmbGAC9oIRYT
	 oJ8KX1Xe5TgIYnMHUOKxmL/LBKTdaEL50EW68zkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/262] scsi: elx: efct: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:45 +0200
Message-ID: <20250812172958.931094333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 3a988d0b65d7d1713ce7596eae288a293f3b938e ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250627114117.188480-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/efct/efct_lio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index a982b9cf9870..49d7fe150684 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -382,7 +382,7 @@ efct_lio_sg_unmap(struct efct_io *io)
 		return;
 
 	dma_unmap_sg(&io->efct->pci->dev, cmd->t_data_sg,
-		     ocp->seg_map_cnt, cmd->data_direction);
+		     cmd->t_data_nents, cmd->data_direction);
 	ocp->seg_map_cnt = 0;
 }
 
-- 
2.39.5



