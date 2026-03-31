Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB442D1F40;
	Tue, 31 Mar 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975626; cv=none; b=rB8lH9tyoh/Uz0rYJvHIBdorNbBOMT38MYduevAahtGuhpqlyJiPfxGJZ6k1aAVKobERFecukyHeuqc5P1tLXINts8gknpZWTqsblidHMiNyDkrdReX1GPURKJ49KDFyfahFxaJ21ZOHBCzFY/4hrEQNncBrzmlIPRCkrxi+Fg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975626; c=relaxed/simple;
	bh=CF7hN5WZr+6jzYZLdjNDrPEogN14voePBdH7O9AecwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJmrF7TKglu4jka1ZxvLLx246HteRrXQ4yIjTIZHB9Rwye06vsBwlEQByDCrRKyAdjiN5cPs43+85QlO8wtl/GjzDsgRo4Dyli2NGEhPWMn7ShR1txxUMFlCIK3kOgfGxEUT8t6yXYyf+HMqkz9w5f3l2T1bKNLfWzYh7cc3K/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peDGJpt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peDGJpt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DF3C19423;
	Tue, 31 Mar 2026 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975626;
	bh=CF7hN5WZr+6jzYZLdjNDrPEogN14voePBdH7O9AecwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peDGJpt2QnlbddSfEBuDSDue1CZ/ScIUQfQmxRPh4op3RRa+Szekt/QEUPEE5RXGp
	 Dx9qm8+dy2yKfTqjgFGHknKaN7cT1UMmNvFC2P6JFZHedf8S6XIzDIgf4WyhfHCvu9
	 lTry9XObfkH5QWXYafSUUzSnYUNQMF060DV3u62c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Sioen <romain.sioen@microchip.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/244] HID: mcp2221: cancel last I2C command on read error
Date: Tue, 31 Mar 2026 18:19:34 +0200
Message-ID: <20260331161742.597167974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 83941b916cd6b..f7b12d4cd2160 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -337,6 +337,8 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
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



