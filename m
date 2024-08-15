Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CC44376;
	Thu, 15 Aug 2024 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729607; cv=none; b=i294x1U8g+sT3UzDizUwP/2N/sPUYyxWSfEU9TOH2Jt3qhWjCxOXkPYi178WLFQxY9b0kOqCcZuIDNetHMe3+Grud4c+LxWcP6mRo5Su5loWrX4BJBEjmnZGyuhzwqtH6RiD9oMbHS1VXWA/YByFKFu1Y5qGl17upg8Dfy7QFAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729607; c=relaxed/simple;
	bh=BrIVXP/W+58QT+rhZcrusn/7s7bIUfLHk6Dyf+xMLy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQOjPFeNxr8rVz31syJFz+pffL91cUYjAmPtLw2hQjWMOpzdxIzayhpdHPy7BHI9gJ0IdyhJocR0Aa4ADcgCE9ohVdiTQH11zZOFj6RdMni0YKdU9JP3lgnF/krGUeNRxHB3wefVDveA/Qi4z5mo0nfOC+mM1kGo746V3M9sL9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7ssQ8kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7ssQ8kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F59C32786;
	Thu, 15 Aug 2024 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729607;
	bh=BrIVXP/W+58QT+rhZcrusn/7s7bIUfLHk6Dyf+xMLy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7ssQ8ktI2oyGC2qs6TH/zkBIi5G2pU+jexamHylLTMAFMmBbSqePfZHL/n6RbojY
	 4NFStOIVspIPfUiO4ArB3tUbOZJwLDFpAi6awD+WxFJeQOavAItpMW+8hvaeWsEVJX
	 ydRBLOOuczKIImlPWUHXqQLQj+k9BFVmT1IArKc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/484] fs/ntfs3: Fix transform resident to nonresident for compressed files
Date: Thu, 15 Aug 2024 15:20:09 +0200
Message-ID: <20240815131947.249230464@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 25610ff98d4a34e6a85cbe4fd8671be6b0829f8f ]

Сorrected calculation of required space len (in clusters)
for attribute data storage in case of compression.

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 558a7e9bf1ef2..e8fc86dab6114 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -242,7 +242,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 	struct ntfs_sb_info *sbi;
 	struct ATTRIB *attr_s;
 	struct MFT_REC *rec;
-	u32 used, asize, rsize, aoff, align;
+	u32 used, asize, rsize, aoff;
 	bool is_data;
 	CLST len, alen;
 	char *next;
@@ -263,10 +263,13 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 	rsize = le32_to_cpu(attr->res.data_size);
 	is_data = attr->type == ATTR_DATA && !attr->name_len;
 
-	align = sbi->cluster_size;
-	if (is_attr_compressed(attr))
-		align <<= NTFS_LZNT_CUNIT;
-	len = (rsize + align - 1) >> sbi->cluster_bits;
+	/* len - how many clusters required to store 'rsize' bytes */
+	if (is_attr_compressed(attr)) {
+		u8 shift = sbi->cluster_bits + NTFS_LZNT_CUNIT;
+		len = ((rsize + (1u << shift) - 1) >> shift) << NTFS_LZNT_CUNIT;
+	} else {
+		len = bytes_to_cluster(sbi, rsize);
+	}
 
 	run_init(run);
 
-- 
2.43.0



