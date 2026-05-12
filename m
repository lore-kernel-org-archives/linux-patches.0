Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DFD284883;
	Tue, 12 May 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609394; cv=none; b=OaA95n4pww+bL1WXCaDscGRTJIHxFLkfTSe3UZI6k7/vm2KNnvK2wuIRTLNE+8rGYXtPdkpbIr1xlAAPoMu3V1TlDcI4fIlBK3yeF8J0HvGLLZRVsEROp1BWf5joyCg/sMg8tE9U7bUi45u38qHrCFfOmjX6/jr5HX1F6nV4JMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609394; c=relaxed/simple;
	bh=H0nKSqzNpidJXiQv9fY0nTVvxdAD0NANIFsV7bgpYL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Weicl8K7goFT2st5ArN2VRah9akOg+kKIGx/3vBb2lTbLtff6PljgkWq0/EiENGA03Fg+G8y81BSxMtmf710Mkbyb8ZJjIUcgmnvsyWFOa1MAXZQewxp6wUrqF++AHvnBqVLcGbAfLIuvhPnyIr4Kp/ADXH4QtRSstoOyAxVJ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdYPGt+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdYPGt+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B88C2BCB0;
	Tue, 12 May 2026 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609393;
	bh=H0nKSqzNpidJXiQv9fY0nTVvxdAD0NANIFsV7bgpYL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdYPGt+dY01J+1n337yoGvOr2exV3AJOhoj/cFQfBL8K6q9+jB/Hbh7068y/diA67
	 bxcthOwmNYqd8IifqAkhpcXqWTinZJuGrs8f9yB9ESXqjQcVuaOlpMtPp/hTS3tPLY
	 +ebCCTJYN0PaiGWSPZLu0kjzspUMBGEeg7FLkaEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.0 178/307] btrfs: fix double free in create_space_info_sub_group() error path
Date: Tue, 12 May 2026 19:39:33 +0200
Message-ID: <20260512173943.874151726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit a7449edf96143f192606ec8647e3167e1ecbd728 upstream.

When kobject_init_and_add() fails, the call chain is:

create_space_info_sub_group()
-> btrfs_sysfs_add_space_info_type()
-> kobject_init_and_add()
-> failure
-> kobject_put(&sub_group->kobj)
-> space_info_release()
-> kfree(sub_group)

Then control returns to create_space_info_sub_group(), where:

btrfs_sysfs_add_space_info_type() returns error
-> kfree(sub_group)

Thus, sub_group is freed twice.

Keep parent->sub_group[index] = NULL for the failure path, but after
btrfs_sysfs_add_space_info_type() has called kobject_put(), let the
kobject release callback handle the cleanup.

Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
CC: stable@vger.kernel.org # 6.18+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -276,10 +276,8 @@ static int create_space_info_sub_group(s
 	sub_group->subgroup_id = id;
 
 	ret = btrfs_sysfs_add_space_info_type(sub_group);
-	if (ret) {
-		kfree(sub_group);
+	if (ret)
 		parent->sub_group[index] = NULL;
-	}
 	return ret;
 }
 


