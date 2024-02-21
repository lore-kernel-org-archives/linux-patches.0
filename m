Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7213D981;
	Wed, 21 Feb 2024 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525102; cv=none; b=VIP+ad0AR3eLhIlvc+VL41aF3Y4cRVnipAWiB+hHjq9vntYdHwLpB6nYOg8bX3jdmnP2tKcjldXgHnNzEpSlqVzbN5WE2ZV+/IhLfqXmS8nmU2oFiJcp1/EMCnEMp9W74yoRybmLBMAYEL2fOUJKgt+GlCxiQNmlr7doH54vik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525102; c=relaxed/simple;
	bh=ziUrVfKwJ8zlHh30i+U9xMBGfFaJQ6wWHw01sWtKuD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlFMv4/tIObOLOqhr+qovo7dR49OMw0hmkF63q3B5b/aeXZPG1snDxdXNItUVztsBkX2GnOS7V7KL9Bk8iImOtNbWo5HNq2GnkGVrLvvS1POkKpUUK7Rd8pHtGTRzPRtdBDf2afvbU6txsxpiKnhpRJLXWwFYk3z10/ADWzkKHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGgbjs9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGgbjs9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2D3C433C7;
	Wed, 21 Feb 2024 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525102;
	bh=ziUrVfKwJ8zlHh30i+U9xMBGfFaJQ6wWHw01sWtKuD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGgbjs9BKDSjade/XxmyyjHWjCBSTFq+oIhwtB3VSgkt8K6FTXLuEwMpRYvl0YpW5
	 v4s6BhgLJxMi25ofArK7Awig+k03zuEnSt8sIyfw8+AR4XzH7OivvqUqj224tTAyt7
	 FN7nTEVsC50/RB9u4fJwQkrWX6WQVwQs8GH9ajy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com,
	syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 042/267] btrfs: ref-verify: free ref cache before clearing mount opt
Date: Wed, 21 Feb 2024 14:06:23 +0100
Message-ID: <20240221125941.338276880@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit f03e274a8b29d1d1c1bbd7f764766cb5ca537ab7 upstream.

As clearing REF_VERIFY mount option indicates there were some errors in a
ref-verify process, a ref cache is not relevant anymore and should be
freed.

btrfs_free_ref_cache() requires REF_VERIFY option being set so call
it just before clearing the mount option.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Reported-by: syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com
Fixes: fd708b81d972 ("Btrfs: add a extent ref verify tool")
CC: stable@vger.kernel.org # 5.4+
Closes: https://lore.kernel.org/lkml/000000000000e5a65c05ee832054@google.com/
Reported-by: syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/0000000000007fe09705fdc6086c@google.com/
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ref-verify.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -888,8 +888,10 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 out_unlock:
 	spin_unlock(&fs_info->ref_verify_lock);
 out:
-	if (ret)
+	if (ret) {
+		btrfs_free_ref_cache(fs_info);
 		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
+	}
 	return ret;
 }
 
@@ -1018,8 +1020,8 @@ int btrfs_build_ref_tree(struct btrfs_fs
 		}
 	}
 	if (ret) {
-		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 		btrfs_free_ref_cache(fs_info);
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 	}
 	btrfs_free_path(path);
 	return ret;


