Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23443524C2;
	Thu, 30 Nov 2023 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWaGYQsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1209C433C9;
	Thu, 30 Nov 2023 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361563;
	bh=0SlmiANb8pxM4vEWBvQfMuLZc9UTI/6yPx4v66GF1ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWaGYQsKjKZsB1QXY7bogCekVwUacct6VNN5Ipd+J34DZ6QZuoFq66kTRHHIHbsT/
	 ainogiXovvL5u739WU0DHSEDGDo0Ero3ienfJnXXxTncWhWXb4uW3L0wlV2rV6S0DO
	 9WS2VzVvV/IkyRhEkcH7bMraEEOjk1Lmh/WaejAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
	Song Liu <song@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 6.6 071/112] md: fix bi_status reporting in md_end_clone_io
Date: Thu, 30 Nov 2023 16:21:58 +0000
Message-ID: <20231130162142.578210326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

commit 45b478951b2ba5aea70b2850c49c1aa83aedd0d2 upstream.

md_end_clone_io() may overwrite error status in orig_bio->bi_status with
BLK_STS_OK. This could happen when orig_bio has BIO_CHAIN (split by
md_submit_bio => bio_split_to_limits, for example). As a result, upper
layer may miss error reported from md (or the device) and consider the
failed IO was successful.

Fix this by only update orig_bio->bi_status when current bio reports
error and orig_bio is BLK_STS_OK. This is the same behavior as
__bio_chain_endio().

Fixes: 10764815ff47 ("md: add io accounting for raid0 and raid5")
Cc: stable@vger.kernel.org # v5.14+
Reported-by: Bhanu Victor DiCara <00bvd0+linux@gmail.com>
Closes: https://lore.kernel.org/regressions/5727380.DvuYhMxLoT@bvd0/
Signed-off-by: Song Liu <song@kernel.org>
Tested-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8669,7 +8669,8 @@ static void md_end_clone_io(struct bio *
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	orig_bio->bi_status = bio->bi_status;
+	if (bio->bi_status && !orig_bio->bi_status)
+		orig_bio->bi_status = bio->bi_status;
 
 	if (md_io_clone->start_time)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);


