Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666B826CE2B;
	Tue, 12 Aug 2025 18:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024499; cv=none; b=uCzH3uII/hmNCT87jkmPdrmZ/6ZVOTQ07Quu32CibfRlp5lZtEe6XKFwep+iPUdfpqPxTojkhsG/ta7Czn52eIEirNnTiLo/aUQNXs1ua7kSPQBOCj4JzSACtNAb0UM5gI5HKhxMReYZc3jVzIUvoe+nu/E0VC48C4TV0VQaCEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024499; c=relaxed/simple;
	bh=JeRMhKT5SZA/OqGQXkU/o0G0J3RMcOTrIFUBYvRJ5ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKiyQ5tDb0wYzZE8IE8zM+diXwAUiHWH3BFomGADHu7K9ZKklwAOQA5fPjsUrYks7qUmxgSTYUbMfYTAic5nCEdzuikCFOXPNs1m+8t8kKXcEYmcsV6XZ5I842gc6O/zAR6mXCifML5AkdIBWMLK1GgxS8AZanp7T/Oh0F1AFSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCpUOifW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCpUOifW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08B1C4CEF0;
	Tue, 12 Aug 2025 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024499;
	bh=JeRMhKT5SZA/OqGQXkU/o0G0J3RMcOTrIFUBYvRJ5ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCpUOifWVePNqLOfF+Iw4YMtttXWVSqUXX2aG9WPbq91UtRWqi9FAW0Gvz+KlqMma
	 AL6dKnCIrLdYyXxK5TiIOPTEhHT2NXv67V87XZQpBkJWN0LnpJ+g8YabrNFNlRpi6P
	 5YwwO7mYs8pEeyFP5I+LwN7VOnq2IX++MxnvYtQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 392/627] scsi: elx: efct: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:31:27 +0200
Message-ID: <20250812173434.212022462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 9ac69356b13e..bd3d489e56ae 100644
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



