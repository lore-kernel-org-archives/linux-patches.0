Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D78188A28;
	Tue, 10 Sep 2024 10:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962696; cv=none; b=hFPxZIqlsQMWubaAmnQNCAyo9lHM2A5UueDB51FJAP7paslgRMbSMhN2VfFxTzqsq7ucbJebM7L28aRfjnCDq4qgDYHg9SapGtJQIlOMtJcIK/ttLZTxbz68b3tyIWo+rXWujdpv/lXOTuDPtzdo1Ny1KFgrlpbgoy/sy5oQBA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962696; c=relaxed/simple;
	bh=jWwqoGCZgRzeptDrlnPwi0NLADTdKe59VmCSOSH+nmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtYrIPphnK1X8gZEWF09jLr2DqJih06W1RmLz1HL2jDHlEzylnif8G7MOOD/qHnpZlbSBHyVeJo4Oja2rPEPuqL+VC0uminrbtdJ2fIdxRYj4HSlTHqRXZkCUNsrYOx83D0EPUGdsrcYiTrCvuTVB8aLi+DPX9DwlhIt+3dc/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCqm+UqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCqm+UqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05D7C4CEC3;
	Tue, 10 Sep 2024 10:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962696;
	bh=jWwqoGCZgRzeptDrlnPwi0NLADTdKe59VmCSOSH+nmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCqm+UqEONolGiwT6wBC+eU054Lk4N4iCC9+zdyd1G3zfz1v+jcPX+1LyubmDUo5O
	 9gg/qZc/eTL4K2hgsftRGt7xKLUHEuBmAQOBx2RgKGl2BgHBuA7JxQVAX1Yhvo113Y
	 dtrjsBVmbcfqDQwRihVPfyIZ/6ePrGXo2pygEk/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/121] ata: pata_macio: Use WARN instead of BUG
Date: Tue, 10 Sep 2024 11:32:48 +0200
Message-ID: <20240910092550.264901236@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1bfd0154dad5..a601768956e8 100644
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



