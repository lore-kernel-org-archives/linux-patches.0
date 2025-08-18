Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D22D322767;
	Mon, 18 Aug 2025 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524040; cv=none; b=k2/h8n6LaiXR4GneRl1erndLpReQ1GhGAkcmS97G5mdAIh+MT6/gfWN9RIsx58twXSL7mE9mi4hZ2FVAnY65bfTmGdoMF7YlvJp1gCjvNrj+liZbUl3lZBxPBy3l2ZK89/H0Ns0gvYAa1dRtaowH6gJEpYJCE63P+oKnpNAXaGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524040; c=relaxed/simple;
	bh=EHpLu3OInsDTBRwKd/p6jQ+tPx32WKX63UEAnD65QC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROIOX/6GOlzuYYV1acXtXB+cWLkHFyzPvPtJ5nYTf3JNkpCrGEP4jJF7pyYz69hAZfIzX7cOKPYuz9X7l1n7LbuhXathZ3Em7EU03FBNZ7fafCypjfsBLcDy2F1a3KSdSc2EE+aAkUomXP+A2lGKm6ZQLuAKvyDhrTsyJfgpsPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2ec2hO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2ec2hO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF15C4CEEB;
	Mon, 18 Aug 2025 13:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524040;
	bh=EHpLu3OInsDTBRwKd/p6jQ+tPx32WKX63UEAnD65QC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2ec2hO16Hy55MnIzFD2ZHWSjDcK/wUlb6EjtGdtKqZQY2ymPinRTgrPjkxgswWLd
	 u9Zeg8r9nKT+dVNTngaqhucJw4bpEvskzBLs+lLNI+Z4PvimCP5MKPj0xsLwhiG2Z4
	 kBQZ+GZI5xz6Xb4aQVhHQgOFudThPrJgZBfLOnfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 349/515] scsi: bfa: Double-free fix
Date: Mon, 18 Aug 2025 14:45:35 +0200
Message-ID: <20250818124511.863651129@linuxfoundation.org>
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

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a719a18f0fbc..f56e008ee52b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -706,6 +706,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5



