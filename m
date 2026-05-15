Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78984D8D90;
	Fri, 15 May 2026 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862599; cv=none; b=j/EJC/2P/JVz1++RWgsBaqTWgDaGwzWGMzC8Q4ZTGQ0CHnHPLt5SZus6BQ/tuC6TOWZkIozH309YF9h5DmsoqQz4jfHmacJtMYkpJuatDNeRev8STOG0q16v9YM4xua133T/56aBBUp5CklDEBCeMQoqm97tHVORLfrFik3Bdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862599; c=relaxed/simple;
	bh=l1KZzMYwWqntO0ORIl+JhelS98ROvdd65klwtytM2rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMp8psRWP3+iyL1CroLNBOBh0yfd7RzdXdsu+VztUVm6xrmi0WIfIh5z3kU77ZJKOZd22gORY73kxapCJUcWxcC2MyumjaHUMt0tYPf2EfgqzIjMFsolIhWgBN9U7jNVgYT8odCIJjQUFygGcAmWx1G/QR9BcrLKIDXDlG5KhZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWukuSTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWukuSTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52778C2BCB0;
	Fri, 15 May 2026 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862598;
	bh=l1KZzMYwWqntO0ORIl+JhelS98ROvdd65klwtytM2rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWukuSTXCBobw4gqBbFO0fz2KvJ7bWQP+4FmXzbB9P4pI8JQhkugGn+ffb0o2xFBS
	 7EACjAUQBcUu/71v/ma0LVQBbtOEWY3tAvp/lZHJ4sPpsJGRyPpK7fPBxD6r/vfoI8
	 7sxULuU2qboHvabOWEe5n2X3O8cvDX86Fox5pKBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 110/201] spi: orion: fix controller deregistration
Date: Fri, 15 May 2026 17:48:48 +0200
Message-ID: <20260515154700.934702242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 220f4f11104a7f83b71543ef0e48dde1da2bc5d3 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 60cadec9da7b ("spi: new orion_spi driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -801,10 +801,15 @@ static void orion_spi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct orion_spi *spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_get_sync(&pdev->dev);
 	clk_disable_unprepare(spi->axi_clk);
 
-	spi_unregister_controller(host);
+	spi_controller_put(host);
+
 	pm_runtime_disable(&pdev->dev);
 }
 


