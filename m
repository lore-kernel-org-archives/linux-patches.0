Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAC4266F17;
	Tue,  8 Apr 2025 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113175; cv=none; b=es3Ga9V2GCmvXkhNiEAN8IGh8ofJyieWvkTrG0RpYCM4AevfIa7ywmzkcGdMp2VrkaS7TZPUjTAvAAqqILUBnuZ3EtjU3NJdETOudYEMF6f/14T+D54eWLgtQnQ1sxBOMWeCXhl0OXfeooEMmmEJqQU8qSLdgT3/Wim0tMjSA00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113175; c=relaxed/simple;
	bh=XOHk9FSFdUMZfWBkaPK5cRT7MZ0A4O+NIIZ25VYfPOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzJF8tSSOowBpfBDtpjs+eSbAFNsxzPpNj9Yw1jpAE16GRHgX+POpGvTZRVHdtoGiWHPuGdQQyiT65rtWWA003O4cCq6W+jRFMxPlgGBBzYIUOGWMlv7wlpplKXGnhg/l9aeGAuyXKWJ6d0nYjq+2+9dt5xQfPgYpEDRxnL1vDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVAJ6EWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVAJ6EWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDC7C4CEE5;
	Tue,  8 Apr 2025 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113175;
	bh=XOHk9FSFdUMZfWBkaPK5cRT7MZ0A4O+NIIZ25VYfPOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVAJ6EWkBeH8zY8fjjgMJJsCwu3sbSpOalLHm630iyl9N1WDAtoD1PHxnFf9grQ6/
	 XpC3U3JMNTZfCyH1a88kD/jB6J6oJ7bjaUbobk2IzS4m+pKsg+VHBXodWSCUDBns98
	 obkjljpGtfoNPEeQu2d8T+m0Ger/K+jtDZN69yGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/268] mdacon: rework dependency list
Date: Tue,  8 Apr 2025 12:47:51 +0200
Message-ID: <20250408104830.119996036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 30577b1d3de59..cdbcb86ff3944 100644
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



