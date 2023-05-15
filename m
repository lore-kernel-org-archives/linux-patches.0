Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD5FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1904CC433D2;
	Mon, 15 May 2023 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171310;
	bh=pIPvubYYlFwqIDsTuQne2PmSoCPFylk2EjmZ1tbL87E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQgSlzQfWHif7+eZS/9G5samBmCMahzeXoAj08MzOQ1/RiNp6exKnn+EvTBXnLn0r
	 /E2EogtqVY7o3YRIfm3f9OKH16oIyTHvBddn8xrKXhDD1Nc8QYZcaJYgiR940DOWq8
	 fZl2YLXHAflJgn3xYVekrPSoVI3V4WV4RD1zzP/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 138/242] btrfs: zoned: zone finish data relocation BG with last IO
Date: Mon, 15 May 2023 18:27:44 +0200
Message-Id: <20230515161726.043531246@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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
@@ -3264,6 +3264,9 @@ int btrfs_finish_ordered_io(struct btrfs
 		btrfs_rewrite_logical_zoned(ordered_extent);
 		btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
 					ordered_extent->disk_num_bytes);
+	} else if (btrfs_is_data_reloc_root(inode->root)) {
+		btrfs_zone_finish_endio(fs_info, ordered_extent->disk_bytenr,
+					ordered_extent->disk_num_bytes);
 	}
 
 	btrfs_free_io_failure_record(inode, start, end);


