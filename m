Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0456A221FAC;
	Tue, 12 Aug 2025 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020753; cv=none; b=O2eQTmaq8R/x23btRoTARtDxfy3doc3lFJykxXwYydU3Xesgpo3VLG7ckKvQzUfRUldD5nb7BqSWsTEOB+guHohNCTTzCpSrydcTR8AdWpRbhUugwQxV6YjKajxEJR+uxObVZ+oDQYXKboYloKhqH6IRWcmuMMUQSOwosw4Pzyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020753; c=relaxed/simple;
	bh=UAafxf2msfNueEgSa1mzdq9hBfoLrz6ACDp2P5SvIZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=illpjXOqSVDlDUDEbHzQkvs9ArcTOVeXomZGGrSIfvJTX0BWnsXJevs3IuOgp9usHKhqFq61VomnN+iTo3dBuZJLVRvwpIpDU9dJcoXa2gsGv1ljq4irYeWxhGPJOTQ3JviY1OAP+DZejYuhjP6fWdKM6OY7lrhqXfS/90IXhlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trflfNPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trflfNPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D01C4CEF0;
	Tue, 12 Aug 2025 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020752;
	bh=UAafxf2msfNueEgSa1mzdq9hBfoLrz6ACDp2P5SvIZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trflfNPCGYidVXvEulmOAj15OMTQxQ9t4rPDojm76bRbRG0JWkvjKy2vvQ7AXu/cI
	 WK9ngiEJM9M5OWMSkVXGbEU2c/RPHQtAfWnp5L+TsZ2D3Hl9H0mF8vLS0/dK9zn0hg
	 7KJzpFUulYRmVWwgKx3KcMpyvyHhEFchpasGAlzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/253] scsi: elx: efct: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:29:10 +0200
Message-ID: <20250812172955.610049359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index be4b5c1ee32d..150d059e51ac 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -396,7 +396,7 @@ efct_lio_sg_unmap(struct efct_io *io)
 		return;
 
 	dma_unmap_sg(&io->efct->pci->dev, cmd->t_data_sg,
-		     ocp->seg_map_cnt, cmd->data_direction);
+		     cmd->t_data_nents, cmd->data_direction);
 	ocp->seg_map_cnt = 0;
 }
 
-- 
2.39.5



