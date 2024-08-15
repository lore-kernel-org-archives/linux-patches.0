Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CF544376;
	Thu, 15 Aug 2024 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729566; cv=none; b=ijXNWNbbPG3KDeHjfnVLkAjZGIiOaFnT+WFHgGOmQGcDYbyEzCjp7spPIFwqVqnuzsX5LCVyPvvxnk/zOl+8rwU5PapuKQ/Fuk5dnhSDdieAK9erLCwr4wp64KeqD3qugW5wzQj0DrfOusFsoqr0HTI9FoDZBzJjrc65V/xyjIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729566; c=relaxed/simple;
	bh=qYZnwUxG76+N3wW1/XxdO6eU3zWWkCcKrZNsVUD+rVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diGoPZ9ZEFaqcINk9GV1BCh3fIFXLtRBB6Mb776Zo3fzoSB5fWhQC7X5n6HNWrjB7DLYuI4mpB9Zo9unTIdGbLRA94OpVsrMIgBHAcfYcUN1NDSyewVWLY+4+/PcLZrjbbWVQw5dArA5WapFjgyez0XVGalrUrnp4Lbo4zxTiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrVHA12M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrVHA12M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B61AC32786;
	Thu, 15 Aug 2024 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729566;
	bh=qYZnwUxG76+N3wW1/XxdO6eU3zWWkCcKrZNsVUD+rVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrVHA12M2sKbmpe7V3lyRAUxztf2X2+4e3yJVlSTziuKTdBW9bEcswaMPJDfS3aSc
	 4+DMm96GOZC5XYLaBijigxXP27sN2Gh6vb0dqXl0w+KG5NGXsMFVp4gdZZ1/aZNQIv
	 +xUex9EQvu8OWKWtxBLWWwx3nvq6D9lh2UxCpeg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/484] macintosh/therm_windtunnel: fix module unload.
Date: Thu, 15 Aug 2024 15:19:57 +0200
Message-ID: <20240815131946.777074457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index f55f6adf5e5ff..49805eb4d145a 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -549,7 +549,7 @@ g4fan_exit( void )
 	platform_driver_unregister( &therm_of_driver );
 
 	if( x.of_dev )
-		of_device_unregister( x.of_dev );
+		of_platform_device_destroy(&x.of_dev->dev, NULL);
 }
 
 module_init(g4fan_init);
-- 
2.43.0



