Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D636D50D;
	Wed,  8 Apr 2026 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671644; cv=none; b=qvzzMOpdG0EsTA4mDwLxIi+RxMX04G9HipTyOxemN7vaw6Ovq80JSGWPyvLQh2Ky6VvethvoY7DaKJM9ffs95FN9WBwF0FouUiotOQwzyKOCu10/NM9/FZk5wwhfx26v4+GMG1WIMShFvRfg2mzdHazX2n1wXv/b3vYmPA/AFT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671644; c=relaxed/simple;
	bh=5UUYYmxB+PZWNOVxTgjvnIqwmSLyYfbTTcskrxqAp2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wqibg7+Nmh8Sh8IX8gLEl1A6lla2nmeIwq4scIZtXJxX+8JuUzZ+G+R4ulwjn1SFaBG2EBMTUdhnUCG5uliy5RlCi5mKuBktP/IQnGA9F5NhsUpaoFCexIFCb2F5MHtCTqCR9oaJmmWm6i+Bq7zaLX9sIiDATrNYZiN7tVY9l7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5ShfyPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5ShfyPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A4C19425;
	Wed,  8 Apr 2026 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671643;
	bh=5UUYYmxB+PZWNOVxTgjvnIqwmSLyYfbTTcskrxqAp2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5ShfyPRIncrn7T6yoiNn2sswZWs7/fpbBaRvKnG9pchgJSUEXTuLtiCcuhg2jIBN
	 C7Z9Wx3p90i2ll+jGJEZH62pNHVmf2RPXFZZ4VVwpQWmieebcqGtx2lhbFiJDP3WD7
	 Xu+agNq3xUrjUYOL4VpiaRY72bLfVyuV/V/4M2BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Sioen <romain.sioen@microchip.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/312] HID: mcp2221: cancel last I2C command on read error
Date: Wed,  8 Apr 2026 19:58:50 +0200
Message-ID: <20260408175934.224917668@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Romain Sioen <romain.sioen@microchip.com>

[ Upstream commit e31b556c0ba21f20c298aa61181b96541140b7b9 ]

When an I2C SMBus read operation fails, the MCP2221 internal state machine
may not reset correctly, causing subsequent transactions to fail.

By adding a short delay and explicitly cancelling the last command,
we ensure the device is ready for the next operation.

Fix an issue where i2cdetect was not able to detect all devices correctly
on the bus.

Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 474f563c23a43..e1bd1744bf307 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -319,6 +319,8 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 				usleep_range(90, 100);
 				retries++;
 			} else {
+				usleep_range(980, 1000);
+				mcp_cancel_last_cmd(mcp);
 				return ret;
 			}
 		} else {
-- 
2.51.0



