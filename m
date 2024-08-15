Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4D1AB50A;
	Thu, 15 Aug 2024 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731274; cv=none; b=C3Vvy9IAyIqgTDVTOaSV2fYfDj9Gt7xSuLT2f9JVWHo5e2c6lVdd35B/ZGcEftZ3lyD1M48CwWek6ldrV+LIqYTtjzGHFKk48nsXj4ZdHPo/Jjut51DiKLoU5zFy9TtYMWBpAKSoTZim/CbKC4WE9/zFiWCzJxAig+izNr4bR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731274; c=relaxed/simple;
	bh=1Q8p1qYxWhh5l3zAcGN5fe3l0AN8rWv10QaT9TkS5V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8l4BTAuWgfs0JzVSDEVRmfRMcceeVxdXeJaL0lD23wvzmy+fkkR6hu3F6PHgIvEDxt/gwq+WmcTzNlTYyfd/IPoutYzmJRi+GE4eAxlYpH60hbfDvcaj0jPd0QMMNxQqmRkIqONmIbY1CF0ef9vQpy2XNulTDnqQmKLKhoCQVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hhdxwi2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hhdxwi2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A71AC32786;
	Thu, 15 Aug 2024 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731274;
	bh=1Q8p1qYxWhh5l3zAcGN5fe3l0AN8rWv10QaT9TkS5V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hhdxwi2ygjUAyA2NGB7vbsKnYESw0h3Un9CCi9ajyVhWZr/FxXuTDFs0UC2n2a2Ye
	 rvt522PoC6/xzLY3Pr7XqPOqdRc/4M8W7UmjNEdoyF+j2FNjhapcCXOiSmcPgdFvcx
	 sWXn/AIILofRXfuQW37LrJIEFRd9eNj96g4TIrwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/259] macintosh/therm_windtunnel: fix module unload.
Date: Thu, 15 Aug 2024 15:23:31 +0200
Message-ID: <20240815131905.815057571@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a0d87ed9da696..63e99762a1656 100644
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



