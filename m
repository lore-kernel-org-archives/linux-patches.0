Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F43BF307;
	Thu, 15 Jan 2026 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497978; cv=none; b=DhnUO+S7+bk9/THeB/Zc/f5cIU+ZocWpCbPGryR7wD6qSNl1SdkI/x0qoHQCCvOQHRv37lkyWUyfvI1SSt2kuZ2XrMdU8CHRjXdWqhs7xjYM5CmV5S6UKh3I3lOQTWTmA31kGDk/6u4VEpuLpyFL+atc/2Xipst2pknbAmzflVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497978; c=relaxed/simple;
	bh=nLsrjFqepDHgo9rBcGY7DcYSqZLqkK+sSBLzZZHEpMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clfKVTQzLfdBVik3ZEDDSHaH0zs1mX9HsLdJ6i/OjIfHyNOZn57zxquQhi0KNLFuaXe/N7tLy/ZIg74Pp/1kO3X6vOZ4j4yarcaloKRC/sTFcFyziVkOi/Jp6cYrp06EmWywB7SE0oE94uSqPmmJXxVoU92SiK9/RHesmXVHROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzue2EfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzue2EfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449BEC19422;
	Thu, 15 Jan 2026 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497978;
	bh=nLsrjFqepDHgo9rBcGY7DcYSqZLqkK+sSBLzZZHEpMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzue2EfCDCW9O8NFUdztJqSC5pJX2Jo51+Ke94AJLerMCal34neatsSOzhrOOZyfP
	 dnyufqDhj/FXCiTChhTvtqbOoDD3tzQrKzgJtQseeMy4npfiv/a29UPdqLlILuoVdO
	 cXuzRSiQRnys1maJ6fZ1WNQKs2igwVzWrIqZZr1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/554] usb: typec: ucsi: Handle incorrect num_connectors capability
Date: Thu, 15 Jan 2026 17:45:35 +0100
Message-ID: <20260115164255.967966107@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 30cd2cb1abf4c4acdb1ddb468c946f68939819fb ]

The UCSI spec states that the num_connectors field is 7 bits, and the
8th bit is reserved and should be set to zero.
Some buggy FW has been known to set this bit, and it can lead to a
system not booting.
Flag that the FW is not behaving correctly, and auto-fix the value
so that the system boots correctly.

Found on Lenovo P1 G8 during Linux enablement program. The FW will
be fixed, but seemed worth addressing in case it hit platforms that
aren't officially Linux supported.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250821185319.2585023-1-mpearson-lenovo@squebb.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 62124882b21a..05a2909e84fd 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1270,6 +1270,12 @@ static int ucsi_init(struct ucsi *ucsi)
 		ret = -ENODEV;
 		goto err_reset;
 	}
+	/* Check if reserved bit set. This is out of spec but happens in buggy FW */
+	if (ucsi->cap.num_connectors & 0x80) {
+		dev_warn(ucsi->dev, "UCSI: Invalid num_connectors %d. Likely buggy FW\n",
+			 ucsi->cap.num_connectors);
+		ucsi->cap.num_connectors &= 0x7f; // clear bit and carry on
+	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
 	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
-- 
2.51.0



