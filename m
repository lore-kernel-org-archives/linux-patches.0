Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4F3226D04;
	Mon, 23 Jun 2025 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716842; cv=none; b=PlpeIyzITvhDLb3ftUhtwnK2sroTY6qlIFcbREzLnD8SHf9932hmzsYFgI+jSEFU+Nwgh4DAnbSTE4uVhYVKfxliza3FNi4QphXJ/yYhD096K0Wyrnl+eweDq0T5+bxiKhdu7Spyq5d0jDCQzEY/+bbFmKqhVjHtzSoIBGDFA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716842; c=relaxed/simple;
	bh=eTu5cT0CBhKcggywb2OrWWihVwQ3uzmzzCN5qs0OnlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdTaYJqJJ453XfPWJFYvF2lDWt2LEM3AcSlQaGsDbnPL98ILtV00iy00mkNP0n6KXwZWXs+yE5GmN4KrcOanhENmvS3R93GkO9voSp9uAsx1G3vp8IiOBaTLDpcTjkWE/aue7QsUp6jhviCPuYv5ADo8fJ9f+sl1nbQW3Fka6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3aNK/R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3aNK/R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C94C4CEF1;
	Mon, 23 Jun 2025 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716842;
	bh=eTu5cT0CBhKcggywb2OrWWihVwQ3uzmzzCN5qs0OnlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3aNK/R3UxTU9OW14T5LUoRJ7szgL1aNdRntLA8wpsS6lH3CIGrJLW14GfiS1sXCN
	 bPnfuUgOQCcj/YAAZaLc7x6U3rl75FVxxZrAoMGHKTPA1lUL0XBaIj65LK1Lly8QFT
	 N3dnKbDyITnZf6uJCLRDl4OEPqt3Aj7tMaM/qxDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 371/411] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:35 +0200
Message-ID: <20250623130642.981357387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit 1224b218a4b9203656ecc932152f4c81a97b4fcc ]

pldmfw calls crc32 code and depends on it being enabled, else
there is a link error as follows. So PLDMFW should select CRC32.

  lib/pldmfw/pldmfw.o: In function `pldmfw_flash_image':
  pldmfw.c:(.text+0x70f): undefined reference to `crc32_le_base'

This problem was introduced by commit b8265621f488 ("Add pldmfw library
for PLDM firmware update").

It manifests as of commit d69ea414c9b4 ("ice: implement device flash
update via devlink").

And is more likely to occur as of commit 9ad19171b6d6 ("lib/crc: remove
unnecessary prompt for CONFIG_CRC32 and drop 'default y'").

Found by chance while exercising builds based on tinyconfig.

Fixes: b8265621f488 ("Add pldmfw library for PLDM firmware update")
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250613-pldmfw-crc32-v1-1-f3fad109eee6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index baa977e003b76..66e1505e238e5 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -721,6 +721,7 @@ config GENERIC_LIB_DEVMEM_IS_ALLOWED
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
 
 config ASN1_ENCODER
-- 
2.39.5



