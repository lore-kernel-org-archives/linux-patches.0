Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4FE4409;
	Mon, 23 Jun 2025 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716066; cv=none; b=r0xa1HBzU5CRSrivrWPtgl5ZfGTrZWR9UBPF6TY4PfvyI5d4oSnamsMMpu0BFIV/TGAWVZf6Mx0IT81jvPERCBqy02O93I6oLE6AT7QZKZfpZe/VwgisL0lJxpbP4j2xfDZR+QSjW5/0K+WS9e6uqJbXdwZGY+KlKxHf7tyuRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716066; c=relaxed/simple;
	bh=ZXQC6USEbEgF1KBAtKCGQgIhFMjYpcU63PGTvrmngaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9TKqNHRX4A31k1essUPEQSBRErV/CWO2h4CDsEEVvL55E6p6xbr8syOyjxHaqbjWLW5IjzdjB/q+JmANlOh7Q27c0wzXHQmcTK0P5xEhDYJWsMYXIBUFIYTeGtbf45NqlfHE7hJZcTbfUgs61MJBGeeDjqm3coaAdzssHdzpZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar7Pdi0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar7Pdi0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F27C4CEEA;
	Mon, 23 Jun 2025 22:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716066;
	bh=ZXQC6USEbEgF1KBAtKCGQgIhFMjYpcU63PGTvrmngaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ar7Pdi0q32zJJ0+MNuYs3wf6qegANhnjHxIRtn63dtCve6M3Jars27szKyA4H4LEJ
	 gi/iy3nbI57J4sTloJDArVHN20bJ0aH8f80wED+ZCm52BTdGsMxpJXAQRCXKmfFQXh
	 gFI1++eRpHmQeYYu3YRMSVJIWaeOdoLjXIDNtD40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/355] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:28 +0200
Message-ID: <20250623130636.008769051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36326864249dd..4f280d0d93dbd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -692,4 +692,5 @@ config GENERIC_LIB_UCMPDI2
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
-- 
2.39.5



