Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7817C15AAB0;
	Mon, 29 Jan 2024 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548356; cv=none; b=I9zuq4kuyPRMXNbhFxiZ7qyMxb3sHMBYMtFNUPWCMu65wGpjMwKxnM8E+oYiVdlIYaBOE8Vi5P6j9GVOEoM0S3oIM79Lvb/BeMQQ0plqP42VkWyIN31A1QMDBQKWTZJkCCYqv3M7JaGsP2vduSNuqDoSpUUeTGe6Lp1v8Q4ysEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548356; c=relaxed/simple;
	bh=DwqmDAiRQkErtXhGHO4WkjJmGZpANnHBQ8cqDwwWcTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ/FbmHGrYVtN7LkFf5ElJDOq58KHhIOjqiVMIelHRKjthbRyKUlk0D3gjJK5bggWDkF1FezYoc6kJV/Sh7ocbpIDq48aDRdMTmLq7WABPkOk5BUg5ox6EHA6Zc+hH1/kSI6Q1TN/SfRuqI49rt8qBCRTAyDDTRo3R/zvJCtJjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Cblnt2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Cblnt2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E9C433C7;
	Mon, 29 Jan 2024 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548356;
	bh=DwqmDAiRQkErtXhGHO4WkjJmGZpANnHBQ8cqDwwWcTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Cblnt2UnyARTfXoeZaGFDJJeTYtiMFjYrmvUvAgdFbdv4EB0ySYBJfPQ9rqTAz4C
	 /sHZCUdMBZCrl/dm7qLiCbcapQPkoObISPRo2Fhc7r21CFFL0Xx3iw56R33EaJzYuu
	 snIBhd7slq5srOzoZ7OyZ1EQEiuxNZFkya/BmU9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 118/185] btrfs: dont warn if discard range is not aligned to sector
Date: Mon, 29 Jan 2024 09:05:18 -0800
Message-ID: <20240129170002.387127904@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit a208b3f132b48e1f94f620024e66fea635925877 upstream.

There's a warning in btrfs_issue_discard() when the range is not aligned
to 512 bytes, originally added in 4d89d377bbb0 ("btrfs:
btrfs_issue_discard ensure offset/length are aligned to sector
boundaries"). We can't do sub-sector writes anyway so the adjustment is
the only thing that we can do and the warning is unnecessary.

CC: stable@vger.kernel.org # 4.19+
Reported-by: syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1209,7 +1209,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << 9);
 		start = aligned_start;


