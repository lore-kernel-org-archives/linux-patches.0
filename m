Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DDE3806BB;
	Wed, 21 Jan 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019519; cv=none; b=CyO6Zie5hi+H3Ev48DYurdRAg/BP1mvROI1kRM0Fvqbret52b7xI0Uitk89E2zvLNiylprrkIyGDvgmrXQADnYpsDl9JMzXnrQi0etmuegZHBf7X3D7vxRlwaCxUWLeiDA/DzEIyonCEMATSjZHwd6R8jJ0a1zjF0GXn9jAD01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019519; c=relaxed/simple;
	bh=U55KYdoPTS7QShalBkCTSAC9ODs2l0PguIRfsM32DiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruvHgjFJw9IQa2P98UqgPO3UojgDI3tsB/r3mxaTfh1yW2ZnvlHsh0+OwqNsZtdGdaLIzCALi/X9QjViFqbRp7w1bMGVJDlUTsjJgQt8ASByyIpWg20EJYdDgfjEyG61eHjKZSanAAPSH97SZrTPfJbyOv9SdltbuWnf6V/xcLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMKjUnsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMKjUnsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385A6C16AAE;
	Wed, 21 Jan 2026 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019518;
	bh=U55KYdoPTS7QShalBkCTSAC9ODs2l0PguIRfsM32DiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMKjUnscz/dpkDSUtKP3kFl50LiWTbGk7wr0sfY8FLSbuKiReiPHwh9A8sPpPeK3Z
	 mti69P72EqZCQytqCaM90cAq0gE/hRqIb9cFvF7uc/vZxUzLj5ajC3S/OhvuWWleHB
	 DADDQBIRii/0gmZj4WEiAgt77S5uFGcOefY/P1Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/139] btrfs: fix memory leaks in create_space_info() error paths
Date: Wed, 21 Jan 2026 19:14:38 +0100
Message-ID: <20260121181412.540759807@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit a11224a016d6d1d46a4d9b6573244448a80d4d7f ]

In create_space_info(), the 'space_info' object is allocated at the
beginning of the function. However, there are two error paths where the
function returns an error code without freeing the allocated memory:

1. When create_space_info_sub_group() fails in zoned mode.
2. When btrfs_sysfs_add_space_info_type() fails.

In both cases, 'space_info' has not yet been added to the
fs_info->space_info list, resulting in a memory leak. Fix this by
adding an error handling label to kfree(space_info) before returning.

Fixes: 2be12ef79fe9 ("btrfs: Separate space_info create/update")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 9d47678875b76..b2c90696b86b2 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -291,18 +291,22 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 							  BTRFS_SUB_GROUP_DATA_RELOC,
 							  0);
 		if (ret)
-			return ret;
+			goto out_free;
 	}
 
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		info->data_sinfo = space_info;
 
 	return ret;
+
+out_free:
+	kfree(space_info);
+	return ret;
 }
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
-- 
2.51.0



