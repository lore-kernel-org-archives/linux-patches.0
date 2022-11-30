Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC4879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50903C433D6;
	Wed, 30 Nov 2022 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834492;
	bh=OzCaS/ncy15m/HGrWUluJOVV1MGaGAVRNZxdDTVR+Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlvDMSkT1wWiUB+jG/JyGuxxBsUDFgjvDB4UNAqFSdJlh/pqZfIi8ppiamu+xfMLp
	 0AFIt6fi/fRwh76w8kaeMSPlMtktAsIOTwpB8DuAEuBwEWSHmk3zRdslSPyB7vdg3I
	 Vd4m8bTim9M/UaHtbdQlXlBmGhVVfGfBmD6b69c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 274/289] btrfs: free btrfs_path before copying subvol info to userspace
Date: Wed, 30 Nov 2022 19:24:19 +0100
Message-Id: <20221130180550.312866531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anand Jain <anand.jain@oracle.com>

commit 013c1c5585ebcfb19c88efe79063d0463b1b6159 upstream.

btrfs_ioctl_get_subvol_info() frees the search path after the userspace
copy from the temp buffer @subvol_info. This can lead to a lock splat
warning.

Fix this by freeing the path before we copy it to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3105,6 +3105,8 @@ static int btrfs_ioctl_get_subvol_info(s
 		}
 	}
 
+	btrfs_free_path(path);
+	path = NULL;
 	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
 		ret = -EFAULT;
 


