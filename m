Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD713BB68B;
	Fri, 15 May 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862274; cv=none; b=esHNJrnmahcvx6rIIRJfRtGJhFEWzRnSc0n0IHsswFtnAOuMs5hnNgWn++vGhlU5oqJXHqWr9dcKvb+7gtlLur61RMbY+euoA+nXeHhUlYGg9osHUehQlq+Qn/93mRLLKmKHwrzfpx8LtzpPvGBbiYLSW2Fs3qwhS2QcgZaMtXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862274; c=relaxed/simple;
	bh=jsZ1jNHyUIflvEm8cSoSGu5HAOv2rj10CKMPPz118wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsrobUYBVD0fTY60DPOMUeruTfxhCqgKDF5n01eKkIwBVIZHHpiJQsm8hZec89x6fG36WFt3p9ID9cmcpJ1E/y3bDVMiyckTf7zvIia9+M0HOz296K1Kd3W1RjNJ4hYnkj0O+GLUS+15cvQ+S7U59ZzZsSAmwsV4e8CjTckORPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAeAC+Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAeAC+Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562D9C2BCB0;
	Fri, 15 May 2026 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862274;
	bh=jsZ1jNHyUIflvEm8cSoSGu5HAOv2rj10CKMPPz118wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAeAC+KanZDQA3TExA6dfCATa1QR+o8OX+F3l9gsbOG8RmzUzjsI17xJQMNU6b0Gn
	 VebTwZp7lHstHPlJSViD/yQU7L4hrYwuJ6lHmQXrkUsTqYGpDbSZXhqC3wdZ35SLhr
	 Dccd5s6rrZwDIuMr6QAZCNhB8LIb6CYYx8cLe0HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/188] btrfs: fix double free in create_space_info_sub_group() error path
Date: Fri, 15 May 2026 17:49:52 +0200
Message-ID: <20260515154701.135322405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
 


