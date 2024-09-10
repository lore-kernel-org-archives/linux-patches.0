Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E718C036;
	Tue, 10 Sep 2024 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963773; cv=none; b=B7/A59SoULhs9xgfGA9f0DAAFrKkPRm9Gy0f7D7MJqXicHlTugElhzsqhvDMmDP0xHTb6yI0oRPS5P4MBFjXfb1ZJZc9B9zTYxGkJc/oRfYAjSbxLIflxAU5d4wP6kgPgahHWjUhfos9Gu1ujJi/JfPPw4gedsNNbc1Nznt0qZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963773; c=relaxed/simple;
	bh=+OJSst2OSQko4/qOokf4+5QiNNmRur/46OlMZTFXFyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjnDttPQKR4QQUA1R7UEywmdZAonN8vr8GzC+2ZKCsWIXlC/ze37Y4zYACEN+ZC3jwRYnnQ7QRRRVBVB0NGBqGOMqNjmsGg2VpwCO9r5+7Lq8tbrPIJ742Y4cfyuMsvGM9zHfjby3TLTOTEejPPFn3hZEBauM/97PDSALq6W6Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYPkpCPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYPkpCPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD3C4CEC3;
	Tue, 10 Sep 2024 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963772;
	bh=+OJSst2OSQko4/qOokf4+5QiNNmRur/46OlMZTFXFyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYPkpCPwUCvp++DJavF4fdrPhgixGCetXJoZVmcfweNYrlGwTFuY9iVS7Pu11EDh2
	 IWfOOkHdAD0Ak7mb8i1y1U9nnmA6Q3q3/iuJCTGugH+383kFCrTtt0l1mP6Ml11EXe
	 ILBvOOCQDw8HoW2KquEBzMN9pGLww2bEJG7mipoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/214] ata: pata_macio: Use WARN instead of BUG
Date: Tue, 10 Sep 2024 11:33:13 +0200
Message-ID: <20240910092605.663023330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit d4bc0a264fb482b019c84fbc7202dd3cab059087 ]

The overflow/underflow conditions in pata_macio_qc_prep() should never
happen. But if they do there's no need to kill the system entirely, a
WARN and failing the IO request should be sufficient and might allow the
system to keep running.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_macio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index be0ca8d5b345..eacebfc2ca08 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -540,7 +540,8 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
 
 		while (sg_len) {
 			/* table overflow should never happen */
-			BUG_ON (pi++ >= MAX_DCMDS);
+			if (WARN_ON_ONCE(pi >= MAX_DCMDS))
+				return AC_ERR_SYSTEM;
 
 			len = (sg_len < MAX_DBDMA_SEG) ? sg_len : MAX_DBDMA_SEG;
 			table->command = cpu_to_le16(write ? OUTPUT_MORE: INPUT_MORE);
@@ -552,11 +553,13 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
 			addr += len;
 			sg_len -= len;
 			++table;
+			++pi;
 		}
 	}
 
 	/* Should never happen according to Tejun */
-	BUG_ON(!pi);
+	if (WARN_ON_ONCE(!pi))
+		return AC_ERR_SYSTEM;
 
 	/* Convert the last command to an input/output */
 	table--;
-- 
2.43.0



