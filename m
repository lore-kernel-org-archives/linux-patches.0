Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7DC1F9F70;
	Thu, 12 Mar 2026 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346650; cv=none; b=VdlAPr9YCLIAOQ5lD1yRk4REDTdkV75ozO0HIOa5fwzGp275XisqCm5YANpG5cnd11eb1l7LASrdLSXAiwa2q7bxj5ghph56uPE/FiWOCXuZSdFvx4SdtOxa8hNetM3fPhr5bUYhXzw96/yj/2GTgZUizC1MkILGIWspbkoTGn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346650; c=relaxed/simple;
	bh=dZ2+J8K9+S1GoSswDVte8a4T4p0sH76CcBZWgvKv/B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFCch0w4rGJZcJjF6h20Az66B4D3cEx0lqQxDd8Jh1CcTg7TY8duhQyOjbyeMz63jMnuEZe91Z7MXGOGvBaClt+0AxC3wnXkF46SJcxeQpaHDrGuh8Vu5NaqL8d4VhDHnRgpCVN5sW5jBOjryN+UacnefNygxFC4WPVU5T03D1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAtrefky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAtrefky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42082C4CEF7;
	Thu, 12 Mar 2026 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346650;
	bh=dZ2+J8K9+S1GoSswDVte8a4T4p0sH76CcBZWgvKv/B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAtrefky7Y8Sg3vnwKeYOw1xR0QiHI+mEUmJT70/UJbr28D0DGDSpgUd8v/4PZs2p
	 BJTHPTdKh9wpbdMKoNsMH7XrXi/IPj1QAnVCR5BfR/AlVooF0X7OEw2crK9gzEPE/P
	 OTDYNHpYgp8Ctmc2/okVLDpLBBMIZje+Pz8+o9dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseong Kim <ii4gsp@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/265] Input: synaptics_i2c - guard polling restart in resume
Date: Thu, 12 Mar 2026 21:07:50 +0100
Message-ID: <20260312201021.218257971@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Minseong Kim <ii4gsp@gmail.com>

[ Upstream commit 870c2e7cd881d7a10abb91f2b38135622d9f9f65 ]

synaptics_i2c_resume() restarts delayed work unconditionally, even when
the input device is not opened. Guard the polling restart by taking the
input device mutex and checking input_device_enabled() before re-queuing
the delayed work.

Fixes: eef3e4cab72ea ("Input: add driver for Synaptics I2C touchpad")
Signed-off-by: Minseong Kim <ii4gsp@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260121063738.799967-1-ii4gsp@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics_i2c.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index c8ddfff2605ff..29da66af36d74 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -615,13 +615,16 @@ static int synaptics_i2c_resume(struct device *dev)
 	int ret;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct synaptics_i2c *touch = i2c_get_clientdata(client);
+	struct input_dev *input = touch->input;
 
 	ret = synaptics_i2c_reset_config(client);
 	if (ret)
 		return ret;
 
-	mod_delayed_work(system_dfl_wq, &touch->dwork,
-				msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
+	guard(mutex)(&input->mutex);
+	if (input_device_enabled(input))
+		mod_delayed_work(system_dfl_wq, &touch->dwork,
+				 msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
 
 	return 0;
 }
-- 
2.51.0



