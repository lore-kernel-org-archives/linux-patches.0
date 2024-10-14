Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301F9E571;
	Mon, 14 Oct 2024 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915880; cv=none; b=JjNEGTIrpTLetksAw3Lkloklq4g0ahQ9vmr7xOlEwywrBnMcC2JOpNPsKtV2nSoX/jMiANEMMJrQIKhXOZEAbPzYdWRyvm5qk97V2eji0Joz43qOepCTdJMLyXZHlBscALZqUjtMPx50kmDhkQ9Rd/ZB1G8qBnF/eVUQcf+Zo6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915880; c=relaxed/simple;
	bh=fk9VNFnx3tPCJigBpT3bjIX3OrJYJoyrrAGAA+Ezu4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSyJAZKKXwlJgbcXti8Lw0sowwQWrDTOepTdUEmzH+OLin1aXLKoDYL0syPg5lM3kV0PDeKWfUj3KCtytwRoFeud7zsQLfkt8RSi9xzQGKVrxky4AiiXkB8EQOZWBOIGkfKxGKxxHqzco5PirTnKRQ9sR1hrRmJbYxXu8Vdlm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYAH+tpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYAH+tpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944EEC4CEC3;
	Mon, 14 Oct 2024 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915880;
	bh=fk9VNFnx3tPCJigBpT3bjIX3OrJYJoyrrAGAA+Ezu4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYAH+tpyIwmh1bM3+ID0aB6edFdUTk6FH2muNR3XqGfA1RsrD7XnFeYToZ8lGvcw1
	 X3i1U4ZQFxg+CyKTRSzmJ12EEBl9uWIxKU2vnSWSOoNQy95tT0vwrLNVQboCAl4I06
	 sqSb6d2Hez8ueY7dDbnzls3z2xx1kSWtN/82iIlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/214] fs/ntfs3: Fix sparse warning for bigendian
Date: Mon, 14 Oct 2024 16:17:48 +0200
Message-ID: <20241014141045.201122211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit ffe718c9924eb7e4ce062dd383cf5fea7f02f180 ]

Fixes: 220cf0498bbf ("fs/ntfs3: Simplify initialization of $AttrDef and $UpCase")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404181111.Wz8a1qX6-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index a8758b85803f4..28fed4072f67c 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1491,11 +1491,10 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 #ifdef __BIG_ENDIAN
 	{
-		const __le16 *src = sbi->upcase;
 		u16 *dst = sbi->upcase;
 
 		for (i = 0; i < 0x10000; i++)
-			*dst++ = le16_to_cpu(*src++);
+			__swab16s(dst++);
 	}
 #endif
 
-- 
2.43.0



