Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021171;
	b=lSJ6ak1afgU/u1dLr4ENu61cSp8qT1WC47XNsnasexJ9Ap56dtJhjvsZIOE97qniq0rz
	 PEBWs1JsYG7fEWWee+HRRkuZ3JR1KGpc/EeQ5J6hxeT6XGXWCYcANopv3w0mawLbtW9b8
	 He4rfGnp96Va361V60WLYKlw2cp6g2epwFQBoGun0cELPvXDlepoUnRGyiOe3Z1X52Kyp
	 umcIyXjDbmMOWNAJV/EZNhH765CFd7PdmsE9Fn4BK2rFUK5xguDZ20ByGhwiGrfgINg09
	 ZJ7aMiin+KtQ83A3dlkqlxIezIjtwYkBjYqhlItBdwPcQixvhNyKve7ePB3kStsvGVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ytLLveomDApvbROx4gEIesISNtfa+HZx+IhH62eySVc=;
	b=ZSzTXQUODYkJA2fEC+7vUBvhtqJqse2821wI/RsVlgKP7BT7ol1ylGCOTABz4m/ogfZu
	 HvmYjUl98XKdL3cSEV6ggIhNRD3BBeo+nd/MjMb50gOH3/QtFRfMnMxFTPiPY8jt/tuMq
	 xKHWX+CTxdkNc4pakyLM/hoa36wtVpGh5EtMpmBxnCuKSp8f+iN6Ay9BbX2cBiyJ4e+gX
	 hIyGcqlrWIXnG6gB6mjefH/Q8Buf2XuU4XwHy6g3qkAEKvXzjTuCii7hHixjiVEQfkM6K
	 HLLkCkcakPb8Lf9SM8lS60APL5WJ6A4f8UKwNOrBL5wNRrxvrXhapBU9ICukEppaP/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/0DyTDW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A553E606A320;
	Wed, 18 Nov 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/0DyTDW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDF41F000C4;
	Wed, 18 Nov 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021171;
	bh=ytLLveomDApvbROx4gEIesISNtfa+HZx+IhH62eySVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/0DyTDWUb//ilkjo6cbPO0ncx7E/Bt/HnReat5uQI09UfKzG1Tn6L9ZiNXdILbvt
	 MNNAJK/xJUxOl1QKXCbUvYtXVJIel4Oq2/LtcgsXvkGWIcDhOuMaUiHz1gGa6kY3f4
	 FEOG13UV+lZkWda2n9FYT7h2EJkaeJ68fMr4Of+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2212/2651] ntfs: avoid misclassifying directory reparse points
Date: Wed, 18 Nov 2026 15:57:32 +0100
Message-ID: <20261118150405.273572620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 22002cb8b6594830dc0b2d26faf1aa5fa3de94c1 ]

Windows directory symlinks and junctions can carry
FILE_ATTR_DUP_FILE_NAME_INDEX_PRESENT in their entry while the reparse
flag is stored only in. The old directory enumeration path treated such
entries as DT_DIR, allowing no-follow userspace scanners to recurse
through symlink targets.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 173ba95c0dfd7..b72990c2dd58d 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -635,11 +635,11 @@ static inline int ntfs_filldir(struct ntfs_volume *vol,
 	}
 
 	mref = MREF_LE(ie->data.dir.indexed_file);
-	if (ie->key.file_name.file_attributes &
+	if (ie->key.file_name.file_attributes & FILE_ATTR_REPARSE_POINT)
+		dt_type = ntfs_reparse_tag_dt_types(vol, mref);
+	else if (ie->key.file_name.file_attributes &
 			FILE_ATTR_DUP_FILE_NAME_INDEX_PRESENT)
 		dt_type = DT_DIR;
-	else if (ie->key.file_name.file_attributes & FILE_ATTR_REPARSE_POINT)
-		dt_type = ntfs_reparse_tag_dt_types(vol, mref);
 	else
 		dt_type = DT_REG;
 
-- 
2.53.0



