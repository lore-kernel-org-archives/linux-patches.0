Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDCD15705C;
	Mon, 29 Jan 2024 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548579; cv=none; b=JjrqQx3V8703GYJ9qkq0zbIpDI1On2SbV/P5fPUu1aukmDKdWj+E6nB2OB7L9KoHt4l+uPumi4zq2OlUHCeS7I+eNPF6ym13kmSrD3bZPoTfGHTib4C5AVY55hwDosPTeXGo0CEbPJl+9MxfYxQFUyVfLahdNAiX4SP7eP+VeC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548579; c=relaxed/simple;
	bh=Yj79Bw1Sn1N8EkgSIzY7NnKQ8dv9PPxSM/8yAefEd8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/eCrjsBhf9gc1x1FBtpC/FYQ7GgbN5ummj4YNheID6U7Y7NcO8gnqTIeLT54OuvIztpYkZgtOyaywKQxVmKEKq06ZRDCezZy4su2zGWv4OJJ7FNE+C4j2f7YCjl8oi16fWg+I678N1OScpX/knjqmmXWbjWvfI/prxQQ0uIois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgRSyCc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgRSyCc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5FDC433C7;
	Mon, 29 Jan 2024 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548579;
	bh=Yj79Bw1Sn1N8EkgSIzY7NnKQ8dv9PPxSM/8yAefEd8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgRSyCc9qQ24FRJlvnrHoaEYZK+jWgK0m9W/ERyxXM12oWGsSS7/u+WZ2F1eObhZs
	 FySc/O9A5cUZp1j54qC8h5VePUrx9GAHUS676mp31SGXDmwaJmq6zxtsZ7C0cjlvWR
	 HXM07DtQxz2bF2YGeIPIRo1H89HWGkduv9XA4Jt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com,
	syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 233/331] btrfs: ref-verify: free ref cache before clearing mount opt
Date: Mon, 29 Jan 2024 09:04:57 -0800
Message-ID: <20240129170021.690891405@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -886,8 +886,10 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
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


