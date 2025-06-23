Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1DA223DCC;
	Mon, 23 Jun 2025 22:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717314; cv=none; b=oOO1O7NS0IdIxuHNJawpCnQ2KBDbbh0+EkqUGBSIDT2MtmLnDOVQMRlgmPmYQA6cyrBxZrFu3DtypI31U2u0HuhAq28TJgy+5YvJc2OVkHg5Vmg5XO4sFV/VkjaOJlLt3rC7aztY+NVZmok+SCCfss9kRGyHXjEH+KullIj+mAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717314; c=relaxed/simple;
	bh=VC50sow1A/Dk5d/H/YmvhLyVoEnodfFMeVF9SaIwdOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYlQRnCYO8/20UPZb9nJzJj+B1B+W5fhF2dLUEbnhZEypxGkQ2ckRzJTVylH8yN020qP3XMkOv9qcOqE+HzWWHi67VQfr1gs59gZzg3d2jXt88KlAdeTG9A60Iq6y1FcPcAcwtYiH7kZ9FysvsLzhD5kCSQAk8l0wS+vq2ySzlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t44AnT1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t44AnT1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41E7C4CEEA;
	Mon, 23 Jun 2025 22:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717314;
	bh=VC50sow1A/Dk5d/H/YmvhLyVoEnodfFMeVF9SaIwdOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t44AnT1PZWpR7/gHLYZ0W2yKwfUwpkDH75HnL7eo8aIEdtM9bisy34kwicR55vgoM
	 xBm9SQXTaXlUFn/l1MP1aqLtVIP1LpPUb6d0bmPMFM0WuGhHuzKrkqIKu66xHDG/Z0
	 48ptqqucMCLYNETLW7SN77v5NiCfA+XtLtAxy7A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/414] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:21 +0200
Message-ID: <20250623130651.065125980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index b38849af6f130..b893c9288c140 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -767,6 +767,7 @@ config GENERIC_LIB_DEVMEM_IS_ALLOWED
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
 
 config ASN1_ENCODER
-- 
2.39.5



