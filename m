Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D181AAE02;
	Mon, 14 Oct 2024 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916004; cv=none; b=sv70qcKXND2mM5Rsz0cQFirsUBB8WK+tWjkAIlKZRXUMvFSDq4sQpICXqq6rNC9Sid7eH5bmLTb2H7FFlsyq5gB7ftEfMMSV4VZq7X60n+vgiKEu4X7dVLiMFfFZ3fAOu4rQO9NOdMH+3LmZWRUKY+te0wskCBL67E7hGuJuSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916004; c=relaxed/simple;
	bh=zX1+NLfyGFZVRb2chfr9SyVec9t5pBlFlqT3iJl+bbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbiHVzTKatdJ3mIC/W8EX/Xl++qlh67swryj20p/V5M77NPSClp3ubObDHonnFqJ7g72yTebvDS409a5BokUXwegRpFEiZfDlR8Gs1KGHJGCnuW8m9eGlO2Dt6VeCDUtfA2rzMc/u7se/7hPSqHaIyAnfsrFlFhRkLgxRCoV2Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSi2Xk2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSi2Xk2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A73C4CEC3;
	Mon, 14 Oct 2024 14:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916004;
	bh=zX1+NLfyGFZVRb2chfr9SyVec9t5pBlFlqT3iJl+bbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSi2Xk2MwFKpxRq4dzLBv4KdcWoy7dt/orUFZexNH85P8P1g68xAcs7LKufYKeThF
	 L2dp5M1Lfp/+03KYBIowHjxblj6Im22yt4ogu50hEqkqnzKaBNw46NmL6tfpscgYma
	 V5X8LEHyhUhiXZujGoqzVBnH4HxKAKpHpDctda50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 056/214] usb: typec: ucsi: Dont truncate the reads
Date: Mon, 14 Oct 2024 16:18:39 +0200
Message-ID: <20241014141047.176486299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

[ Upstream commit 1d05c382ddb4e43ce251a50f308df5e42a2f6088 ]

That may silently corrupt the data. Instead, failing attempts
to read more than the interface can handle.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20240816135859.3499351-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 8 ++------
 drivers/usb/typec/ucsi/ucsi.h | 2 ++
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 8cc43c866130a..8a81fec9efe36 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -103,12 +103,8 @@ static int ucsi_run_command(struct ucsi *ucsi, u64 command, u32 *cci,
 
 	*cci = 0;
 
-	/*
-	 * Below UCSI 2.0, MESSAGE_IN was limited to 16 bytes. Truncate the
-	 * reads here.
-	 */
-	if (ucsi->version <= UCSI_VERSION_1_2)
-		size = clamp(size, 0, 16);
+	if (size > UCSI_MAX_DATA_LENGTH(ucsi))
+		return -EINVAL;
 
 	ret = ucsi->ops->sync_control(ucsi, command);
 	if (ucsi->ops->read_cci(ucsi, cci))
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 5a3481d36d7ab..db90b513f78a8 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -435,6 +435,8 @@ struct ucsi {
 #define UCSI_DELAY_DEVICE_PDOS	BIT(1)	/* Reading PDOs fails until the parter is in PD mode */
 };
 
+#define UCSI_MAX_DATA_LENGTH(u) (((u)->version < UCSI_VERSION_2_0) ? 0x10 : 0xff)
+
 #define UCSI_MAX_SVID		5
 #define UCSI_MAX_ALTMODES	(UCSI_MAX_SVID * 6)
 
-- 
2.43.0



