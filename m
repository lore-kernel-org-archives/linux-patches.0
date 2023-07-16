Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C08F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E443C433C7;
	Sun, 16 Jul 2023 20:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539385;
	bh=PCvQDR+/kKuLY05zJi2ZYIZBuBuP4+tg31evnloapVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQu/sNLqQjaiMzSPUvbeTuc3yR13KddokUEdu4NnsIP8FABPBV8eswLUw9KgsvbXf
	 pXNMlOFyrUyu3JBNnEfpN8MlYnq7lwvuCv1/JnqhEbOiBCcsvC3z4P+AXZ8ePUDHWh
	 43M1doVOB7FbdWT66LZv3sKbXRqkGEyJuPHqUtSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 760/800] btrfs: reinsert BGs failed to reclaim
Date: Sun, 16 Jul 2023 21:50:13 +0200
Message-ID: <20230716195006.798089564@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naota@elisp.net>

commit 7e27180994383b7c741ad87749db01e4989a02ba upstream.

The reclaim process can temporarily fail. For example, if the space is
getting tight, it fails to make the block group read-only. If there are no
further writes on that block group, the block group will never get back to
the reclaim list, and the BG never gets reclaimed. In a certain workload,
we can leave many such block groups never reclaimed.

So, let's get it back to the list and give it a chance to be reclaimed.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1837,6 +1837,8 @@ void btrfs_reclaim_bgs_work(struct work_
 		}
 
 next:
+		if (ret)
+			btrfs_mark_bg_to_reclaim(bg);
 		btrfs_put_block_group(bg);
 
 		mutex_unlock(&fs_info->reclaim_bgs_lock);


