Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A663B66B39;
	Tue, 23 Jan 2024 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971670; cv=none; b=DLpUxZJvzuKYsuzvfXG66Vq9/WVaVuk6mjKA+fGUTOfasRtcQMMhtPfnTlUl69vtvNM+jz+UFev8pQ0rpKouFrNUASoyW0YAV/1tRWNWqLEWHKCPpZI/McIr5D5rslLXBGyW+85qogPkEljK0KxNUhdWreqNJTDSuAIouvBnXP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971670; c=relaxed/simple;
	bh=nJM3ArNqlfA0RJPcCQUtFxV1zNBI6nOd3j/O5asE63c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ljm0Q+dwgzVxC+BYVq8PFIAjACKowqMrhUM3dDFQCczDiz1EjFgkXP87ddJZH74pY6stGOkvBu9+if8qXxk00dztMyBSw0kSZOVeMp1ottkAlDMPUpnKULY2oaTslJ2ZLtK1KzGc5BoODDnqyuyIlzhj8VxcQvi/S3EC1cFbZCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDj3YluD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDj3YluD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA5FC433F1;
	Tue, 23 Jan 2024 01:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971670;
	bh=nJM3ArNqlfA0RJPcCQUtFxV1zNBI6nOd3j/O5asE63c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDj3YluDzUih9BM+wM7dxfOxR5HqEW7KZVMwj4ek2ZheyeQvQh+BTKYlg5AgH+KM+
	 zxMcelj/D1QS5DB/THbRUN+bRQn7U0nEJgOBlrQI4Xt5ivsm5Kkh2FtZvaSpz1H2jJ
	 eqK5DzIQxe+mfMNBPdHA8CZa4gUQ3q8oGVcUOH6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.1 293/417] md: bypass block throttle for superblock update
Date: Mon, 22 Jan 2024 15:57:41 -0800
Message-ID: <20240122235801.979383349@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Junxiao Bi <junxiao.bi@oracle.com>

commit d6e035aad6c09991da1c667fb83419329a3baed8 upstream.

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and will be reverted in next patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Cc: stable@vger.kernel.org # v5.19+
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231108182216.73611-1-junxiao.bi@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -963,9 +963,10 @@ void md_super_write(struct mddev *mddev,
 		return;
 
 	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
-			       1,
-			       REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
-			       GFP_NOIO, &mddev->sync_set);
+			      1,
+			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
+				  | REQ_PREFLUSH | REQ_FUA,
+			      GFP_NOIO, &mddev->sync_set);
 
 	atomic_inc(&rdev->nr_pending);
 


