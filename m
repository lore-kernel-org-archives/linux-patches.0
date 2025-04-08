Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727ED26E158;
	Tue,  8 Apr 2025 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115643; cv=none; b=ZjX6HcU5FgNcK5Ykfb104PQ9VMEf5ZxBzNF8Qmudj71HUPpB/WUMcpMqL48fQWkdPooi32S/DTYZlUySFhBiMV6sPkvYRr6Yw/tJ414gVl9w7Hdp5i4y+Z0WBnnGhNEDP7cU9G7/+5tPwlzHVwj6XN99kmQNLgCDrX/T4gAvWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115643; c=relaxed/simple;
	bh=CUE2osu8L+nfcfptL7L8qKuFA2sCGu7iq7ZXPnEm9BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf/CXpIrVVAZXGASh4kz8UXpFrylku4237kzIOnc5jYGpqTP3MB+6tBVPJOkhRiMvnZBwVmi+el2aX9zrcRUwHZ7uEBnWg8Z+FH04eZt5ozeN6AvwqjmV5gZqTyttb+WBBGDTVUjrHN1QsBbFJ1D7TdZ2EAfiYA2QL0cmUwMykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFW7LiEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFW7LiEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0112AC4CEE5;
	Tue,  8 Apr 2025 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115643;
	bh=CUE2osu8L+nfcfptL7L8qKuFA2sCGu7iq7ZXPnEm9BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFW7LiEWwV/rFUQETCGb2eNd51/BQXJGMPqBlS0D+rvEy1BDrK8VLKwhW5Dr3mlsz
	 dyfo0zFSgK3DWFoF6gxF0HNzGMW14VCvTSZ3MV1PIgUkADAMKmH3H9jwDxciQD+zim
	 2UFpudEBsHllv5gVvLOZ4o+OblhF7zwB5iyZ89Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/204] mdacon: rework dependency list
Date: Tue,  8 Apr 2025 12:49:40 +0200
Message-ID: <20250408104821.812425719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5bbcc7645f4b244ffb5ac6563fbe9d3d42194447 ]

mdacon has roughly the same dependencies as vgacon but expresses them
as a negative list instead of a positive list, with the only practical
difference being PowerPC/CHRP, which uses vga16fb instead of vgacon.

The CONFIG_MDA_CONSOLE description advises to only turn it on when vgacon
is also used because MDA/Hercules-only systems should be using vgacon
instead, so just change the list to enforce that directly for simplicity.

The probing was broken from 2002 to 2008, this improves on the fix
that was added then: If vgacon is a loadable module, then mdacon
cannot be built-in now, and the list of systems that support vgacon
is carried over.

Fixes: 0b9cf3aa6b1e ("mdacon messing up default vc's - set default to vc13-16 again")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 22cea5082ac46..5c4df3aaab1ed 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -24,7 +24,7 @@ config VGA_CONSOLE
 	  Say Y.
 
 config MDA_CONSOLE
-	depends on !M68K && !PARISC && ISA
+	depends on VGA_CONSOLE && ISA
 	tristate "MDA text console (dual-headed)"
 	help
 	  Say Y here if you have an old MDA or monochrome Hercules graphics
-- 
2.39.5



