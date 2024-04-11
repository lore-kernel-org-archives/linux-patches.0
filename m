Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41B113DDDD;
	Thu, 11 Apr 2024 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829540; cv=none; b=PBeNMi/j5INCkQ74nJRMJsWZ8o0G6y4SFsUwuxP/ntERN9IZ2B9fxgjEkIPlNb1dGQ2nAwSYCZzVKYI7fdx+Z0fTTW/vfmhVTpDy8taaslI+rXCHz/wPTPWP8lpVL4KzYF01zMK0BL2QHW1vHHdlfe5Jbx0/8A2bi/HBG3Ix1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829540; c=relaxed/simple;
	bh=fJi/t9aQy3E420HOlDR2JQn+BGjT7HH26Ze62lXcD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+ez8dHTbIAr/Fp8rrhsOlq2fHH32hXv8LDznP+m7OPoyxBYTOyC9Pjd+u7ha8IjVijLUFOSSvkQgqCFFeg9PwC96oSdO7w9mvjrWrrjU6QidoSsJvRSvFtGdBRk8kUcLWzaj5IIFcsKE6BW5SHwYLbWYYlnz4paMg7mQanhraE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Doacit03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Doacit03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682FDC433F1;
	Thu, 11 Apr 2024 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829539;
	bh=fJi/t9aQy3E420HOlDR2JQn+BGjT7HH26Ze62lXcD7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Doacit03JlaZyuqo5c7SWhlALadbQWKtxebOK2mYjqPB2L9MQgYrY+rAJZlXE01ZK
	 /+yCGtdrDXs34TdgipRKzZmQXJ5vq8Xb239fzO55gvAegrN36V4aYoeIAfLgjcXeHx
	 gsSuLbFmndvpFjFV9GHr83xY7AegfTzcawXjs3pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/175] fat: fix uninitialized field in nostale filehandles
Date: Thu, 11 Apr 2024 11:54:04 +0200
Message-ID: <20240411095420.189483577@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit fde2497d2bc3a063d8af88b258dbadc86bd7b57c ]

When fat_encode_fh_nostale() encodes file handle without a parent it
stores only first 10 bytes of the file handle. However the length of the
file handle must be a multiple of 4 so the file handle is actually 12
bytes long and the last two bytes remain uninitialized. This is not
great at we potentially leak uninitialized information with the handle
to userspace. Properly initialize the full handle length.

Link: https://lkml.kernel.org/r/20240205122626.13701-1-jack@suse.cz
Reported-by: syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com
Fixes: ea3983ace6b7 ("fat: restructure export_operations")
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/nfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index eb192656fba27..f442a8d2f114b 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -139,6 +139,12 @@ fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
 		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_FAT_WITH_PARENT;
 		*lenp = FAT_FID_SIZE_WITH_PARENT;
+	} else {
+		/*
+		 * We need to initialize this field because the fh is actually
+		 * 12 bytes long
+		 */
+		fid->parent_i_pos_hi = 0;
 	}
 
 	return type;
-- 
2.43.0



