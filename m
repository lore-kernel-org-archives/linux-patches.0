Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132543597E;
	Mon, 23 Jun 2025 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716422; cv=none; b=L3aFky65Ru4RiW2DIpSqhHHF7JOf/FnHnAGp8KoNvSsYYbYJRCeyD62CFfnhcyGYowFCgL0URXp2e4vkxcMEbqSbNqWqsvt/x63GVW6or7MJGrN8GOCiUz592C8MV1WLCvVTMhkgyIdtVIjQnFKXI4+aa4wf1vCCh7mQvjCE4JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716422; c=relaxed/simple;
	bh=SycDFfXPKHM9cGmAO6QBdra9BCA7CNJSeTD6TVRSRDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+TgbZyI0vOr/r0QieDncFdzzP7tCgRhHLmuNLOkl314p/lRYUhl8QkNVsXdzey8uKgA53gO+zaVL8CAmBBeqZ56PBqJdveCgX+m6TNepA+hZbW4BLdLJFhnjVK/12pjVEouSVzMYKyx6wjcjwfS+uj3tnvXimmNj5afBmh3yyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk6EKgeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk6EKgeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9776AC4CEEA;
	Mon, 23 Jun 2025 22:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716421;
	bh=SycDFfXPKHM9cGmAO6QBdra9BCA7CNJSeTD6TVRSRDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk6EKgeTm8tJS5PSPczMFlERUzJaK1XOtr5OGvMpPSnNf9mlLxt/ju8+YrdP6t/Oc
	 tpjDz5GWcz4/Lnh7wLhwX7BQ0FRfRUdUB1bySINhrintxPnDuCXoLK+Q8gkumChgX6
	 bUN/m/g87az+JJ4sYqh6b+3L3UrnpZqpKZwQivJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 522/592] pldmfw: Select CRC32 when PLDMFW is selected
Date: Mon, 23 Jun 2025 15:08:00 +0200
Message-ID: <20250623130712.852739223@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c1b8f1842678..37db228f70a99 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -716,6 +716,7 @@ config GENERIC_LIB_DEVMEM_IS_ALLOWED
 
 config PLDMFW
 	bool
+	select CRC32
 	default n
 
 config ASN1_ENCODER
-- 
2.39.5



