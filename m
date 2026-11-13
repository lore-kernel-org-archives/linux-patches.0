Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585435;
	b=g15Tz5wqvRiiZ3EnPlKZy3yRvHasXOJHGEUrIP1crpdfCkydtwZ2TVeIinMuGnfYYMiL
	 EGVmefM47p+kmAmZZJYPVM1Ab8pVdpBRRYUGrZS6OyB0SlDu040ecBGEvs613jfgoAaYN
	 d4lgzxzMIkopbAarxs7JKQQY/d7kGd2MbcL4YVupeYSt0yizv7iOVNr12nNLbIC3q3H+Z
	 s+tfvufn7DtThBpBR5Yx8BydVKAUuc5+E1/zyCGi4TxDAwB3ocvGRDUXUlPeutQN26+NI
	 Bon2mc7+XWpXZxC9UN4axucKnQpFyvOAzBKTSxIpA3oJ5K65JOrqQs/1wmMN68LroYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NC5yCbB3b2Z6RWRzoxyuMOOjVIGDFeZEWQQK80oedqA=;
	b=ZMxNXSHErlTHBD6j8l9lPoGZxLqI+UoNW4mhxZqZEyEuaWT3vH/aJGttdapyyXmafxTJ
	 e1DkzK64VtHvGdY/dKKSL7JnXuD96s43FbjYiiTJ1OqznucyLhadYvZBLDJQdWU1mN3XK
	 R4w4Q+065Pjlh8NA9M1IeDKllcYjXRZw2oUNxci0omSEA+LwhK3jtxyDOr/pppvjMhGJM
	 O8JlhnytVY7Pqm6oMYdp4qRbI/VGTJV6KxuWAnhG3ckdQ46F3AAmTpNQkm2V4x9RPPAot
	 TcCYj1qKrpEi7fBXNWiIAgPISxDCzV1O0ap61JuYaAzktykCpV/oF0IdQ83dj5+tf2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1OvTo/ZK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7DA60A5BCF;
	Fri, 13 Nov 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OvTo/ZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CB21F000C5;
	Fri, 13 Nov 2026 15:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585435;
	bh=NC5yCbB3b2Z6RWRzoxyuMOOjVIGDFeZEWQQK80oedqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OvTo/ZKlcbyHOoCNpeFg9o8VrvSg+TlCIjbegZ9yo3xn1Omo/phHnc1x8VENVjRH
	 Vb7HRvYTRKRyzUI20jwdRFMEbh0J/VjA5O8BOk8FfyojoZk7+qKw3xph3lTkngf49K
	 8uR/SqzZHCVyCCWtx+enQYJ8aU1FTyYMs9KmApxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 095/507] btrfs: fix chattr failing on nodatasum files that have the compress flag
Date: Fri, 13 Nov 2026 10:46:39 -0500
Message-ID: <20261113153757.321975839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 16b8f07d1ed50d4a8da468b56484873784dd8f4a ]

Commit cf1afec09e9f ("btrfs: validate properties before setting them")
made btrfs_set_prop() validate a property before setting it. For the
compression property, the validation fails with -EINVAL when the inode
has NODATASUM.

However, chattr writes back all the flags it read from the file, and
btrfs_fileattr_set() sets the compression property whenever the new
flags include FS_COMPR_FL, even when the compression flags do not
change. A file created on a filesystem mounted with nodatasum has
NODATASUM and still inherits the compress flag from its directory. As
of now, chattr fails on such a file when it changes any other flag.

The issue can be reproduced with:

    mkfs.btrfs -f /dev/sdb
    mount -o nodatasum /dev/sdb /mnt
    mkdir /mnt/dir
    chattr +c /mnt/dir
    touch /mnt/dir/file
    chattr +A /mnt/dir/file

Before commit cf1afec09e9f ("btrfs: validate properties before setting
them"), the last command succeeds.

After that commit, it fails with EINVAL.

This patch will make btrfs_fileattr_set() leave the compression flags
and the compression property alone when the call changes neither
FS_COMPR_FL nor FS_NOCOMP_FL.

Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
CC: stable@vger.kernel.org # 7.2+
Suggested-by: Qu Wenruo <wqu@suse.com>
Assisted-by: LLM
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 576cd76ca0bf3..905b04ad0ae45 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -375,6 +375,19 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		}
 	}
 
+	/*
+	 * Callers write back the whole flag set, so only touch the compression
+	 * flags and the compression property if FS_COMPR_FL or FS_NOCOMP_FL
+	 * changes.
+	 */
+	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
+		/* 1 item for the inode */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+		goto update_flags;
+	}
+
 	/*
 	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
 	 * flag may be changed automatically if compression code won't make
-- 
2.53.0



