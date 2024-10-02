Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5C01D07A8;
	Wed,  2 Oct 2024 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877186; cv=none; b=opb+mSb7991Nwqn/T/Yro8B4v9KlvzX+JsGcoTxu2NNJha716vDnS6T1DGCh86I7zotomjbt/zxCsLHD21OOEqsHE7/O9DxdxprNN3bp9rfOCOfDluk88h4INckzWw3vDeMVI1IhbBSH17gKSGNmufVniPQSvVTMei3t/GVOLAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877186; c=relaxed/simple;
	bh=35DeZ4AjRzAhc7z23W1iCRixgVwYTkSuXgovOqS6gFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afuInU69gk+lyDf5UWTwRZT27SUgwoG2HNmme2aT/HOw2J013sVoWdhz1niW7oa9oLwMroMlifBlm6aI9RjZSzVqgWf/wuXadnYyQkkA810cNI2z4klI2AVvG6Mvik2rTTbu10K+XEVCv4FJoCGUD+ZBasXFBxLJ5NQ8ikCczMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNMOUQeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNMOUQeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99583C4CECE;
	Wed,  2 Oct 2024 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877186;
	bh=35DeZ4AjRzAhc7z23W1iCRixgVwYTkSuXgovOqS6gFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNMOUQeqpNtcMwBhjvSv5J4FSFjgwHP2F07GN3LpNJrl00OopxWcVTZdqplCQeoLk
	 37YpbfFox1luFCRhAjxBCiFtDESagFX/CwLOIJMVaSteuomkjalncQ0NF2CdxxhsbE
	 C1ZqHQFUowfCLKGWtUuPXEZ9OxPegdkgMlBrLQJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 663/695] usb: typec: ucsi: Call CANCEL from single location
Date: Wed,  2 Oct 2024 15:01:01 +0200
Message-ID: <20241002125848.973452355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 4f322657ade1b784bb2b1ba8761469ae87520681 ]

The command cancellation can be done right after detecting
that the PPM is busy. There is no need to do it separately
in ucsi_read_error() and ucsi_send_command_common().

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240816135859.3499351-6-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7fa6b25dfb43 ("usb: typec: ucsi: Fix busy loop on ASUS VivoBooks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 17155ed17fdf8..26a28c7b680b1 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -115,7 +115,7 @@ static int ucsi_run_command(struct ucsi *ucsi, u64 command, u32 *cci,
 		return ret;
 
 	if (*cci & UCSI_CCI_BUSY)
-		return -EBUSY;
+		return ucsi_run_command(ucsi, UCSI_CANCEL, cci, NULL, 0, false) ?: -EBUSY;
 
 	if (!(*cci & UCSI_CCI_COMMAND_COMPLETE))
 		return -EIO;
@@ -148,15 +148,7 @@ static int ucsi_read_error(struct ucsi *ucsi, u8 connector_num)
 	int ret;
 
 	command = UCSI_GET_ERROR_STATUS | UCSI_CONNECTOR_NUMBER(connector_num);
-	ret = ucsi_run_command(ucsi, command, &cci,
-			       &error, sizeof(error), false);
-
-	if (cci & UCSI_CCI_BUSY) {
-		ret = ucsi_run_command(ucsi, UCSI_CANCEL, &cci, NULL, 0, false);
-
-		return ret ? ret : -EBUSY;
-	}
-
+	ret = ucsi_run_command(ucsi, command, &cci, &error, sizeof(error), false);
 	if (ret < 0)
 		return ret;
 
@@ -238,9 +230,8 @@ static int ucsi_send_command_common(struct ucsi *ucsi, u64 cmd,
 	mutex_lock(&ucsi->ppm_lock);
 
 	ret = ucsi_run_command(ucsi, cmd, &cci, data, size, conn_ack);
-	if (cci & UCSI_CCI_BUSY)
-		ret = ucsi_run_command(ucsi, UCSI_CANCEL, &cci, NULL, 0, false) ?: -EBUSY;
-	else if (cci & UCSI_CCI_ERROR)
+
+	if (cci & UCSI_CCI_ERROR)
 		ret = ucsi_read_error(ucsi, connector_num);
 
 	mutex_unlock(&ucsi->ppm_lock);
-- 
2.43.0



