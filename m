Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029085955;
	Tue, 14 May 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687526; cv=none; b=iERYLkHJRC3jLcETJdzucI8tbIaCc1Iw6IxTT3ZKCHZF7JohoDbyXG0xIPJ+wEtglvGWiCtuQFagpdkQNznHkpqISwgFJuj0/+ZgSemRofMeiSxPsy6kpcaCEMVk0itEA1bAASx9pQKvjuZX+xSBxe0FgiP3YQDFDvyU5nxp0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687526; c=relaxed/simple;
	bh=54xKi9RhPgvPsfhYme1TmRxBuozpICh3moJxCd+z1tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEcmuGmYzdniAl+pUtHVnbMa9m8sFB9LxtETtuDLswBFdANJhQ0YI8gI/JdJsueL+l4B1MeaYSwcpSz1DzPkDnmnSnC6HbFukzs38mOB0C3Bozf8oRTHlMZTyqnhrU76xnIkWX083nM6Lp7CYDi9GNfqFLLo+uXc89QZrPPrINo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjM+Rwof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjM+Rwof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96B0C2BD10;
	Tue, 14 May 2024 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687526;
	bh=54xKi9RhPgvPsfhYme1TmRxBuozpICh3moJxCd+z1tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjM+RwofV0Sd4wOkQ2eWER/9dEKAAkdcaaE+4LPsp+RvMLEoHZccgRz125fQQojiQ
	 Yw4V9D1WNj+0PNe6KwZOeXhP3Wr9t+6n0rWcF48es2fjTqqu8vYs7coUlqBWM7Dq/n
	 IBKSbBgytCBqTFELHx/xwW0nut/9FSoGAQt4mQwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/168] eeprom: at24: Use dev_err_probe for nvmem register failure
Date: Tue, 14 May 2024 12:18:25 +0200
Message-ID: <20240514101006.962553097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit a3c10035d12f5ec10915d5c00c2e8f7d7c066182 ]

When using nvmem layouts it is possible devm_nvmem_register returns
-EPROBE_DEFER, resulting in an 'empty' in
/sys/kernel/debug/devices_deferred. Use dev_err_probe for providing
additional information.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: f42c97027fb7 ("eeprom: at24: fix memory corruption race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at24.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 305ffad131a29..b100bbc888668 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -762,7 +762,8 @@ static int at24_probe(struct i2c_client *client)
 		pm_runtime_disable(dev);
 		if (!pm_runtime_status_suspended(dev))
 			regulator_disable(at24->vcc_reg);
-		return PTR_ERR(at24->nvmem);
+		return dev_err_probe(dev, PTR_ERR(at24->nvmem),
+				     "failed to register nvmem\n");
 	}
 
 	/*
-- 
2.43.0



