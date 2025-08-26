Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D6D17A2EA;
	Tue, 26 Aug 2025 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213152; cv=none; b=R02MlsLDKYp5ea8qnLQolkwaOjirTX5RgEFTRDrS56bqWM7w/RwY/fVEhyLbZej9GGqRf68QNDPsiq2aEviymuT3rmVQn3fWdj7PxOdX43Wm/zOtgd3M+64x+nXqVaKfVDK/K0fyLHKQ1ID95gRJ+nwuz6/NAMUNr4eAgtLJuJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213152; c=relaxed/simple;
	bh=6TVE0Aejbe0o8FMg6k/pasTyEHYk3yLVTMBJeOI/Oyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvD2a8+0H1b2itftJgsMutz6fLap2o8RJfTiyXJdFxVE9RwTGLbrLUwBswfMgBbZf2ELpPfcNn3mu8+RC5/o92yImg2jPz586nof9OTJxCmYVCkVYLd1+Ur193Ui+izerAD9j0Fqiy3zTZCbRR6CF90W+5S8eNa4Wtcvz/pq7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHcjDzyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHcjDzyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308A6C4CEF1;
	Tue, 26 Aug 2025 12:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213152;
	bh=6TVE0Aejbe0o8FMg6k/pasTyEHYk3yLVTMBJeOI/Oyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHcjDzyp/035dwQjTLbPeZz27wJKsWckYQa/fDJXVGBKeOtgeRXexld0UCixxtqiD
	 kkXdlBKAXbxwc32w1fs23uB0a6xH2cuyvoHrDT9dtiwkjq2AeDC7P60vHm8CePLfCe
	 Yx5TpzXLVPsp1zTOS5t1YsZgZdh4EuWQX4Ujur00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+544248a761451c0df72f@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/587] ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr
Date: Tue, 26 Aug 2025 13:06:12 +0200
Message-ID: <20250826110958.609512224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 099b847ccc6c1ad2f805d13cfbcc83f5b6d4bc42 ]

A syzbot fuzzed image triggered a BUG_ON in ext4_update_inline_data()
when an inode had the INLINE_DATA_FL flag set but was missing the
system.data extended attribute.

Since this can happen due to a maiciouly fuzzed file system, we
shouldn't BUG, but rather, report it as a corrupted file system.

Add similar replacements of BUG_ON with EXT4_ERROR_INODE() ii
ext4_create_inline_data() and ext4_inline_data_truncate().

Reported-by: syzbot+544248a761451c0df72f@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c85647a0ba09..5fa1dd58ac42 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -298,7 +298,11 @@ static int ext4_create_inline_data(handle_t *handle,
 	if (error)
 		goto out;
 
-	BUG_ON(!is.s.not_found);
+	if (!is.s.not_found) {
+		EXT4_ERROR_INODE(inode, "unexpected inline data xattr");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error) {
@@ -349,7 +353,11 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
-	BUG_ON(is.s.not_found);
+	if (is.s.not_found) {
+		EXT4_ERROR_INODE(inode, "missing inline data xattr");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	len -= EXT4_MIN_INLINE_DATA_SIZE;
 	value = kzalloc(len, GFP_NOFS);
@@ -1966,7 +1974,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 			if ((err = ext4_xattr_ibody_find(inode, &i, &is)) != 0)
 				goto out_error;
 
-			BUG_ON(is.s.not_found);
+			if (is.s.not_found) {
+				EXT4_ERROR_INODE(inode,
+						 "missing inline data xattr");
+				err = -EFSCORRUPTED;
+				goto out_error;
+			}
 
 			value_len = le32_to_cpu(is.s.here->e_value_size);
 			value = kmalloc(value_len, GFP_NOFS);
-- 
2.39.5



