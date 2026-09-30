Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FDD50AC28;
	Wed, 30 Sep 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784112; cv=none; b=Xo8mPYuA5UHw9880M6K1JeooKw5k16201/wCa4O/GVUxuse5gH+xWblqiRdJmw9plrzbAmczEaZ57hO+d+VopOz+ecHPYoTPjA9rbAQWejSSHboyibZylBbMEf+lzn2c3PJ6qEbaGmjeYt3ko3WpZAuY+yUFzqo+Dznbyem7YrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784112; c=relaxed/simple;
	bh=5yK/Tep/t06Zr0ybboQnX8Y/ShEo9umHKLsmVAzTaYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnWNCAAsMIhgv9V11rxmkRwnfn21s7rpzoqUYiAGd8Lh1NSfUZSo/EAtq5xynbtfUsnHraIUz79bXtM0bVk8qsfY8qu9yVouSvTOqx2UfVIG/bu6+tLfjPJsXsw9TEVbvikZDH2wEYQIu32Nb8T/G/uZPKBiEYll2NX0ukQEvLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAPRd85E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAPRd85E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC51F1F000FF;
	Wed, 30 Sep 2026 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784108;
	bh=N85lujXf2ztU8mEqzLpXcqx792s9AwTGo8pUCB1LJ38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAPRd85E/ZdX4TuIqpddJYpmyRZMNbd+rYmzzyKRxP8zYWtqdHYfV7UM1uHeCHIVf
	 lpkgQZ1oA7Af/NFL2w8V72OuhlGUC8XDBU5HmY8KybXDNmHN4Cxp/8Pe/lCCC8QW89
	 S6iyOsJKckNbeuxjjJO9JxbD2mkqZq7o80aOuO+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/982] media: video-i2c: use vb2_video_unregister_device on driver removal
Date: Wed, 30 Sep 2026 17:12:55 +0200
Message-ID: <20260930152417.638034203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit 56384b486b80ce4a2bc93689aae49995f908f90d ]

The driver uses vb2_fop_release() as its file release operation, so
vb2_video_unregister_device() should be used instead of
video_unregister_device() during driver removal.

This ensures that the vb2 queue is properly disconnected before the
video device is unregistered.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 685e4d5d174f4..83a4fc95252fa 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -911,7 +911,7 @@ static void video_i2c_remove(struct i2c_client *client)
 	if (data->chip->set_power)
 		data->chip->set_power(data, false);
 
-	video_unregister_device(&data->vdev);
+	vb2_video_unregister_device(&data->vdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



