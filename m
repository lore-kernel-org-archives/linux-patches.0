Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42994268FE7;
	Tue,  8 Apr 2025 11:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113322; cv=none; b=K75sZrg5N0IMVAM2Dn/z9P6sbVR4aDBgPmSo6x6dwbJHWPza/dZn3GaMYN6kLecsBKfmPQhhf7frD33POVI+32omNsCzfOvX+zdk+1iCarbs9/F7epnsPaZWDez2PU6FdoIk8+jy4c+Ni1jxfWaiJ6h8XYb3X8i0wcSn7HqjMes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113322; c=relaxed/simple;
	bh=ZuIWmZJTDq1mcGB7Y4+gpBjS3oHydLC0x+NNfQYbDtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPLzdSNNwd9j5270RZdnabPcF7vr56KWiXdrZu46v4hyBX/2SUSDSAxDO96agDQooIYYBotw5aZYvhBOf3c8zXTFa0jBCGUI04ex1SC95paDfyjZwg5ks2gMhiSP5eAGlbi6WvCVt0vb1DzJHuc+O/9SX5dhI4D+X5Lymc9mk+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDPKjWV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDPKjWV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECF2C4CEE5;
	Tue,  8 Apr 2025 11:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113321;
	bh=ZuIWmZJTDq1mcGB7Y4+gpBjS3oHydLC0x+NNfQYbDtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDPKjWV89iAEFeK50I8DYUcZs5t6HiNFGcOgdCLYZ6C0XLX6oowWhbrGnpocf4Tbm
	 oNRf5CgSci8gklQrg5qJv2xchDWcziwsGq/CWD55639OqxV7LUgfjrhFTEOEd+ieKI
	 j5bso6aUsjgab6K5UxF7jfmjbqIe4Hnnvg//B0fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/268] fs/ntfs3: Prevent integer overflow in hdr_first_de()
Date: Tue,  8 Apr 2025 12:48:48 +0200
Message-ID: <20250408104831.653210128@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6bb81b94f7a9cba6bde9a905cef52a65317a8b04 ]

The "de_off" and "used" variables come from the disk so they both need to
check.  The problem is that on 32bit systems if they're both greater than
UINT_MAX - 16 then the check does work as intended because of an integer
overflow.

Fixes: 60ce8dfde035 ("fs/ntfs3: Fix wrong if in hdr_first_de")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 964e27c7b9016..c1d1c4a7cf4d6 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -717,7 +717,7 @@ static inline struct NTFS_DE *hdr_first_de(const struct INDEX_HDR *hdr)
 	struct NTFS_DE *e;
 	u16 esize;
 
-	if (de_off >= used || de_off + sizeof(struct NTFS_DE) > used )
+	if (de_off >= used || size_add(de_off, sizeof(struct NTFS_DE)) > used)
 		return NULL;
 
 	e = Add2Ptr(hdr, de_off);
-- 
2.39.5



