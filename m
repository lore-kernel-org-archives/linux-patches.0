Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA3518C909;
	Tue, 30 Jul 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359267; cv=none; b=a9ZWY04Pukr/TdhAiL1aI/2G1VTcz8fjae1CXufZxY9fKKG/gtY/G5w0FRITsc3GqOrGmhP1F6xhybce637Pf2ruohH398/xOsDGlVVu9xv3w0iTjVcbvyAKefns9IpAMDaYRzO298TIo3q5wwE/L95XwDDOxYq8YQJ9rSdFN3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359267; c=relaxed/simple;
	bh=CX6txlQYiDeM8G+MJlMIvV23Jpa9zeq4BYqnxL3QU0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdRmHMlWbJVtr/1O7mLBSCBCUb5dlLMrO95oqZy2858aRXBC96Eb8t5plGDF6F8l/ZDTI3vDoXFt7AVh9CRl82P9Dg1UMOrZaeuWSAvd3zRgU74eDc4hl/80MF9YC5oMBAbg7QDdtajLff/KAEcB9oOoBaOrH8j/I+j8bllcQDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cID5nqga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cID5nqga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57567C32782;
	Tue, 30 Jul 2024 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359266;
	bh=CX6txlQYiDeM8G+MJlMIvV23Jpa9zeq4BYqnxL3QU0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cID5nqgaDcPVAm2OKMytPLJLIPKYbZhiU2YWzxX39uojb9w3jumEm/hQfabTCTfZq
	 5WbDuPu5CVfrk0477YwE9TiACayaVX6yP+g79XN+b30Mf5rivwcIc8wPKeF33q+jnP
	 logEdgnQq+91FFxF1KGwCn8i4l5boixj25PVPvcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 459/809] macintosh/therm_windtunnel: fix module unload.
Date: Tue, 30 Jul 2024 17:45:35 +0200
Message-ID: <20240730151742.856545157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 37cdc6931f6d0..2576a53f247ea 100644
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



