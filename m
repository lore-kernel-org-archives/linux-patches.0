Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76B186E4B;
	Tue, 10 Sep 2024 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962046; cv=none; b=mz70KvUj/czmQRvTKorjV0td+qdovsQwqbkWmZ+kDX1R39R9Zw24Bi54ffF4/pob+lRcb9rFIzpaMETiawv4s5tMVDLiq8jaurgmHQqfOF4c9GcmFQT503Hu6YT8Q8AOTOMXaOqRMAPk3B/VQK/fldIjU0AsNhGIGCD/ZPUuTZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962046; c=relaxed/simple;
	bh=7Da91B8sJmkEGYR3w97032AJ7dYGPqhvPzZnP6taHQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip4JeSPNuw6wPKlsz2k51qm1CeZRs6EC6b2fV8Mm/ONpbinveltrLZNYxl3m4MNiw6OiLXe6EHpHgKUWMkIXe3tyvAcUAEoAsmxz3UWZzS10b5jc5+on4aDtGWMuD8GQr02CwLj5A6wEOUsG77kJpsNxSvi3NCcYOapCPVJQ61s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+YqpiFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+YqpiFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0431C4CEC6;
	Tue, 10 Sep 2024 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962046;
	bh=7Da91B8sJmkEGYR3w97032AJ7dYGPqhvPzZnP6taHQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+YqpiFb9h3YoNtAcIvwAWf4hdqBb6f91FzLWCEcL9TxXsp99FMUXy9AeYfsQlmQy
	 yDuedV+lNII154y0ie8TRGmr2GAwsHvrwE6e5xES+PlWHx8msNTCOc+Y59BkhrPe/h
	 9XZV//Uqqe6RU8BhiIwURoheLAg6If6bF87QZ6ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 276/375] ata: pata_macio: Use WARN instead of BUG
Date: Tue, 10 Sep 2024 11:31:13 +0200
Message-ID: <20240910092631.833354822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99fc5d9d95d7..cac022eb1492 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -554,7 +554,8 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
 
 		while (sg_len) {
 			/* table overflow should never happen */
-			BUG_ON (pi++ >= MAX_DCMDS);
+			if (WARN_ON_ONCE(pi >= MAX_DCMDS))
+				return AC_ERR_SYSTEM;
 
 			len = (sg_len < MAX_DBDMA_SEG) ? sg_len : MAX_DBDMA_SEG;
 			table->command = cpu_to_le16(write ? OUTPUT_MORE: INPUT_MORE);
@@ -566,11 +567,13 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
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



