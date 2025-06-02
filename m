Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DFF233155;
	Mon,  2 Jun 2025 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874612; cv=none; b=Ps0CkEMzNjJ1KGShkZ13jcu3o6ci8h0D99biseB1W/pFwOh6briNMB9Rbdu82waMNqKfWxfIzfRhy5BiT1n1IF0Er4tJ5DHBi1hfrpDMm7MRKIDQtytdjNCimjdL2lzhsGS3/XiCRlzSWAUbxRMnvkoUqjkI12nRshrEdIAhw4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874612; c=relaxed/simple;
	bh=J8DEBbmqgVqHx9zekQbbW8vM7wCFBNCGjVwQ5NtjHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlsnkX3heLLu3NHjpJd0RpuSJWCXUTIQn5bLM+dOGxOacJmf2XJXb8Dctc1vFQSytpYRPCkVdMo/mqdAkxuKIifJKTziz4fDA8X7KV3qEJrW+/16h4IL6KvziZ+ZC/30ne3rdGorre4OJ8s0XUSuQXyBG2wURnwIxZMbQmmYKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrIVXqSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrIVXqSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C825EC4CEEB;
	Mon,  2 Jun 2025 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874612;
	bh=J8DEBbmqgVqHx9zekQbbW8vM7wCFBNCGjVwQ5NtjHQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrIVXqSx4DT6jQfOqUgDYc3XCnYQPocqvWr/DiD68UBiX8+03o+jI7N9lsr+qetP0
	 10HHH64SPovUl+vPVMRLURVQvERH2M8CToP5WZZzk1RCCVYsBzgdtS3j/h4RQVfQIB
	 5PByWXmYX7dMyd7bWTzvMbIgXvViTxI/Oj9Ki/q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 080/204] phy: Fix error handling in tegra_xusb_port_init
Date: Mon,  2 Jun 2025 15:46:53 +0200
Message-ID: <20250602134258.817230721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,16 +526,16 @@ static int tegra_xusb_port_init(struct t
 
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
 


