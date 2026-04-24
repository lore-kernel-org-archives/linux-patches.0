Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208F3290A5;
	Fri, 24 Apr 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038035; cv=none; b=dvtPq3fKKP1qeVHJa26S0OJsP9S1ed/9CiXtSudAgMBuRpSH0S4gBfTHBhNBfGSUdkwiqofsatcjiO7GGOaoIM0YO1VAaWabeOeC9fj2KTh13rP52WjNkhp3vUMS1crLeEYzSNWpNL4Aqleg17FibS47Yf2KPXk395jXXa/1coQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038035; c=relaxed/simple;
	bh=ndJsUsSwYirsRIkSg6jmyNl+aU4SoSI9NhQzmDo5GnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzuG2QdIUwT/Gt9BcHif5kJdAArBxl3pSYhCdcmRDp7DfD3IyfHR1JkfzIPYK/VB+A2R0KsTzpm3Kr8OaawXyxSXqnZe6th+TuLuNQT+FbnW3AFvgGEcy4M3rODKFTkhp4g1gfZcSo697hz44i2rkcXQtxa+EZWYE6t34+APv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzfDl73M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzfDl73M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1AEC19425;
	Fri, 24 Apr 2026 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038035;
	bh=ndJsUsSwYirsRIkSg6jmyNl+aU4SoSI9NhQzmDo5GnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzfDl73M3PSFf65Qz7efr2ycbDgMNC/cZudjwEpIZ+sX+dsRzrMYdJhZBgtHhIjtb
	 lluJKxu0XOG5fE7XA4JN1921Pc363PrNQ8pHfyzGPFNIrZNdNmDcNVN02VU7UkfRwP
	 oNKluT4+glaAJbVdo5QAn8eENHbggbxQZKyalRdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Ian Dall <ian@beware.dropbear.id.au>
Subject: [PATCH 6.6 166/166] md/raid1: fix data lost for writemostly rdev
Date: Fri, 24 Apr 2026 15:31:20 +0200
Message-ID: <20260424132607.802962503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

commit 93dec51e716db88f32d770dc9ab268964fff320b upstream.

If writemostly is enabled, alloc_behind_master_bio() will allocate a new
bio for rdev, with bi_opf set to 0. Later, raid1_write_request() will
clone from this bio, hence bi_opf is still 0 for the cloned bio. Submit
this cloned bio will end up to be read, causing write data lost.

Fix this problem by inheriting bi_opf from original bio for
behind_mast_bio.

Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
Reported-and-tested-by: Ian Dall <ian@beware.dropbear.id.au>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220507
Link: https://lore.kernel.org/linux-raid/20250903014140.3690499-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1119,7 +1119,7 @@ static void alloc_behind_master_bio(stru
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
-	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
+	behind_bio = bio_alloc_bioset(NULL, vcnt, bio->bi_opf, GFP_NOIO,
 				      &r1_bio->mddev->bio_set);
 	if (!behind_bio)
 		return;


