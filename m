Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7A1A93D;
	Mon, 18 Aug 2025 13:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524109; cv=none; b=oSchZ2aQkFP/GaffowwHeUA4TmV/jqAcE7+6NopTQCZ4K9TGRcLcX4toTOL8vWlyVqj6Y8gpXf9bBPW6jmyD2FfDoZ616BX7WDX2+p/REcZp/Ttpaz2jlUe6Btwpu/A2P27nKeg+7huiEW/JNr7YlYVQAdBZ+ca1yMGzH0R7Rhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524109; c=relaxed/simple;
	bh=ZwH6KIU7YdYMN/FHJ+cqSgRzcBfSD6YJdLvUX4GztpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSm+1ypm2n5pcgLcbXx7L1nUtsaRvL64vGnAcITu2PTVZabkWpezAwJUaKGWmRQwya0z1SMIr4+E7nhAq/QWMXtgqiE1AKmNnvttAI3IliAB4FXzfK0MPbI4+8PoHAwrnqcIHPBj/HMWx7kqLMePOiTkjM6gCRIDSY2wgH3236I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXEBxy8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXEBxy8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92A6C4CEEB;
	Mon, 18 Aug 2025 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524109;
	bh=ZwH6KIU7YdYMN/FHJ+cqSgRzcBfSD6YJdLvUX4GztpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXEBxy8DAn2agt/509uD2lytS7dwjaoztiaiID4VHgBmgfOx788I3rB+R2Km7vn2b
	 EgYKAWuKIUNO87G0DyqtoEPCGt2BFbBsAx1NsxZ2WtJFEfBhtlAqKVhPWgITQNxw7k
	 kSFUl6dg47qG42qxJcUN+qZWtSIEo+K8rjkkGQDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francisco Gutierrez <frankramirez@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 371/515] scsi: pm80xx: Free allocated tags after failure
Date: Mon, 18 Aug 2025 14:45:57 +0200
Message-ID: <20250818124512.696726345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Francisco Gutierrez <frankramirez@google.com>

[ Upstream commit 258a0a19621793b811356fc9d1849f950629d669 ]

This change frees resources after an error is detected.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
Link: https://lore.kernel.org/r/20250617210443.989058-1-frankramirez@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5b373c53c036..c4074f062d93 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4677,8 +4677,12 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /**
@@ -4704,8 +4708,12 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /*
-- 
2.39.5



