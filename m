Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC823269830;
	Tue,  8 Apr 2025 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111575; cv=none; b=VKKf7RE7pGtRillDjM7OUMj6G6RGxVU6B8vv40ZRNUnyxI4GVevMQ0r4U2bo2UEXAQPumdhxPGF8Am0XdGUZ2T9k8tGbeOTqeiPMyEpjoLCPc48p89EDfJKCJvLpi+ZXxJkpcslVq50lev7zTv86c5bjy1SAXmj/p7QmllexieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111575; c=relaxed/simple;
	bh=U3tnj44QcU8jaay1cVW59WV/1FQrJTxDVHhLEZLieKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkQCtE/Lg9iP7uQ49eKJLcjiJnRQt5mdWImNL40v3eLF1TwErRpPE5dy4GYEARqWmiknme0l/8MfTNi3Rt81cGVMC5vLYf4u3kRlD9soIcJDJjwtm1khYw6Le2TVQAVWyO4Mj1rJ5jHIEIahHZ70bIZrevdEV33Y1NRgAZa6DzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHOMTk4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHOMTk4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F5FC4CEE5;
	Tue,  8 Apr 2025 11:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111574;
	bh=U3tnj44QcU8jaay1cVW59WV/1FQrJTxDVHhLEZLieKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHOMTk4YAPHnQKCb3S3dWUFFebJ8tRcm7Ks4hq5n3gdk79zfM0rp2TdpVQ0Yvruvp
	 1hCjjJtTD7vWXDUGGRIgRnh0lbUicQuX7/0YRYFsjfXJg+u/dOZDRDq4SnxscSp1Iy
	 n5nGV81tAEoWgZQSPd4oSUFMNENgBv9It4+Sn7CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 481/731] fs/ntfs3: Fix a couple integer overflows on 32bit systems
Date: Tue,  8 Apr 2025 12:46:18 +0200
Message-ID: <20250408104925.465873682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



