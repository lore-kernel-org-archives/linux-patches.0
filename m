Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637B5383D6;
	Thu, 17 Sep 2026 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664569; cv=none; b=idmefW22hHr/Jfwtl0LfTsYpO3ycweamrFW/O7RwedsIPgX/Sx2jWpYuNEATavUWc+wdsqui8MGMP/tR3jBPAZQEWvZolcLIiYcBIDv8oYXlcOFSQPweZe7PzNO7H3dWJEhFONDqErVe68obu7cofLc+NFfXSPazLvAexffyjqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664569; c=relaxed/simple;
	bh=BpqMKo0mS9UUOBkgoB2bFpS/ZzYa2PQ6tBwHikYH9TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdeZB7yJASmPkrwc7H56yLCBQsTseuNP6C1EBv1lV3udqBxHKCX+NNR6/+bbnSutbZB9V7Jfpvv3ufVnALdsqBWaYhHX1Fdv7JFawFzi5DsgBJKd6iw0UeGZMF3G6V2HdSeiy/JvNPa1JOrZZtfBoKdVG73bDDJYOYv42F2Jpn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiLTRzGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiLTRzGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28E71F000FF;
	Thu, 17 Sep 2026 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664567;
	bh=9hS4gYVqYG0wVthIN8PnQVh4nKVGsKV33gF4517wqlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiLTRzGiRoZBXTMMvUe6ZqkEzlPzRsbDfyjMBRs31gGnG58z/VbHECzhbfztAxJ59
	 vP+8ceMZeRe5RoCAgA/sRSV1CnU5DIfDF+cCd7iGIZrfH/dw1y64E9wxzLG33nMDo4
	 0x/Nnq4s/HPmg++aG9wauC4UvQbyZQadHTmdk/UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0415/1250] i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA
Date: Thu, 17 Sep 2026 16:03:30 +0100
Message-ID: <20260917151603.274232238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index efb7a1f92641c..b6ba18ccdd2d3 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v1.c
@@ -362,9 +362,7 @@ static int hci_cmd_v1_daa(struct i3c_hci *hci)
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
index 5fc2e4c55ebb0..d7999d341a227 100644
--- a/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
+++ b/drivers/i3c/master/mipi-i3c-hci/cmd_v2.c
@@ -300,9 +300,7 @@ static int hci_cmd_v2_daa(struct i3c_hci *hci)
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



