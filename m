Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E61537FF;
	Sun,  1 Sep 2024 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208646; cv=none; b=OiEZG4vAs9dDPgmIHMlstmq0Mm7hNeAPSAMXlzK+rDNAm8cNN6KzwrF/qje+kxnvJbT8Ohrx9wRjg9KhLqoAKUmxzgXnIV63UBwAdA5v5Jwi+yL7s+c9hYHadj1uTMfcvzviVMMQyDtHF/hnfwChQzfiHnfMqVrPqikRLpSJD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208646; c=relaxed/simple;
	bh=65OwdB0w3oF4b7LrA/v+KXVOSUnCyZTsBsLmb3Hqa4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9lJB85N32YHy1ygz9SuwDxNWFqNP6ph8ztwx835k+F43M6FOOKBM8qSEr6zQT5Ry4oibL8PCGPgxVcUyaWpi6ghneRJ4i5Gl7/zHKgYsrOvzUinTS4/xbyfNAutve+5eFvK9ubfVUJzi+6W8IVBZ6qhsDxp8HUr7/CXXEN7r9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnb1E2zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnb1E2zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0119DC4CEC8;
	Sun,  1 Sep 2024 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208646;
	bh=65OwdB0w3oF4b7LrA/v+KXVOSUnCyZTsBsLmb3Hqa4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnb1E2zD4+UxG7CgZJDKxKzdmbP7TNQNlIxCXJwpVo01zv8IwpdzEg7A/IQH3up6v
	 kE1M43YN8h1DcehWmvVOkoIPiVHQzC/Y8tHJoCsWizd1Dn7hdIo4zqdsrupY8NsJzb
	 ep6ZnGcl2MkTR+RTnFQaxG+m/fRputu9VZXSqNXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wilkins <steve.wilkins@raymarine.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 146/149] firmware: microchip: fix incorrect error report of programming:timeout on success
Date: Sun,  1 Sep 2024 18:17:37 +0200
Message-ID: <20240901160822.937050713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wilkins <steve.wilkins@raymarine.com>

[ Upstream commit 591940e22e287fb64ac07be275e343d860cb72d6 ]

After successfully programming the SPI flash with an MFPS auto update
image, the error sysfs attribute reports programming:timeout.
This is caused by an incorrect check on the return value from
wait_for_completion_timeout() in mpfs_auto_update_poll_complete().

Fixes: ec5b0f1193ad ("firmware: microchip: add PolarFire SoC Auto Update support")
Signed-off-by: Steve Wilkins <steve.wilkins@raymarine.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/microchip/mpfs-auto-update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/microchip/mpfs-auto-update.c b/drivers/firmware/microchip/mpfs-auto-update.c
index 835a19a7a3a09..4a95fbbf4733e 100644
--- a/drivers/firmware/microchip/mpfs-auto-update.c
+++ b/drivers/firmware/microchip/mpfs-auto-update.c
@@ -153,7 +153,7 @@ static enum fw_upload_err mpfs_auto_update_poll_complete(struct fw_upload *fw_up
 	 */
 	ret = wait_for_completion_timeout(&priv->programming_complete,
 					  msecs_to_jiffies(AUTO_UPDATE_TIMEOUT_MS));
-	if (ret)
+	if (!ret)
 		return FW_UPLOAD_ERR_TIMEOUT;
 
 	return FW_UPLOAD_ERR_NONE;
-- 
2.43.0



