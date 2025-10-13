Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BAF30E859;
	Mon, 13 Oct 2025 15:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367804; cv=none; b=A4RAzy4sqvFEGYszypO+i3TCEB5kkt+CF+Ws7cJpOd8cxDU0MoU/6+WKwl/C8TbpJVyZDGbB6+yy05D9yBo4F529FVhBvWdEAOuk6PSokspj9UjeRvIgrF4WUQ6PN+iR7JJx1WO/y/70Mkm4kGPPMR1Kw+hH9vnFvt+Lu2qm6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367804; c=relaxed/simple;
	bh=2Qljs/6GQ5kYpXFf7eAuoe/7XdV5B28KuLHFGC57YYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxMki7j+u15cuaV3Oy5Npse7TCnalSNO9yQH+Ch3G0WSkN8aecw0oDjsxTvd+FUXiwrS580uTlx1msMwywDY6mt1IZrTuHIFuOuDciZlF8ocVce1GoBxwlD275NvnNNICGv7AwRo8aQxEaMDMHsKDFRJlRUJZvYranpWF8NOzj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD9pGd+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD9pGd+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73288C4CEE7;
	Mon, 13 Oct 2025 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367803;
	bh=2Qljs/6GQ5kYpXFf7eAuoe/7XdV5B28KuLHFGC57YYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fD9pGd+WE7S3yTFnZlU265pGIvEK3/dgIiRCrGabHShGAXvYXsUPVBQNOdzEO/Lz0
	 CYpSFK5OiVlTnVtBbPzjRT/jJJurC7cBo4eIthkCoep7Ht323yPJX+f78kXGmFxFeR
	 ORCDtBqG52rf+n5ofvD3RCPmfwvd0+hgGcOxFTwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/196] fs/ntfs3: reject index allocation if $BITMAP is empty but blocks exist
Date: Mon, 13 Oct 2025 16:44:57 +0200
Message-ID: <20251013144319.148685965@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 0dc7117da8f92dd5fe077d712a756eccbe377d40 ]

Index allocation requires at least one bit in the $BITMAP attribute to
track usage of index entries. If the bitmap is empty while index blocks
are already present, this reflects on-disk corruption.

syzbot triggered this condition using a malformed NTFS image. During a
rename() operation involving a long filename (which spans multiple
index entries), the empty bitmap allowed the name to be added without
valid tracking. Subsequent deletion of the original entry failed with
-ENOENT, due to unexpected index state.

Reject such cases by verifying that the bitmap is not empty when index
blocks exist.

Reported-by: syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0373017f711c06ada64
Fixes: d99208b91933 ("fs/ntfs3: cancle set bad inode after removing name fails")
Tested-by: syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 191b91ffadbb2..f227db9f76c2b 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1510,6 +1510,16 @@ static int indx_add_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
 			bmp_size = bmp_size_v = le32_to_cpu(bmp->res.data_size);
 		}
 
+		/*
+		 * Index blocks exist, but $BITMAP has zero valid bits.
+		 * This implies an on-disk corruption and must be rejected.
+		 */
+		if (in->name == I30_NAME &&
+		    unlikely(bmp_size_v == 0 && indx->alloc_run.count)) {
+			err = -EINVAL;
+			goto out1;
+		}
+
 		bit = bmp_size << 3;
 	}
 
-- 
2.51.0



