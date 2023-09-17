Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023036FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1CBC433C7;
	Sun, 17 Sep 2023 20:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982314;
	bh=Ie9x39uNWqJuutV98pWevYqwgPrZv+F5ustRNNHFkZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ju/Hw7u3LDnb2S0CPikE6um9SVF5rXGYNszbx5D85zxHC2qZWq9UN6FfS74L7czeF
	 6NNM+Gx1wfy0HmhAE6oPbX0L1RenTseUkxmyO3BXB1bVMgq1/RfPMbhoiWNmxAjp5S
	 /ZPz+/OpAGmUqJo08b3J9RGc/fazrKdQODC0Mkmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/511] md/raid0: Fix performance regression for large sequential writes
Date: Sun, 17 Sep 2023 21:10:15 +0200
Message-ID: <20230917191118.365329960@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 319ff40a542736d67e5bce18635de35d0e7a0bff ]

Commit f00d7c85be9e ("md/raid0: fix up bio splitting.") among other
things changed how bio that needs to be split is submitted. Before this
commit, we have split the bio, mapped and submitted each part. After
this commit, we map only the first part of the split bio and submit the
second part unmapped. Due to bio sorting in __submit_bio_noacct() this
results in the following request ordering:

  9,0   18     1181     0.525037895 15995  Q  WS 1479315464 + 63392

  Split off chunk-sized (1024 sectors) request:

  9,0   18     1182     0.629019647 15995  X  WS 1479315464 / 1479316488

  Request is unaligned to the chunk so it's split in
  raid0_make_request().  This is the first part mapped and punted to
  bio_list:

  8,0   18     7053     0.629020455 15995  A  WS 739921928 + 1016 <- (9,0) 1479315464

  Now raid0_make_request() returns, second part is postponed on
  bio_list. __submit_bio_noacct() resorts the bio_list, mapped request
  is submitted to the underlying device:

  8,0   18     7054     0.629022782 15995  G  WS 739921928 + 1016

  Now we take another request from the bio_list which is the remainder
  of the original huge request. Split off another chunk-sized bit from
  it and the situation repeats:

  9,0   18     1183     0.629024499 15995  X  WS 1479316488 / 1479317512
  8,16  18     6998     0.629025110 15995  A  WS 739921928 + 1016 <- (9,0) 1479316488
  8,16  18     6999     0.629026728 15995  G  WS 739921928 + 1016
  ...
  9,0   18     1184     0.629032940 15995  X  WS 1479317512 / 1479318536 [libnetacq-write]
  8,0   18     7059     0.629033294 15995  A  WS 739922952 + 1016 <- (9,0) 1479317512
  8,0   18     7060     0.629033902 15995  G  WS 739922952 + 1016
  ...

  This repeats until we consume the whole original huge request. Now we
  finally get to processing the second parts of the split off requests
  (in reverse order):

  8,16  18     7181     0.629161384 15995  A  WS 739952640 + 8 <- (9,0) 1479377920
  8,0   18     7239     0.629162140 15995  A  WS 739952640 + 8 <- (9,0) 1479376896
  8,16  18     7186     0.629163881 15995  A  WS 739951616 + 8 <- (9,0) 1479375872
  8,0   18     7242     0.629164421 15995  A  WS 739951616 + 8 <- (9,0) 1479374848
  ...

I guess it is obvious that this IO pattern is extremely inefficient way
to perform sequential IO. It also makes bio_list to grow to rather long
lengths.

Change raid0_make_request() to map both parts of the split bio. Since we
know we are provided with at most chunk-sized bios, we will always need
to split the incoming bio at most once.

Fixes: f00d7c85be9e ("md/raid0: fix up bio splitting.")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20230814092720.3931-2-jack@suse.cz
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index eca0022588c6d..b1df1877c864b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -640,7 +640,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		raid0_map_submit_bio(mddev, bio);
 		bio = split;
 	}
 
-- 
2.40.1



