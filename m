Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F5B1A3A80;
	Tue, 20 May 2025 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750869; cv=none; b=Tw3/2dTNiEGUoc4uIzV0yJnossCBGkYXqWTruCPgjUgNa6t83zZLchSM56No7MqHDFvvXExe9M6U8Tw8nje1/5Vb7FMMmBZWfuMG1uTpWB5jLt88oyX19l9z+IR8eEUY/tVHail8hMospWiJnK15pEOSbeqrX5wLKxoAa3T69WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750869; c=relaxed/simple;
	bh=bEgIgVHvCvZUOT4i8an3DednSG0HDWw2KxtlTrD+nYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsIfSerfW370LbZsIPBMhn9uQiSS+WYRsOdHKnfyvk2lnE9Bj3R+IN3DLONR8LIb6RmrNPmHmKjLQp/aoEK3N6aJx1Hz25b9FnnqLmJVYJr45wtUqpOYcPuQSvlUnwaQC4Gp+G8ZishyZncW/1kb7FkYvESw+GiC3iGfj7JMMI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s98VnyLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s98VnyLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D689C4CEE9;
	Tue, 20 May 2025 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750868;
	bh=bEgIgVHvCvZUOT4i8an3DednSG0HDWw2KxtlTrD+nYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s98VnyLYAUEzKx1uKY7E1IbcshgS0WRcWAHuPzm9BfCw3hhkU9FLyaZw0Jph2BE4z
	 Y+dpIeqdriDcibHoRDtjSOx2hhR0JIT3+fSO6wILti4VpCTqoNHsX+6CzBUI+8xs9w
	 2BfYL+XbZYmtzjKgcAlGKn8QRjwY/fRbGu01JXWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 108/145] phy: Fix error handling in tegra_xusb_port_init
Date: Tue, 20 May 2025 15:51:18 +0200
Message-ID: <20250520125814.786662233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit b2ea5f49580c0762d17d80d8083cb89bc3acf74f upstream.

If device_add() fails, do not use device_unregister() for error
handling. device_unregister() consists two functions: device_del() and
put_device(). device_unregister() should only be called after
device_add() succeeded because device_del() undoes what device_add()
does if successful. Change device_unregister() to put_device() call
before returning from the function.

As comment of device_add() says, 'if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 53d2a715c240 ("phy: Add Tegra XUSB pad controller support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250303072739.3874987-1-make24@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -548,16 +548,16 @@ static int tegra_xusb_port_init(struct t
 
 	err = dev_set_name(&port->dev, "%s-%u", name, index);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	err = device_add(&port->dev);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	return 0;
 
-unregister:
-	device_unregister(&port->dev);
+put_device:
+	put_device(&port->dev);
 	return err;
 }
 


