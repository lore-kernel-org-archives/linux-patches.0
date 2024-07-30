Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CDD18801C;
	Tue, 30 Jul 2024 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358043; cv=none; b=VxjMPUppxFzIFUlls84e4D3Lmj/dlzAtt2O+IXq7GVvw6UsmhHWIUJSd8GyGcRL345SanN59nBAKHKsxd+Y38Da5CROmxElb5vS8kpCY5kyFTA1gmZVvnN525XxocRDeXb9YAhpMRaBgJK/52Ttypf39pJVMM9AtpaPlfQZfmLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358043; c=relaxed/simple;
	bh=kOzxpNXnRcacxQk1aZkEDoITg2iW+X8A9w8/j0GSaGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hM9StQ5Acf+aUCUSlw6eXHFmx7IqBgdqolzg6GLfVR2vjEdAy8Q5fXlCJhHTpt5YYVm9WjXffm/JTfptVYbfW5D+RC8n35g40sM97wfh4YwhI8kmqegoz9aLImPKxnjZI3LFMjbUtxQTbI2ZMwDyOWankcT7dt2fw0MnbGvUTZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUnIEtfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUnIEtfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042EFC32782;
	Tue, 30 Jul 2024 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358043;
	bh=kOzxpNXnRcacxQk1aZkEDoITg2iW+X8A9w8/j0GSaGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUnIEtfGafq7iz0cUF0W1Tu/R+eRu7yk1cUVGWAWQDUvxzZA55sDITfXQYnJ/8J3c
	 h2tBIucrN2U1Qgk8iek7YeZIZe+Cvql9gfZjkFLggwNeMnsolyQFX6bXlIMjn3Jecu
	 hTGDmmYZ1+A76UkLtqBmmz9Nvgw/WfqMawqq4Bmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 320/568] fs/ntfs3: Fix transform resident to nonresident for compressed files
Date: Tue, 30 Jul 2024 17:47:07 +0200
Message-ID: <20240730151652.383375050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 47d388699f5f0..e6c0e12d1380b 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -231,7 +231,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 	struct ntfs_sb_info *sbi;
 	struct ATTRIB *attr_s;
 	struct MFT_REC *rec;
-	u32 used, asize, rsize, aoff, align;
+	u32 used, asize, rsize, aoff;
 	bool is_data;
 	CLST len, alen;
 	char *next;
@@ -252,10 +252,13 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
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



