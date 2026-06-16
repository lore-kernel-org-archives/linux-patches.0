Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E353C276B;
	Tue, 16 Jun 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632456; cv=none; b=CF4pbd44GvUzZ1aRsa5VhzqX9woQq5vQz0rsgP7EWVfrETjauxlGtadaZ/8KenyWH8v1NFoHmuaoc+M54pLznJbULd4/l7cR0BMGWcAwMnJhlncd/cUdi9txkMsRT66iOxOhe9tDoVq8P0gY2pfTSBVy3PPzWlxia7szmNCT4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632456; c=relaxed/simple;
	bh=eJqeyeh06dIUUFvtj9DnDjCgJk1ROtGGAFM4zx9eOtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am5AdY1cs85cLSL97J0CgtYKuZdDzBmQdWGWX8gQEkxbjsLjk6Juqt0+bAfIZD08V6241jVvy/0RxZN4VzDMWZbIFhn+Y+J6HDNg5+ckPfZpo1N7fgA1nnxvp2Twb2pEblQvrYZhWIxz9p9uHuf7cBKSdcqvC7/22uSlGwNYoCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C66QrApH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C66QrApH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D851F000E9;
	Tue, 16 Jun 2026 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632455;
	bh=V5zzUmtiZm7sCatfObgZxN6AMp5Ia0W+UIgRdJuGvkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C66QrApHsxPbtZ+SBiulu28htEgNXQ0FemY/ZS7AMVAvG2+i/aLM3I4sBAtdukosl
	 3Sq/SjImaN2FlBbSG9QFbwPQLksXIaNJfjSG+3nLkFr63q06tVe0MKICsza5fmRv/b
	 kMypEP6q/JA04ImMRgFwsTj1brS+BJ3YSEwcgtq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 415/522] btrfs: fix double free in create_space_info_sub_group() error path
Date: Tue, 16 Jun 2026 20:29:22 +0530
Message-ID: <20260616145145.448499093@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -260,10 +260,8 @@ static int create_space_info_sub_group(s
 	sub_group->subgroup_id = id;
 
 	ret = btrfs_sysfs_add_space_info_type(sub_group);
-	if (ret) {
-		kfree(sub_group);
+	if (ret)
 		parent->sub_group[index] = NULL;
-	}
 	return ret;
 }
 


