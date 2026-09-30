Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2D521887;
	Wed, 30 Sep 2026 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791010; cv=none; b=eaFM4M3RHg64BHGF0pYZyGEzBbY/V36kFdeZagKH7+gZVuIKbbJwNQ33olx4PEQXX9NmJjVvjCs3IRr/3NSBzeXY41UUpnDWJty1A2YBESKQyv7po3CuWa506H8nv2PM0eA3sqHex6iA+16Kj5erBv/PbYkH+i5Immmq+54fTLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791010; c=relaxed/simple;
	bh=VMxTaw1wcYCLQCaYoxxgMcHxM54eycFw1gCTAmFpEEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leT9OXMBOEnq2TUkvlXlrZmBdde6MO/dEajDu5NeR+idTKjHqfU3j6i2qDfRPlaJem00Hny+s+yfnBIwPsr0IQLxEndTfStvQzp1QWmq8DGTBdXh6SSdKWArAxHgmaV5yjDjx12HOTKgn6+g7rgvWqwyDzzSYYzRN4lPcg94szs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy94Ds2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy94Ds2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383CC1F000FF;
	Wed, 30 Sep 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791008;
	bh=nExnxs6Ax3aduHazPUUoLacVgfWb8G+Po9gDh5/Ud8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy94Ds2UqcOITu5IT85b325JdaAk/xUWeKdISIRHWLO9NlQzpLW39Zxec8mC2WxFC
	 0lA+B1bvwkFdnApOUC2aL98NKg0tSA5rK3iAdVVumaJihUccOo1gJJ22YkBf/XQCo0
	 nhBsQaXcmf+e6kIpvJ6U/dVemnSbNEe+bF8+0K4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/752] i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA
Date: Wed, 30 Sep 2026 17:20:22 +0200
Message-ID: <20260930152401.476006574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



