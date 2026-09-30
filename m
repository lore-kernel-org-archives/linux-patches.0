Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866E5514753;
	Wed, 30 Sep 2026 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784550; cv=none; b=FWkTJyXkfNFJZsuQ9380eH3rDxTeMuEJYtZfRODrVDmXMCqQZp0sdoQfvfcnZZLenXE2nPijeKnCr0Il8c7O4IyACaYQE5aRiyWdFFbMzk9UTH6IBCO+QqyDtq3VRIbkadoCK2Gzw370tOms1pjJzG/Oftru85gO0Nls05kc2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784550; c=relaxed/simple;
	bh=UnOvfK+k6TcBdzHhJjouisEr1F9MhKe7s8I4VPXV1A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHsTQmcZNdln3EJImWTBf3iRoej10rIcUzYkWiq+0zhvcLQoQIcNBgFZ7/i4/CKILXD7gj2Sn5CbBnmbQUOLGQSpyjPMZ3EaGgTQ4+0eycVVjhB5XlWMPJVuQFvdXWrRRPld3V59guOxqxEDKegNvEdqrWYbtNt9K+ZJa07HSUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIRh0dCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIRh0dCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC051F0089C;
	Wed, 30 Sep 2026 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784547;
	bh=pPcqbJKT7VKpb1PPi7C8LPKrywNLhIRat4dNvf6h0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIRh0dCjiKabGKvD8dJ7BbuHv7Tche6dqv3Sau/iNikrQSq5HGZgZ9W0+3pSpCVTS
	 utDOdEKizmn1AX/uj7sBUhe4xAF0lM+uVaQdU4RLNNT9hqxSKQbE6MZQFAsOPuk42a
	 ian4X3nvBJl5mXFGGlHCqamECt4voo7WUMHkC/Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/982] i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA
Date: Wed, 30 Sep 2026 17:15:30 +0200
Message-ID: <20260930152420.982516509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 61e34ed8ca533..3be836e859234 100644
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



