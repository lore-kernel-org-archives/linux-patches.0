Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1019E7F7;
	Tue, 16 Jul 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145505; cv=none; b=jNNxm/pEiawOKVqtT1BcMiK2rYubn/sPRqV94pbcb+YE7AknmzjREcexse4uOqi1jhy813MTDn/XGW6tyDqkNLSLLRieaRwRn00CT6OL9eCJ5b7ILiyeaIi/7Jpi7oZhmXPytKqWCty5z/w00eDfXhnHGVjfbaOTfg78UwdgfFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145505; c=relaxed/simple;
	bh=6nw21849+HOvAQSpCeJ3wILEFJjYqY7FNPLGxtejA24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR7DYjbB4Ls8oq+zQyVe1AAydPi6xMFtKLiULuOF/B/VsGpidJNp9QRHaAEkP99EoIz8aNRoVDIgagTE53n2IBQ2lWqqdjJssHvxhyuLMNFZVdjngYPoHrFWQwbnoQdTTZ4lGYaFFIiQ6lAHKmF+D3Ob7ZqYEcZmPmZyfAB+xI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+VMN6o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+VMN6o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EFBC116B1;
	Tue, 16 Jul 2024 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145505;
	bh=6nw21849+HOvAQSpCeJ3wILEFJjYqY7FNPLGxtejA24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+VMN6o9EqPz03vgbgr2rQ4irCpQj9maP5ZMb9P98kp98BeRgfl2j/fCUZyYiCZus
	 ZBhXm7I94V6ynfLmNXswnTD/mkAFAhCdvkUmvWNNwiQQhmh2HkDW0Yl80INrCmeirE
	 Nin269GgAQX+A2P22zg3cG6R6nOHmh6niPvSaScs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 87/96] i2c: mark HostNotify target address as used
Date: Tue, 16 Jul 2024 17:32:38 +0200
Message-ID: <20240716152749.859834743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit bd9f5348089b65612e5ca976e2ae22f005340331 ]

I2C core handles the local target for receiving HostNotify alerts. There
is no separate driver bound to that address. That means userspace can
access it if desired, leading to further complications if controllers
are not capable of reading their own local target. Bind the local target
to the dummy driver so it will be marked as "handled by the kernel" if
the HostNotify feature is used. That protects aginst userspace access
and prevents other drivers binding to it.

Fixes: 2a71593da34d ("i2c: smbus: add core function handling SMBus host-notify")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 8af82f42af30b..d6a879f1542c5 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1049,6 +1049,7 @@ EXPORT_SYMBOL(i2c_find_device_by_fwnode);
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
+	{ "smbus_host_notify", 0 },
 	{ },
 };
 
-- 
2.43.0



