Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF426FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9D2C433C7;
	Sun, 17 Sep 2023 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983199;
	bh=TwOMnQnrMPnoJjSaanTpNQi3cj/FTTk+LBqkIZxHzbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IG8oHKtEcmc2xON8xAAUafa6qkxZDS2i/+hKbjEWUpJJs0N1ZN9Dqo1+Q3G8Mza7E
	 4A7B3GX2N/PFmQ2DCsNxwYY5ngBM1vmuJ3Ix5NT0coP4/lS0ZJ0jnPQzxqoCgTk7ru
	 pk3G1JaH6L6VDfzGfCdYcYHBR+ftzgupP9rlDi14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 474/511] btrfs: free qgroup rsv on io failure
Date: Sun, 17 Sep 2023 21:15:01 +0200
Message-ID: <20230917191125.189579279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit e28b02118b94e42be3355458a2406c6861e2dd32 upstream.

If we do a write whose bio suffers an error, we will never reclaim the
qgroup reserved space for it. We allocate the space in the write_iter
codepath, then release the reservation as we allocate the ordered
extent, but we only create a delayed ref if the ordered extent finishes.
If it has an error, we simply leak the rsv. This is apparent in running
any error injecting (dmerror) fstests like btrfs/146 or btrfs/160. Such
tests fail due to dmesg on umount complaining about the leaked qgroup
data space.

When we clean up other aspects of space on failed ordered_extents, also
free the qgroup rsv.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3226,6 +3226,13 @@ out:
 			btrfs_free_reserved_extent(fs_info,
 					ordered_extent->disk_bytenr,
 					ordered_extent->disk_num_bytes, 1);
+			/*
+			 * Actually free the qgroup rsv which was released when
+			 * the ordered extent was created.
+			 */
+			btrfs_qgroup_free_refroot(fs_info, inode->root->root_key.objectid,
+						  ordered_extent->qgroup_rsv,
+						  BTRFS_QGROUP_RSV_DATA);
 		}
 	}
 


