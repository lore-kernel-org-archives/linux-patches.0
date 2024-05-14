Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001F1E4B0;
	Tue, 14 May 2024 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687222; cv=none; b=MhID4XcKnO/AuwTBqwXEZdckiTHkF++3ng7oU1XJTBwwpoJ0kdMzSfkhPbrhYggssrKvynoTppdSnZMgGuZ+Aww0sY3aG0+mxNClgk1U4UUQdydgKioLWoNgb1C4v8SxBMdBhYw5fEYDYoB0b2ztPEB2JHOsH3v2UNEPreYsNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687222; c=relaxed/simple;
	bh=nqLtbwzOHhbK9IIh7sT7E+lB4+muNoMH0Ed6Xdvg26M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diNsOWOkzbATm+9x07APPs6sqq+1y2+1MYch7iJBXARKoCLlTbXlLZSlcY70sLd6a9X49PhfaRsN2VmA9v+GH0R65uMiKxK24Jmb32+cyc3vg0g1+jsIj3iwRKTrGQDZravIBuTsG9NzE2lm4s0x0QcpCreirpAt2IsPx0erPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsbCj7eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsbCj7eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765C7C2BD10;
	Tue, 14 May 2024 11:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687221;
	bh=nqLtbwzOHhbK9IIh7sT7E+lB4+muNoMH0Ed6Xdvg26M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsbCj7eQnou8iD0GcYXWjLSqrx1lotGGQ1NR4jFptmiWHvnl/+stXJ1NOWOo37Nwz
	 1kjnty0VoFRHml45WtPmzhGyCYnEXK6r/Q6Q+/zSDsM5+jHk142Qo+KScp3EojiFww
	 brBqTCp8sJElYbdjDT412iGAVi08Ez+M+fOA9+nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/111] eeprom: at24: Use dev_err_probe for nvmem register failure
Date: Tue, 14 May 2024 12:19:02 +0200
Message-ID: <20240514100957.287342814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



