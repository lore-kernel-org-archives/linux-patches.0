Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CE8267F6E;
	Tue,  8 Apr 2025 11:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112716; cv=none; b=J4TKq3vnsdsQLnvO+kpoTpkfULBhcGuzDQk34Qq28HXh6Ov9op99yBCLf+k01g7xI8z3+QmS1ooW86Qv8RHzvvv1fl7SQGNOCpOVIhQ6XExG6XP4c6x+n6Cj1pscS2g/PNI4XLU+i+NwNz/HfQ5/Roho9lkVmm+v2jEC+zliRfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112716; c=relaxed/simple;
	bh=0c94LUTM+W6kQ4JXZcXJVFFx5KEdaIz3z8lYqS0HUeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsrAy3Rav52a8FXVLI1tbm27Ko7I8TuduxZf45/nzvdP1ml9qSgnWHg2RJtR3KuOGFRA0JAZEQxNDU3LmlgijlbLcDeQwUR7lG++Tv3j4s+lfG940RRCF+aU+kaDiOY80jddQe78QYK21/EnQl6mq08FxGs/GMIV6vdlkFAXk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqrjn6lV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqrjn6lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D3AC4CEE5;
	Tue,  8 Apr 2025 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112716;
	bh=0c94LUTM+W6kQ4JXZcXJVFFx5KEdaIz3z8lYqS0HUeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqrjn6lVfKmtHqne6Vf6vsiD6LAHbYMcu6ZlGuuxe62/PxZHwgEqP7DoTsajax6oP
	 l+fL5holW+YqStfOFvZtU+kYtQwsuWe2JFBvl2SnbfmWJyIyaSmQ1di6dFgAnu3Ne4
	 0GKjshLd0At6iUjPQSqnIan3TaXgUs/+LTh/Pc3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/279] mdacon: rework dependency list
Date: Tue,  8 Apr 2025 12:49:07 +0200
Message-ID: <20250408104830.760950737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fcc46380e7c91..390280ce7ea3e 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -23,7 +23,7 @@ config VGA_CONSOLE
 	  Say Y.
 
 config MDA_CONSOLE
-	depends on !M68K && !PARISC && ISA
+	depends on VGA_CONSOLE && ISA
 	tristate "MDA text console (dual-headed)"
 	help
 	  Say Y here if you have an old MDA or monochrome Hercules graphics
-- 
2.39.5



