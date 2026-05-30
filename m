Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB926F288;
	Sat, 30 May 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160472; cv=none; b=fzKdLJ5lk+Yt5eDPLgor2fF+mpAqzSez236qs7JHK6PJ4xkAfHQwZdgy7EK8R59X1o+rW2UROnpnCl0fqUJM8ehc+9lXdFEJIqVa4IpGyqPNUb/IELHvUD7FTSt/yinkg1xczaJ8OPFPsJwzeZPRTWphDgyFxX8C6ltvxNNWotw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160472; c=relaxed/simple;
	bh=eKdOn43tAY1OSF3B9lntUVAgbLbknoxleMN+zYHX6qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2mTskwwU8vUGK8z7dtIpkqIAXBUrQ5nEwvENzQe5jFRUiL6xUkz2DZHiE6wZbHLWcKKERGuqD4OZzbrkqo1JXeRAPqr3KgfKgEx2VyAdU4a3wSmN4ITDa4WcTe6VKjAdkim3xHvS6T5kWjKpLV2M/zwX/Kv5Twj+y7xaMMbY+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teEDH9OM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teEDH9OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6641F00893;
	Sat, 30 May 2026 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160471;
	bh=r9Tg3Lw1F2wbgxteTqA4ZYqO32dV9c6+/6NUZBcNcEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teEDH9OMMcakzTd1gQNAKWW7ve6b54RkEAsR1MEzzs/Las588SmU8yk+HcNZBr4sk
	 axVbIBJZwqNflopb2GXb8KfsnT17gKUZERuYAy3N4rh6fnLX46p98DIjEiXnLzXJap
	 VCVxuvF8rtB7HVvPAVdvo97jfT5yx18hUpPkx4sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 348/969] btrfs: fix double free in create_space_info() error path
Date: Sat, 30 May 2026 17:57:52 +0200
Message-ID: <20260530160309.966774418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 3f487be81292702a59ea9dbc4088b3360a50e837 upstream.

When kobject_init_and_add() fails, the call chain is:

create_space_info()
-> btrfs_sysfs_add_space_info_type()
-> kobject_init_and_add()
-> failure
-> kobject_put(&space_info->kobj)
-> space_info_release()
-> kfree(space_info)

Then control returns to create_space_info():

btrfs_sysfs_add_space_info_type() returns error
-> goto out_free
-> kfree(space_info)

This causes a double free.

Keep the direct kfree(space_info) for the earlier failure path, but
after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
the kobject release callback handle the cleanup.

Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
CC: stable@vger.kernel.org # 6.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -290,7 +290,7 @@ static int create_space_info(struct btrf
 
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)


