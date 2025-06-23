Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6458A3FB1B;
	Mon, 23 Jun 2025 22:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716250; cv=none; b=TvpHS3ifuxOgPpti0zOm15z7JvdKkKfruxR/yX4tLDHln8nIeDTByXj7omRnAXMbcutQVoXsyeIIXjL1ogfYlZ22f2gdShzkm464wc3UVZdupCdayjSy0k0kAyzhA6tD97qXtVynrVoYwnZM8Mk2AjMVn1si9bD5+yDCGKBXkjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716250; c=relaxed/simple;
	bh=2I9R353c3y2b9muIzCSeZuBSXMPihe+FbHcLeWpGk64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB4UBF61IRKZmBSoVW4N9/5j3lLK6NcLsHKEKFXB0P7PKxoB9J3fsGa0ApG04fDJri0tR1mQS27fATErtXp7o7aGR0PgXZ7bS0pMCMtuzJPrxWu65n76GftBVcZJjQ1j40X4ENNzqH1neK7j9mVJficjxDvSK388Cwvn1khMgpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4LOnDnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4LOnDnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1D9C4CEEA;
	Mon, 23 Jun 2025 22:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716250;
	bh=2I9R353c3y2b9muIzCSeZuBSXMPihe+FbHcLeWpGk64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4LOnDnALuC2CNftNO3KmjreGYDWmdU7UAln8BgTlFec3Fsy05Qo/tZ+dmWU2W3iu
	 /Nhl4idXshoCqpERpSMioaNLRkI5qViEdQgmXLqP6/Xu+OJJ5DqTM0Lu3eABpgz6u6
	 TdI/FuM/ra0+mU/2j/dMav0vdX+lkxcXwFeHLdV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/290] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:32 +0200
Message-ID: <20250623130634.476337223@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
index ee365b7402f19..43d69669465af 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -751,6 +751,7 @@ config GENERIC_LIB_DEVMEM_IS_ALLOWED
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
 
 config ASN1_ENCODER
-- 
2.39.5



