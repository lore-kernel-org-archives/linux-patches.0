Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAA216087B;
	Mon, 27 May 2024 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836717; cv=none; b=JC5e4kr4KeT2tl0DMPRn9F8Sg6CaQufsSlrpLX96jHpaaiCIcux9SSmuPV1vijJN1ERtPi+jrOSETzDGm+qGzZUelrdl9bD+kexshOmHyyXX6RMG17CWeofhVVzfaNMBoDcYy7eOCSKpTRv6ScNxZgv5lpmgnqt4RxSkR5UAJn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836717; c=relaxed/simple;
	bh=7n0UwbCkz2YhpDLdY+hJiUTuJLf/IJlMazX3YKg9lqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGJCDaOyBgKjrlHty4Nw7g+V5oVXVq/zmw91DYyPDZx72soyfnfQJIcezswHAz4lLKs0z7PIPAfUwPxZiW4ReELsubdTdqUq7jx9J87eGSPRFV6w5m3IVnt+kFvty+4xojb2z/zFwjZi2SBUxjYLmy/V8XE0T35xJOKNfOZIEYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMZQbNpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMZQbNpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FBBC2BBFC;
	Mon, 27 May 2024 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836717;
	bh=7n0UwbCkz2YhpDLdY+hJiUTuJLf/IJlMazX3YKg9lqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMZQbNpZE/lcSwiplwe/MC3WRG1fGjrDzb7v4isz9mn50b1A5IlZ2aJTpyllqkwIe
	 FPTNeGZmsesXOBdMbD2uIQ5yEmHbb2+qDE+TYKLxnVR61Isg8emBQot7wH8gj6c2zm
	 1XwikWw5U+lpuLOviPAMwKzGIPkuzs3DpZhXnmz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 160/427] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Mon, 27 May 2024 20:53:27 +0200
Message-ID: <20240527185617.358234437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Karpov <YKarpov@ispras.ru>

[ Upstream commit 504e2bed5d50610c1836046c0c195b0a6dba9c72 ]

struct Scsi_Host private data contains pointer to struct ctlr_info.

Restore allocation of only 8 bytes to store pointer in struct Scsi_Host
private data area.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bbbd25499100 ("scsi: hpsa: Fix allocation size for scsi_host_alloc()")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
Link: https://lore.kernel.org/r/20240312170447.743709-1-YKarpov@ispras.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af18d20f30794..49c57a9c110b5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5850,7 +5850,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



