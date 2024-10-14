Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAE21AA797;
	Mon, 14 Oct 2024 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916961; cv=none; b=nRHXshtIms6yD5+CDJ9xi2VfDweC3o7MFIOta5HVx/+4nu/vDVJPRNmPIQ5U2PUknw87J/UIxIyLprINiMlxy1Cjy/C1rJN8dl7GkSoXWCoQ0LDYWIFSI9Px9fCWFvI9VrYHg0JtcNzdfc4Ih4vz51HNfP0PuvMKB8gB88rLreU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916961; c=relaxed/simple;
	bh=U2TrT2gshNciwfqaQsWwI1JVpry6AOEoD66tskmdEMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWR8X0KNWBBiakxQa8qkUzvq8JKvNj2ChQwAoiar7WhccgdkBbHjWMUTPeFfZ3PAs/RDV5iOfVHMYZxsXMwYbWXV5uf7S7ae56IxVH5ul0iakbP+0iyRifjtbWI5ow8WME7D0fyJ+3mumYZwoFOWkuseb6uS6Tl5/3Wxt2HZLEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blAEozzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blAEozzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE54C4CEC3;
	Mon, 14 Oct 2024 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916961;
	bh=U2TrT2gshNciwfqaQsWwI1JVpry6AOEoD66tskmdEMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blAEozzA98wGRI0ZD7xeWzXtJiqAPfNujwtUzMXk3X9QcV5gBmwEY7NBfYeb8DjG2
	 NGe2V9htJFXmeXYJvJFpiHK2uSKmeUli0ULAukzR+fiM+tViX8Gl+U8XfnpAuR89+w
	 37I8k4EFC9Zr5iINKPBbsa1I6sUCbMaaqqT2OVA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/213] fbdev: sisfb: Fix strbuf array overflow
Date: Mon, 14 Oct 2024 16:20:12 +0200
Message-ID: <20241014141047.105649114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Andrey Shumilin <shum.sdl@nppct.ru>

[ Upstream commit 9cf14f5a2746c19455ce9cb44341b5527b5e19c3 ]

The values of the variables xres and yres are placed in strbuf.
These variables are obtained from strbuf1.
The strbuf1 array contains digit characters
and a space if the array contains non-digit characters.
Then, when executing sprintf(strbuf, "%ux%ux8", xres, yres);
more than 16 bytes will be written to strbuf.
It is suggested to increase the size of the strbuf array to 24.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Shumilin <shum.sdl@nppct.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/sis_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 6d524a65af181..ad39571f91349 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -184,7 +184,7 @@ static void sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
-	char strbuf[16], strbuf1[20];
+	char strbuf[24], strbuf1[20];
 	char *nameptr = name;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
-- 
2.43.0



