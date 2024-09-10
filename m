Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E50F189B9C;
	Tue, 10 Sep 2024 09:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961154; cv=none; b=RZBBVs1AEA3sdKwImeylENitE4+VsiwLX+FuT1NgIxOkuNDQg0NnQlMNPV6sRXdrEdAZJC2fGCKIbgp3LK8JMm67QuqtTslLj5D49DKsS62yjjZxh+de52RndFDs7+4A/Fx8/q/B+sEgc8bfC65pJMo2Cy4Jvt9eYYC5fpX8UBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961154; c=relaxed/simple;
	bh=MLsuGh53XgMaBUD75TfOi0UWPF4/BMEh0gZ+ELuerkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxHeAJ7yw7SK+VAfIgq2xu1LcKaxpsSiOO3LWRcWXNywH/CWnv5JHqBXt0KGKEiJbbXN6kcPEQCQaxQa2oORHXO9LhkxJX70FFZcg1nUG6DuoH0ZKpcbLX2DX7dm13vPBTomnWxVaPJ2aBburxNr7omF0YRuHqQZ8N2rPBQl5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zVbU4pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zVbU4pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296AFC4CEC3;
	Tue, 10 Sep 2024 09:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961154;
	bh=MLsuGh53XgMaBUD75TfOi0UWPF4/BMEh0gZ+ELuerkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zVbU4pizr2JYtWC5EB7mO0N4Cxeg/2RWkQYR5QVh/08qbcTkV+bM73Cfsv2OTzGQ
	 aYRWbgnnb/WmtEx1naiNmutmEb0gUAqCboZF294qwSxkogSM6INwjlc7pNPiJ4Yb2n
	 f1O+eu3kui1z9rJEhJUfjv2lKYTQaLJPwyXqoTAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/96] ata: pata_macio: Use WARN instead of BUG
Date: Tue, 10 Sep 2024 11:32:14 +0200
Message-ID: <20240910092544.720591921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 765b99319d3c..7beb5dd9ff87 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -537,7 +537,8 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
 
 		while (sg_len) {
 			/* table overflow should never happen */
-			BUG_ON (pi++ >= MAX_DCMDS);
+			if (WARN_ON_ONCE(pi >= MAX_DCMDS))
+				return AC_ERR_SYSTEM;
 
 			len = (sg_len < MAX_DBDMA_SEG) ? sg_len : MAX_DBDMA_SEG;
 			table->command = cpu_to_le16(write ? OUTPUT_MORE: INPUT_MORE);
@@ -549,11 +550,13 @@ static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
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



