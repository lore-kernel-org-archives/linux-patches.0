Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1231826E158;
	Tue, 11 Nov 2025 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823050; cv=none; b=tEawgTJ37v/pPdRkhDKLjxkFASx8vZyUMybBc8LzxRbAvswPuaAiMtpLKolc11EcHcFSJkoEU5E39QJtjPoW3GwBGwuNcFK87jyiGuxR03JmwR6aWcoMMacL2PNag/YBXnXAwuJNsEEFGfEQxvg2Gg/CaMx9VGFuXx9DXLSA78I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823050; c=relaxed/simple;
	bh=9Umi8jI2P1j6S6Zh2UqbTdv3H6bsVI3zIacTRiAEYxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8cL+KZYlgzN7sWcKhEEy98YcO8f2HktfK34rC3tCR5IWCW40/pIjGFrLepULKjzBFG/HdSs+aHoooaXiv0mlNjS+1R7js/VknyxiFzp3fVqw/bpmGlpoPhtxxn4QYOkv7pd7NO2sxrP63Ez9X91hTuhICTzG/ZRoIpnZm0gutE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGpCHw3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGpCHw3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38621C113D0;
	Tue, 11 Nov 2025 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823049;
	bh=9Umi8jI2P1j6S6Zh2UqbTdv3H6bsVI3zIacTRiAEYxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGpCHw3MiUjGCX6XaNsP6/NTJNsi/gWQdlbhtRGEY4fBwwEoyCdlM/wxO9+tOi32y
	 JXn2i96fVaVB0dUGUyhBjchidhtoeYG7ZVhVj6vpjcRLYbtRVWDN47AVq9rS+HKy9v
	 SmHiHfgYwnTpzuiyiYbL0w1JJWbZOWqZJ/nKZTOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 221/849] mfd: qnap-mcu: Handle errors returned from qnap_mcu_write
Date: Tue, 11 Nov 2025 09:36:31 +0900
Message-ID: <20251111004541.782366549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit bf2de43060d528e52e372c63182a94b95c80d305 ]

qnap_mcu_write can return errors and those were not checked before.
So do that now.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250804130726.3180806-3-heiko@sntech.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qnap-mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/qnap-mcu.c b/drivers/mfd/qnap-mcu.c
index 89a8a1913d42d..9d3edc3e7d93b 100644
--- a/drivers/mfd/qnap-mcu.c
+++ b/drivers/mfd/qnap-mcu.c
@@ -163,7 +163,11 @@ int qnap_mcu_exec(struct qnap_mcu *mcu,
 	reply->received = 0;
 	reinit_completion(&reply->done);
 
-	qnap_mcu_write(mcu, cmd_data, cmd_data_size);
+	ret = qnap_mcu_write(mcu, cmd_data, cmd_data_size);
+	if (ret < 0) {
+		mutex_unlock(&mcu->bus_lock);
+		return ret;
+	}
 
 	serdev_device_wait_until_sent(mcu->serdev, msecs_to_jiffies(QNAP_MCU_TIMEOUT_MS));
 
-- 
2.51.0



