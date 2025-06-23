Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A683A2222B2;
	Mon, 23 Jun 2025 22:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717636; cv=none; b=f0ZEyaG57JHU4zhVJBlrYAtMkBJBOB2anGOPM89r7IQNsu5rmVhFmUZQfgopkXyqYHaD88uzHvXBtoccZZZy0Ln4HVrmVSId0bv1vdCdOGaGrX+VZMNfROC0W8FF+b5X2sScsyQEnIIFEwhBB50/kIec+DA4372PZcjEGjbLRmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717636; c=relaxed/simple;
	bh=wowtVx74Pc8+xhTjDlOxzIiua8uWoYhKn8H+9lASWX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrkdqwQoRpH4pzXCP/f9EoxLe/76xXUKUO8XOb4kaqQaFbWjvgvWM7AqS7jiOdaQiPPQbhJbzoI6xIUR90A8XGTp03EiMsn6KIfLNq3M8tIDZLtVF1iEW6GWzKCWmDpVev731bzDAuGQo8xUr5UGvR+qmAShkUDLfDAO9YqLvnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGaNc957; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGaNc957"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350A9C4CEF2;
	Mon, 23 Jun 2025 22:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717636;
	bh=wowtVx74Pc8+xhTjDlOxzIiua8uWoYhKn8H+9lASWX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGaNc9571096LOOXYY5ys7U8De7//fP/NOeRL+moNCk8FZtRHraABX6QJB4W9cxIe
	 x7Wdn72lm6Vztyx0KuQIZ/V23H4odtFqbxvPvrH+iIBrXdwCC+jM/SZoIIsQJ5/C/v
	 Q+nZUpNRoSMybFX+pDAU9HAo+0WDcBU91AqhvWUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 476/508] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:41 +0200
Message-ID: <20250623130656.792802910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index 9bbf8a4b2108e..0610fad65a366 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -744,6 +744,7 @@ config GENERIC_LIB_DEVMEM_IS_ALLOWED
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
 
 config ASN1_ENCODER
-- 
2.39.5



