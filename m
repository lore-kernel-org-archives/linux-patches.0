Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AC72690EC;
	Tue,  8 Apr 2025 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116421; cv=none; b=VSwmlF4RlmjsLVqQ/bhdh6SC6AaQVVnrinSwVKR7wBJiKHWtvF7jpzqflMHMKWQSO+0IM419J6qSfgz29Xn7xVh8uaZfTIMfIVnPP7PVp7w13kU7s2wTEkNCZLl5hHChOJjJuTDCFSUWhjj0aJClnGXAywLbfGsf75ykuMHfdjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116421; c=relaxed/simple;
	bh=09z+wJFS/TJWp72xzVxq/2i6TRg3AcXmkoKZ124fbpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYQRKvM1t0sMSyoPuQ0MZsanTMc28418VYs0o37numqcXFmvasUigKui26d0SoZgjRktfUODxPiah0oCPyTi8X5/m2jwj4rb2bYTB6SF3t246yjghCF0iu+VR/iV/EU6Ko+h1wTuiCyLjKg8mHRX+U+xWrJZT8LAJQGx4tlJNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THSqaTX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THSqaTX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3219C4CEE5;
	Tue,  8 Apr 2025 12:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116421;
	bh=09z+wJFS/TJWp72xzVxq/2i6TRg3AcXmkoKZ124fbpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THSqaTX7Hc2L/QGCX+ZUqSI7KAhLE/EP1XtLWrqNcYSnRcW1mMXXIcrxzZM6xWhRM
	 WfqQW8PZiQhueJixXKnD4o2ac3WBggwz4olxc7iDq2Lzgl6jYHtZtyTLQC4EhHihO1
	 mlXZfQ8WDSu3D+GLZtpIucRKmfjmin+qf3XyPHfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/423] mdacon: rework dependency list
Date: Tue,  8 Apr 2025 12:47:01 +0200
Message-ID: <20250408104847.952529679@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c4a8f74df2493..3e9f2bda67027 100644
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



