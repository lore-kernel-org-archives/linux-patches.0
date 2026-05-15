Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509863FF1D8;
	Fri, 15 May 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860552; cv=none; b=RYnpINaJ67wSI65KTTrCVmLDqmppfKTPk3Qw927lYNapfaPf66kbNHIhaXXDjzMXBkLTQPKSaR8s8IW3ZJzkUJ8Xk/3J44eI3phbjKcuzpMfOkOkSJqz+98SdLpfJo7tYQo6LO2tfAgov9CmSrackHJ2j1cQB1JER3n4rSFk5D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860552; c=relaxed/simple;
	bh=O3arwQr2YyeQbvs7bdnPeFP7Xp7vnHZBaZaQ2lM9o84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL01jQDZ0r57UPhZU1wU07qbsfzJyquGOp4T7/4zeuJMYbNXhg1Gfgl1NZxN07DC7RjdbnS4IT7O3XSMZtrfOfZ2Km53QiETS8/l6ABJif8eqLoJG3ZN8hyu9xTqAZHMcvCdmX8WT2xAU6C9fyVvDDBfFBCaqz6ia9UVHtNRISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+ybQ6R8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+ybQ6R8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD2CC2BCB0;
	Fri, 15 May 2026 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860552;
	bh=O3arwQr2YyeQbvs7bdnPeFP7Xp7vnHZBaZaQ2lM9o84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+ybQ6R8YYJUl7qbFZbTz5f5UTLaQ6De4bPJFm0q+GJZjnliogZqqiPxB35IkTWBC
	 O6YcCvbr/qnYdnz++VsLKPdnSSa1HN6qyuAkydP0UftO1k6gvBL8uQnWZDGDP9PmIe
	 yuf5QWaSls8T6Deo4YIqITOsgaRe2SUpXLgahIpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/144] btrfs: fix double free in create_space_info_sub_group() error path
Date: Fri, 15 May 2026 17:49:19 +0200
Message-ID: <20260515154656.601727190@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a7449edf96143f192606ec8647e3167e1ecbd728 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -266,10 +266,8 @@ static int create_space_info_sub_group(s
 	sub_group->subgroup_id = id;
 
 	ret = btrfs_sysfs_add_space_info_type(sub_group);
-	if (ret) {
-		kfree(sub_group);
+	if (ret)
 		parent->sub_group[index] = NULL;
-	}
 	return ret;
 }
 


