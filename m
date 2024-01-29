Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC8161B63;
	Mon, 29 Jan 2024 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548355; cv=none; b=KhZrPdpCBtQn+SK2wj1AMn9SQt3nwiroLa7ssjQ/s2mlXjYwvO+h2H4D5YLHOT6sMYwrJ3RqGgPe2N3QPg6PV3Hu8MAn2vf6RqR8kGFScYsl74S95Kazt6UPx/TRdRwTZvzCWT/F2wvXt3ncylWZ6exE/2lRPEYQLMIGEfjQStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548355; c=relaxed/simple;
	bh=8adTff1bp46qknfGYkDavytLZvJUhpVH7Fl21OW6jh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQQ5SLrsGa/e63jubkUlr/GBigtliw8GvBLIJlfA9ay17wrGUYA6NPXQCFR9Olb5GaCX351SW1Ulng9oEpvW/35mGUX0UDu9zxcFqL2koXR6uV6ziO7fUtzksLTg/Z2JEaxpb2EG1o85LSJLv2NSWOwq2DNREHlX5OhB3XqMJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjqUu4yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjqUu4yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2208C433F1;
	Mon, 29 Jan 2024 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548354;
	bh=8adTff1bp46qknfGYkDavytLZvJUhpVH7Fl21OW6jh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjqUu4yuy7are70TyI+z2KR96PTgqRE2DfBd/n4CkHNHaP6acdk7zw61bzYEchF3Y
	 8Cc+mfmRPNHIlG8duRxSoEThWk6jQgDWIyaL3OB33DKBCpl5y7H2wwjOI2LQLUyR5+
	 7q6mb9nXw728HyymxSAmo0Hljjd9z+9DWR7BvcfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+be14ed7728594dc8bd42@syzkaller.appspotmail.com,
	syzbot+c563a3c79927971f950f@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 116/185] btrfs: ref-verify: free ref cache before clearing mount opt
Date: Mon, 29 Jan 2024 09:05:16 -0800
Message-ID: <20240129170002.324860441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -883,8 +883,10 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
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
 
@@ -1015,8 +1017,8 @@ int btrfs_build_ref_tree(struct btrfs_fs
 		}
 	}
 	if (ret) {
-		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 		btrfs_free_ref_cache(fs_info);
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 	}
 	btrfs_free_path(path);
 	return ret;


