Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D264C18859F;
	Fri, 15 Nov 2024 06:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653580; cv=none; b=lT6PUcT0t+6LKaWTKE+WVfob3XnOamlp5KW4buKkTZdGE5XaqwgxwybWlG0HO8atiebf4dgkN3vG3Lz6hQTnfL6f0546oy18C4rVJjNSC5EO/y2/CJ4NmSj0zz5y1Xld6kEUCJrFOjdkTxvvVEK0Tr7d0+vJOL2esug5+73Q6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653580; c=relaxed/simple;
	bh=6Rkt1LzLJB22ff5lqtZAuuVIRcbSCLWHhMZHWLGOoG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrAkYYbo0PRXP9DiGhijq6H2psjwzaQjkEDRf5YB1htZrkqq5nGS7bGhWzcOaMoYmg28DFf84xUUzpYXrN8q7HsLxl9QHayCszCzJi3wafDKAnKcIttDUfycWmDb02eJ20qJp1wIk6YNrcTNtzN1qnZNU7jJQsqV4FBmwhmEZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfhAU7SA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfhAU7SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467D2C4CECF;
	Fri, 15 Nov 2024 06:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653580;
	bh=6Rkt1LzLJB22ff5lqtZAuuVIRcbSCLWHhMZHWLGOoG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfhAU7SA6iYmeV2aRLJ3GP4+dEj1zYYvx0bAzoq/Os3t0nh911KeM6C6rh/BgUO29
	 w61AveZarWmiFxXZMF2DXgNM3hR9NUM8dX4Ng5dcTk17RBCXy7CxSYIeBRu3j7uV0z
	 rqU3C9MOBtzbkI0I5kFtbK9rxCBL+5leobO0mpus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Sionneau <ysionneau@kalrayinc.com>,
	Julian Vetter <jvetter@kalrayinc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/39] sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
Date: Fri, 15 Nov 2024 07:38:26 +0100
Message-ID: <20241115063723.195848308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

From: Julian Vetter <jvetter@kalrayinc.com>

[ Upstream commit ad6639f143a0b42d7fb110ad14f5949f7c218890 ]

When building for the UM arch and neither INDIRECT_IOMEM=y, nor
HAS_IOMEM=y is selected, it will fall back to the implementations from
asm-generic/io.h for IO memcpy. But these fall-back functions just do a
memcpy. So, instead of depending on UML, add dependency on 'HAS_IOMEM ||
INDIRECT_IOMEM'.

Reviewed-by: Yann Sionneau <ysionneau@kalrayinc.com>
Signed-off-by: Julian Vetter <jvetter@kalrayinc.com>
Link: https://patch.msgid.link/20241010124601.700528-1-jvetter@kalrayinc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index 1903c35d799e1..5848eedcc3c9f 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig SOUND
 	tristate "Sound card support"
-	depends on HAS_IOMEM || UML
+	depends on HAS_IOMEM || INDIRECT_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.
-- 
2.43.0



