Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCA826656B;
	Tue,  8 Apr 2025 12:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114763; cv=none; b=hMFj75eL16O4TP4h7Keap5x9ADCpCqt8v2TKaRWf9KQ5rOdeISwdqLn0aGPDVZx+SMkxfSUAlslWqiQAqdyF51ApU0mjaF82VJPJ7LNHW1Gmcl+vQBdG7qKXTSh1uNf3+3DedudplDqGvEGvBfvg1a4NIUb1+z4fa4dYfY7iVEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114763; c=relaxed/simple;
	bh=fPWDPiDTyzrt7bUi83bei1WeaBnzS8ctJlmyxnpJ8XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlIx3o7DwE6XxFcW0jzK4hD71ZXjMF+imsA6Ik4R6xq0aadcf+cBJRhV/WE39D/WMfQRHO//kKDpEwZr2TEYpAMqbO5PIruY3tx5WqBupGT5BKhWKLO+W1D5YTGPVvk5YpIH69FoS+l1J2Wh1NTQj76X9E7GcZ66nfkE+rxA8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7mI6Y4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7mI6Y4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D536C4CEE5;
	Tue,  8 Apr 2025 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114762;
	bh=fPWDPiDTyzrt7bUi83bei1WeaBnzS8ctJlmyxnpJ8XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7mI6Y4psBEqR9dgDD/Fd5y4V3ur6TJugP5eigDGxTCib9GUt936HRYXSP4xtbe1q
	 +kpFmZsigcvFEvZboZagcwsU5qJTrer/v8YqNm1dJYqyJsNTv9pjgOrgOKfDd4hS4s
	 obYmUNeWY3FIZBZSMWmiEnXfQlEUFTPpBcb7G6rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 227/499] fs/ntfs3: Fix a couple integer overflows on 32bit systems
Date: Tue,  8 Apr 2025 12:47:19 +0200
Message-ID: <20250408104856.873022741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5ad414f4df2294b28836b5b7b69787659d6aa708 ]

On 32bit systems the "off + sizeof(struct NTFS_DE)" addition can
have an integer wrapping issue.  Fix it by using size_add().

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 7eb9fae22f8da..78d20e4baa2c9 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -618,7 +618,7 @@ static bool index_hdr_check(const struct INDEX_HDR *hdr, u32 bytes)
 	u32 off = le32_to_cpu(hdr->de_off);
 
 	if (!IS_ALIGNED(off, 8) || tot > bytes || end > tot ||
-	    off + sizeof(struct NTFS_DE) > end) {
+	    size_add(off, sizeof(struct NTFS_DE)) > end) {
 		/* incorrect index buffer. */
 		return false;
 	}
@@ -736,7 +736,7 @@ static struct NTFS_DE *hdr_find_e(const struct ntfs_index *indx,
 	if (end > total)
 		return NULL;
 
-	if (off + sizeof(struct NTFS_DE) > end)
+	if (size_add(off, sizeof(struct NTFS_DE)) > end)
 		return NULL;
 
 	e = Add2Ptr(hdr, off);
-- 
2.39.5



