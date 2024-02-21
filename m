Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD38555E5E;
	Wed, 21 Feb 2024 13:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523880; cv=none; b=tJ7EBuPnYR7O92Rx9xr9LcDVTtNc79yn4eDiY5QRWxgsNtpU7G7L2n0wjFPSnrns0bzbLpboHRmD2eppGcsvq2PopC5Se2IGxueRpR84ZkTOTvnvxqUs1srQFH8Em4yqoLLJdxEax5gVHx35JoY2KshpfHNoB1hwOQRV0PHq+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523880; c=relaxed/simple;
	bh=L4vv/55q8Ag7M7B7FO34vE123/DIXT2m4oGG3xA/+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6gDZQjGsxktOeH7cVMS3gWdX9mmRs5RPOTUsK5KaKUhFx5M3LpTCW63S9fb27oVwwyvWtyEPIpDou98yTKuNjfHnxN4FtY1fD1uKqgcAP2ZKbyGfGht4x9SGxWGRQargWLQA6WR4tlWySj0olq3HVSVvXHa/WytwM5jQa2zBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yn2ar327; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yn2ar327"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EB5C433F1;
	Wed, 21 Feb 2024 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523880;
	bh=L4vv/55q8Ag7M7B7FO34vE123/DIXT2m4oGG3xA/+VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yn2ar327Regr/EHTiCxJXz0AvoLuukHQ2xpzStXqNN9X8qDiafj4AzaHfVwd3tdLZ
	 gL1CPP/i72GpO2B/OMdC+XYpl0y64veF4ZlE5PgiNYhW/LuwbQT+deJsuEYWksa+G/
	 PtNareIo6YPmTqY3zIDw/KzEghiKKARLK1IxIqcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com,
	syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 062/379] btrfs: ref-verify: free ref cache before clearing mount opt
Date: Wed, 21 Feb 2024 14:04:01 +0100
Message-ID: <20240221125956.746694296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -899,8 +899,10 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
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
 
@@ -1029,8 +1031,8 @@ int btrfs_build_ref_tree(struct btrfs_fs
 		}
 	}
 	if (ret) {
-		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 		btrfs_free_ref_cache(fs_info);
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 	}
 	btrfs_free_path(path);
 	return ret;


