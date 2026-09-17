Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5EE19F40B;
	Thu, 17 Sep 2026 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668091; cv=none; b=Ir3cGui5NJ+xcmXjGTh0giPHdkH+8fcA4udcvNTKsIgCyoNWjXyyAg7MgV4uc7Yj2zbVM0XqvlaRUUereM4sVwiJkjiX60k8YPFyaPhqdJXo15a59UhnmeEK8eaBdj475wtqXbUrGrhE3/bJafNO/Dh7jwzJoxwRFOIAx/LCSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668091; c=relaxed/simple;
	bh=Wa0a/f9pVpjI5iLnER2FtBU8xg57MqIGnSss+p8JQnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTZQO40Xm7mdWGeI2lTU0kdb91T+RYUtqvXoBvfJ66ikJf0tlDMm7UHRCNY5VoNHx/CSc1rFYildI58Bd4ZrOT2mLNlaQgo/rNStgwomOaP9bKNUFEL73FEJF8pGK87KwVY5tWfhJMdMFYThEe5Q5SaWOGtJZTKkRBNNopoMHIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4QT8n9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4QT8n9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0001F000FF;
	Thu, 17 Sep 2026 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668090;
	bh=eWhSDGD3rp9F5q79eMBHJMiDclqHDlytcbGnF46BPps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4QT8n9RHFn9+TMW9CHFRLHdyEofNMnCFTd+HmiGwduFfG/Bk7tFkGL887HLkPOyk
	 cf6UW0voLwXn0hQMJw/RhLomspV0Lz2Om/Yn14+SAuO7SNIpH2kta2nnfGarNWsQKB
	 v6GNMjTVL0sotvbjH/lvNbGXe9Atz1CdFxLUk6wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0310/1102] i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA
Date: Thu, 17 Sep 2026 16:04:13 +0100
Message-ID: <20260917151547.404030181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c236563c8a84239d31a1e6ec4444887a7b5ed98f ]

i3c_master_add_i3c_dev_locked() no longer leaves the address marked as
free on failure, so aborting the DAA sequence on its error is unnecessary.

Failure to register a discovered device does not invalidate the entire
Dynamic Address Assignment (DAA) procedure.  Align with the behavior of
other I3C master drivers by ignoring errors from
i3c_master_add_i3c_dev_locked() and continuing enumeration.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260612080107.11606-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c | 4 +---
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
index 1b4f4d0db486a..9acfccf785aa3 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
@@ -359,9 +359,7 @@ static int hci_cmd_v1_daa(struct i3c_hci *hci)
 		 * TODO: Extend the subsystem layer to allow for registering
 		 * new device and provide BCR/DCR/PID at the same time.
 		 */
-		ret = i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
-		if (ret)
-			break;
+		i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
 	}
 
 	if (dat_idx >= 0)
diff --git a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
index 3d33bfe937a6a..3ab51aaf63dc1 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
@@ -299,9 +299,7 @@ static int hci_cmd_v2_daa(struct i3c_hci *hci)
 		 * TODO: Extend the subsystem layer to allow for registering
 		 * new device and provide BCR/DCR/PID at the same time.
 		 */
-		ret = i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
-		if (ret)
-			break;
+		i3c_master_add_i3c_dev_locked(&hci->master, next_addr);
 	}
 
 	hci_free_xfer(xfer, 2);
-- 
2.53.0



