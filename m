Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2020DFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777D9C433EF;
	Mon, 15 May 2023 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170495;
	bh=i7/Yk3VmXsfgEgwTA2gCWxBMwtW23eC78UCJZY4r5aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+BWIH6UsT3T3xXinoCQYODCdxVl4YLoyhC3dz6N+CXTXMWX8fNAHKD7aCKXpNDBr
	 8mdA7NvT7SZVIfY36Q/JgG4jfDWnZ/Id3ycozjph1JAzWuykkdyICLEOi2J5rRKtqW
	 lZCf60D/9EquLWZuRKd1GuPW7uXkZwDXGTet+82A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 119/239] btrfs: zoned: zone finish data relocation BG with last IO
Date: Mon, 15 May 2023 18:26:22 +0200
Message-Id: <20230515161725.275552951@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <Naohiro.Aota@wdc.com>

commit f84353c7c20536ea7e01eca79430eccdf3cc7348 upstream.

For data block groups, we zone finish a zone (or, just deactivate it) when
seeing the last IO in btrfs_finish_ordered_io(). That is only called for
IOs using ZONE_APPEND, but we use a regular WRITE command for data
relocation IOs. Detect it and call btrfs_zone_finish_endio() properly.

Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3237,6 +3237,9 @@ int btrfs_finish_ordered_io(struct btrfs
 		btrfs_rewrite_logical_zoned(ordered_extent);
 		btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
 					ordered_extent->disk_num_bytes);
+	} else if (btrfs_is_data_reloc_root(inode->root)) {
+		btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
+					ordered_extent->disk_num_bytes);
 	}
 
 	btrfs_free_io_failure_record(inode, start, end);


