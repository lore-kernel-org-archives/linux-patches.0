Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49887390212;
	Sat, 12 Sep 2026 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242857; cv=none; b=n8gBpUKOnMMQteYBfGb6Eb8+M99Il9NZ1+pU8KVP68EJet577PTzmhhXb61fIqFvRjKb/Xzamf3gUgP/ZXRLvMyKtSE3WXGASR4/Kk57fHF1I3COJGmv+pLZHizY3qSgoz0giUs0zEE+xpNma9sxrAC8tRn52+jrFbgSpU5TFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242857; c=relaxed/simple;
	bh=bhP++3/ePQez6x7/7WGc7H3rW6mtisdJbunO8FcMZmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hezeZ4xDdPpG/+xj6nLKN5xWnFwFsybC+Zgs8X2hmaaCIqkH7mhtDbl7oh4Pa8tcgxvEH724Ks6XERlzJgB5rcwInG8QXeaCg/jC9QckVCKDz6yu0LNPOH/TuM4c5ugQ4laCkBH3cS6kF//x7BksEhFI9NzntmJZhW2yubvu7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmmnAfDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmmnAfDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C571F000FF;
	Sat, 12 Sep 2026 19:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242856;
	bh=S1H2MXeWFC095gCDiVmtWXABlbNzmEI9L3ZfOpJjGBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmmnAfDAjGZtisIhIgZ7UHoh2g53dxEecbWiIgFnIHtimoNgfOJh1bSzbv5BxL+w6
	 QK/3WH8db1v4ETa7vcGL25/QfGk+MG+wbCQ5rFTBr+5pNf+YQBo29HhR3nZdoHKj3P
	 knJxNqthTwGkf+sUtfYugVEe6jWUMlNcT1mNAF9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 551/798] i3c: master: Fix device_register() error path
Date: Sat, 12 Sep 2026 09:02:59 +0200
Message-ID: <20260912065529.757665114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 74be657d98a8d684c0475f3cbd450ef2a30ffc73 ]

When device_register() fails in i3c_master_register_new_i3c_devs(),
put_device() is called to drop the reference taken by
device_register().  That drops the last reference, so the device's
release callback i3c_device_release() runs and frees the i3c_device.

Two problems follow from that:

i3c_device_release() does WARN_ON(i3cdev->desc), so it warns because
desc->dev->desc still points back at the descriptor.  Clear it before
calling put_device().

After put_device() frees the i3c_device, desc->dev is left pointing at
freed memory, so clear desc->dev as well.  That prevents, for example,
i3c_master_unregister_i3c_devs() seeing desc->dev as non-NULL and
dereferencing it.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260701203053.8F3971F000E9@smtp.kernel.org/
Fixes: cab63f6488761 ("i3c: Fix potential refcount leak in i3c_master_register_new_i3c_devs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260702183644.60827-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 6c609f409d45b..0fff6e6e0b53a 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1548,7 +1548,9 @@ i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 		if (ret) {
 			dev_err(&master->dev,
 				"Failed to add I3C device (err = %d)\n", ret);
+			desc->dev->desc = NULL;
 			put_device(&desc->dev->dev);
+			desc->dev = NULL;
 		}
 	}
 }
-- 
2.53.0



