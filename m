Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64701E0DBD;
	Wed,  6 Nov 2024 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898680; cv=none; b=egSvNpSmuFN34VboljXMj7oyPcz/ihcq4VtT78h2Ir8Iou6A4APlJyDhJVUeHcrBnPl9+g8gJwcc96jW6bJvJfJgOt9Vr27P4fyaxdnM0kr+wkLpXf5QCSnlDyPxNE4Nh/iq/LHZk5BfYCMnnVr17aOT7EkhGgBDaiNJnZQmITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898680; c=relaxed/simple;
	bh=HMFD8VaFof4zlIAGcfZKSP8XELcgT/v389e93th3Xw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiPGkrI/6qohl0qRpaLcncwS3LMZ4zsc0ggHCMzmN1UIB1PvzenwOmr/N5eyX1kVKfF2BVxjcdRzXhU0L09ra3XL1Iua/a8EKkjCeWJZSipKKWhY6K2tllxtu9E8+zp9+nmY6baVSAS60hypCjp7xXh+fvNOWd8Guwqs8SN+P1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXlCLo+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXlCLo+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FECDC4CECD;
	Wed,  6 Nov 2024 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898680;
	bh=HMFD8VaFof4zlIAGcfZKSP8XELcgT/v389e93th3Xw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXlCLo+UCoY9dILL+Ehh8F4imXjQ4zj4omJa3LwKWOHLXq5e+EXZrpDST8W7ZHDGW
	 cSvzsEtuZO66LChRV2KJRFQEOOzTg3l8jW/RXBPYNg727eRJ6uIx05n9sK4QnPZE2N
	 h7WF2vpoHjlvhTm+AFgU8FEP9ueumX/Klc55iJ84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 320/462] fbdev: sisfb: Fix strbuf array overflow
Date: Wed,  6 Nov 2024 13:03:33 +0100
Message-ID: <20241106120339.429492706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index 2fdd02e51f5fc..db745dc3cebe2 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -183,7 +183,7 @@ static void sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
-	char strbuf[16], strbuf1[20];
+	char strbuf[24], strbuf1[20];
 	char *nameptr = name;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
-- 
2.43.0



