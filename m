Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53B3BB9F1;
	Sat, 17 Oct 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258218; cv=none; b=YzT86ScHQNqsgMWwyFJHIemKz23Xs7Eo6cGYOsfLLdOR5AwVozPbkhUXA8H6SdPJOfETszM4SFcyHuUfrH94VBXjnmc8V5CoS247R5eDMYGC5ZYMDkdjRQHVVbySM2zlep18W5szP6WjX4LbUc2thtggzN7uMJef3+UC9ZQjik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258218; c=relaxed/simple;
	bh=0xtWfMqYLjJ0DYJeN1FJh/MNDJA7k/+y+SDIJ1S52Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk0xftDwd9vqfqG5axm8k49zRRgMmVFeqEkxLaJadxst8eiQw+dSA4GE/Lb0Wt4AyN4fPhf7+WK3OVpu2lAYn52QJN8xaq4bzCioHJo+FtZl9xDjb0kK2EilI/L9CXcI9fq1IWs0bKaZZTMDcuhXtyAaJn5fZZt/FJCO+Koyjx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXuJ6Jap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXuJ6Jap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA01F000C5;
	Sat, 17 Oct 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258217;
	bh=lLDMM5W/v8jwrTLVhOFLevpIc4hfdcc84sKcHz4H9bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXuJ6Jap54ST92a5tCXaIw7kphZjwFJvC7XoW+jKq9bNo9gKtOz0PMTshQ4Roxzfd
	 NAjNHLK/tcsR/rd+0vftELq+x9uo0kd8F5qgKD+EXP0uDJahsAPGPP982QwKebvm6R
	 3xfTGz8I88u9PIfy3JKRLk/ObVlE1ZRk+4rzVaCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0812/1674] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Sat, 17 Oct 2026 17:51:24 +0200
Message-ID: <20261017160451.965332579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 3db4404435397a345431b45f57876a3df133f3b4 ]

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/linux-raid/20250306094938.48952-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ca9ae89c6d1dc..08f59c1ad2751 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1653,11 +1653,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
-- 
2.53.0



