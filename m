Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D3418B46F;
	Tue, 30 Jul 2024 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357858; cv=none; b=SOhqbJo6Ierzs9qk+u0gQ3lWSP0JDfIWyrl/dvRjhVeqAbqstqzjbqXDdlv8D/FIPDc0CDD/KoP8k26p0T9xkRuE15WeH7HSe/33ptQhOi/EbD5AHATNLzdICoqGjHq2qi5VkNxZclao/w3gA8LRrW2J+2xjvnWoNu8MDajf5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357858; c=relaxed/simple;
	bh=Xdj7Wr9GS/FqvlczJ1YQsXDMguHIUrcXH6TpSKBePNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0LVZW5irlEuO6mhzAUUeYYuMjCJPxfhhODLOKNUE1o1gZsn/qaTpX4/jTE98Mw7R80zuGk2zwundehkRT1qZyygr5EJWWCsmaaGgI/jFYPFf2r5jwrxC3e87Qt+B2J5dal/NRNOgp+iiIG8RGz75BuliE+0HYMIaJA5QRYZ/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NFtP7rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NFtP7rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F63C4AF0F;
	Tue, 30 Jul 2024 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357858;
	bh=Xdj7Wr9GS/FqvlczJ1YQsXDMguHIUrcXH6TpSKBePNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NFtP7rEra+pG7C+uAjPx7nCDedbjjQypdCBneVIsN/Fs2Pp9BeE/UcbNJT4s7mtA
	 U+rK6HtigLE7rkNcoITZ4Sd4jFhHvSD5FID5j8NVWb/otgTUH2OwXOVm+7C8hYGcoO
	 71/Q6j6kSq4o3F+w0yGdIPnSR9z4uBSP6fO2Dmu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 298/568] macintosh/therm_windtunnel: fix module unload.
Date: Tue, 30 Jul 2024 17:46:45 +0200
Message-ID: <20240730151651.524258538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c1b29476ce24..5c001105cdd9e 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -551,7 +551,7 @@ g4fan_exit( void )
 	platform_driver_unregister( &therm_of_driver );
 
 	if( x.of_dev )
-		of_device_unregister( x.of_dev );
+		of_platform_device_destroy(&x.of_dev->dev, NULL);
 }
 
 module_init(g4fan_init);
-- 
2.43.0



