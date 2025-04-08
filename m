Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98632676FA;
	Tue,  8 Apr 2025 12:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114471; cv=none; b=hqAS0hoFw47mOmNFnihJDnzS1X2ruelZstGV4bMkWKFery0lC4xrXMZ8pnPjdeGvAyNr2lX5TISJGMRy6o71OiwynOqCrh78bAf9LK11xlAte8p43RUzl5l7+cO3QhezqkBkzi/fyUUs/JaIjcaPkwbh1S6nt/JqKm7rs7zlarA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114471; c=relaxed/simple;
	bh=Ep7CylI2hlxJLMXRloO0qbdXeZhz0GX4LK70e3Vaqxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmBF6k0EPmJOlvY3hwoDhzcUnb/5VqJCPcgrT1zEoOmON/Snae92YIyNdnD0RW9e09tFk4jctDnEKvbbaXm6ywELMdHGf+3ZglCs4xQiS7nyiEDaf9NPOqtlS5gj/N6uKlkuezA3kHIrfh8FMDZrdxF239oWZI0LleXm0mopDt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uoc2kHmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uoc2kHmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596C1C4CEE5;
	Tue,  8 Apr 2025 12:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114471;
	bh=Ep7CylI2hlxJLMXRloO0qbdXeZhz0GX4LK70e3Vaqxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uoc2kHmObu3wOE64gogTG596kV8f5mgZiOwDV9EpuBcHU6jUxD2pOUL7+rrR+GfVw
	 ew6C+tyOjbrRPgo7MF7aKorsJq9d+uNsxdbjltglktyVUguS6go0i0ZMP6wh0q4CLj
	 Eae7G/hZh51CrsuM2ayfAWoupb0qH0Y1/XLx8vLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 118/499] mdacon: rework dependency list
Date: Tue,  8 Apr 2025 12:45:30 +0200
Message-ID: <20250408104854.143784055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



