Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AF01A6161;
	Tue, 30 Jul 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356699; cv=none; b=JxmL6bZZF8L9P348au3Q/b9vvYkx7DiDyAAdWF79TCvTDpyR2siotc0gyL3lYuQ9QdI3XsKI6v6Ap1EaRogNFp4rcR5g4ec+P9smCyt1iwIf7LnKRmOQkEcXEXZPvFOsiNGD8OltITyScdb7rEdvXWF/XGFynBjKTfXw4+g5ouk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356699; c=relaxed/simple;
	bh=joxswpzjjeTePJLwGE0RYxl/+erSyQHxTbaTf9pTHa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcHFqDGCCMYsbNqxgnXJzb0/iG6WDZs5oJ5jA0XUpEggL+BY4sLIsdqFTynuEkNxLLrYZKh+thfOwl7aIgRpJP2jc7SFh20XgmC9hgGPVjt7vq5JsRHESbXNaVBC1EYjMHLy/3QUGZHCMfFpuUog7AbQ8Tu3/Zh3RhmUA5fquaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1jscPZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1jscPZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6491EC4AF0A;
	Tue, 30 Jul 2024 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356698;
	bh=joxswpzjjeTePJLwGE0RYxl/+erSyQHxTbaTf9pTHa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1jscPZEObn3PWgdCzC6pd1xJ0bVsIlFELYC9ro+Xbz4yCXzhUNY3eBFOV1R+n7Ja
	 foWVC2oEH/9m8UXCtKDV6mfSCUUwBR4TCQQmgeSjVZwBkXaXsj1bNQkaHAycwRaiN6
	 gwOv7NpG8QXniHdDdfAtF5RG/TzOrKRpkdM/mrIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/440] macintosh/therm_windtunnel: fix module unload.
Date: Tue, 30 Jul 2024 17:47:33 +0200
Message-ID: <20240730151624.454580898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Nick Bowler <nbowler@draconx.ca>

[ Upstream commit fd748e177194ebcbbaf98df75152a30e08230cc6 ]

The of_device_unregister call in therm_windtunnel's module_exit procedure
does not fully reverse the effects of of_platform_device_create in the
module_init prodedure.  Once you unload this module, it is impossible
to load it ever again since only the first of_platform_device_create
call on the fan node succeeds.

This driver predates first git commit, and it turns out back then
of_platform_device_create worked differently than it does today.
So this is actually an old regression.

The appropriate function to undo of_platform_device_create now appears
to be of_platform_device_destroy, and switching to use this makes it
possible to unload and load the module as expected.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
Fixes: c6e126de43e7 ("of: Keep track of populated platform devices")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240711035428.16696-1-nbowler@draconx.ca
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/therm_windtunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index b8228ca404544..ab9b381c8ff11 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -548,7 +548,7 @@ g4fan_exit( void )
 	platform_driver_unregister( &therm_of_driver );
 
 	if( x.of_dev )
-		of_device_unregister( x.of_dev );
+		of_platform_device_destroy(&x.of_dev->dev, NULL);
 }
 
 module_init(g4fan_init);
-- 
2.43.0



