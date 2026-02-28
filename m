Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7F39B978
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302616; cv=none; b=uy5wV6KzBKvoec3X9HYG5i3GB3BB+qxvU6R+ZH2PWkTGfF22ZpN2Bg3OqnSxSFE7zDlXIwJNci5sPYasT9WtBYSx1nNIuFHWLGdjNrmos4CgHH5H04xPyh+8PREf9tgZgmVth61dN9fuXDeUaXv8mt65i9Ai6DA593Eo7eNlrAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302616; c=relaxed/simple;
	bh=9jX3Qa+vsP4rXne9iNEtm8Mq8RgB5NMkF9NAKbA6SGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=icdJbSjgp9blFn+2Xu6R7+vCSDCNt1xUj7p/qVjrad/s83KQqf4ajizAvUh6KlpQ72X4TymgQLdEigKVZm5VLHcLVjzomTjv+9ZBDusrpr4SqWl7ek5Q+jjPXexj6cohbQHcBPe0Y3qj4y2n5VihZwAqdrq4vcuQTe9GWgkC7qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3+Hw42W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3+Hw42W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A832AC19423;
	Sat, 28 Feb 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302616;
	bh=9jX3Qa+vsP4rXne9iNEtm8Mq8RgB5NMkF9NAKbA6SGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3+Hw42WRK1JLsMhOEHVYUOkqHo0VYN0INcAzwvSG8pDPr/dpbx7iXZL5ldimTKcc
	 glO8RCzMWidbNTSLn1GIEboqTg8e79C43xXXRpdjRBcofZ0GqorubucCLx6GPJHTas
	 jCh4vXAeWtCkXJL/7C4zOmnWLPXofcDmDJtQ2KA0ujx5dcP79Dr8dsO5Z7wzyqV39I
	 /KUtsUuoniSILjdSrGTx0VAzCHHnDfb3I7NjAM01eiuCtoygU7r7zHSqH0nQVnvWvK
	 VfL3ViH0scSSSizmnuqBF6hRBeGYZZKlf5RrclmT32yCzlCokIK3IyiTu5JI7Sm29c
	 yUxqI0qQAraaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/164] dma: dma-axi-dmac: fix SW cyclic transfers
Date: Sat, 28 Feb 2026 13:14:32 -0500
Message-ID: <20260228181505.1600663-133-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 9bd257181fd5c996d922e9991500ad27987cfbf4 ]

If 'hw_cyclic' is false we should still be able to do cyclic transfers in
"software". That was not working for the case where 'desc->num_sgs' is 1
because 'chan->next_desc' is never set with the current desc which means
that the cyclic transfer only runs once and in the next SOT interrupt we
do nothing since vchan_next_desc() will return NULL.

Fix it by setting 'chan->next_desc' as soon as we get a new desc via
vchan_next_desc().

Fixes: 0e3b67b348b8 ("dmaengine: Add support for the Analog Devices AXI-DMAC DMA controller")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
base-commit: 398035178503bf662281bbffb4bebce1460a4bc5
change-id: 20251104-axi-dmac-fixes-and-improvs-e3ad512a329c
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://patch.msgid.link/20251104-axi-dmac-fixes-and-improvs-v1-1-3e6fd9328f72@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index e91aeec71c811..6194ef0ac17f6 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -221,6 +221,7 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 			return;
 		list_move_tail(&vdesc->node, &chan->active_descs);
 		desc = to_axi_dmac_desc(vdesc);
+		chan->next_desc = desc;
 	}
 	sg = &desc->sg[desc->num_submitted];
 
@@ -238,8 +239,6 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 		else
 			chan->next_desc = NULL;
 		flags |= AXI_DMAC_FLAG_LAST;
-	} else {
-		chan->next_desc = desc;
 	}
 
 	sg->id = axi_dmac_read(dmac, AXI_DMAC_REG_TRANSFER_ID);
-- 
2.51.0

