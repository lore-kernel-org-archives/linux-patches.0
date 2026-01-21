Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9E438A9D9;
	Wed, 21 Jan 2026 18:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020042; cv=none; b=FX/RQuMZIQFGpAf/AVjdE37SPAsohdi1+PKGxfmfuQ1OUC9NmzneTsD62XL06l90UKGzl0kZ+7V4tUQA7HT6Fqu3FokRFYxae7kAueRUCVZEtMRb6sifmBsPiQGi5zhK0rjw+JZRDAqwPV73xqMCP+OQKN0+/DO9JWxmQTWIxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020042; c=relaxed/simple;
	bh=qdrEwurNitZNnoU9BLyHLm94wzQP7hGJyRE+tGrtUUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCatxQo/SZi/aXAADy45qqfKzIMZkHAFahHU86JybSt7eOjgIEV2woZ0WIAIqpBU6NrkjBORcfCzfpw2M8CHV0rPl9H9E8a2GkqTHMTO+/AVKhcKEViGbE/JuuA7iTUfMhxBdw58Y/lKjPNBsd52VC6+88upxDkf4cucU2nyEe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgmMLKA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgmMLKA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C18C4CEF1;
	Wed, 21 Jan 2026 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020042;
	bh=qdrEwurNitZNnoU9BLyHLm94wzQP7hGJyRE+tGrtUUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgmMLKA2DvyD4WZW7piZH/Ffb0DROAZ5qEmPFt3Ny05UNYY162VUswyT8MvlGzWW0
	 cSEZifv7elzP9RXKVv/vbiAGip5sK35aqn3vmhO0UnNwMAO+CnHNbqG1dAruUSHCDl
	 RJK+b/9a8zBZeW5Ks/c6graf9fKNR7XPkkfsYjhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/198] btrfs: fix memory leaks in create_space_info() error paths
Date: Wed, 21 Jan 2026 19:14:31 +0100
Message-ID: <20260121181420.100775049@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 85c466c85910a..a6f94e9f55915 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -305,18 +305,22 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
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



