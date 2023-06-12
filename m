Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96448107A2
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B533C433D2;
	Mon, 12 Jun 2023 10:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565841;
	bh=gQGaPDgWsb+Epxj7TQ++nTbbJhV5jGXReNdHkDhpiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG3uw76KEoTEUdYQgemVGT0JXEi85fBDPYis5cwS7lysXcYcXB9YWO8gUCN10Wcgm
	 J4FQw8inzEXMnuvca9tY0ivQ8rZ4TjrsYaoxgFRd8cJDEoTcv80JuvIGf/gfA0RqOq
	 PRuzbdlQnPR6hMFnW9v6qaJz7mgJ7rO9u28i431Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 5.4 02/45] block/blk-iocost (gcc13): keep large values in a new enum
Date: Mon, 12 Jun 2023 12:25:56 +0200
Message-ID: <20230612101654.735115280@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit ff1cc97b1f4c10db224f276d9615b22835b8c424 upstream.

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided:
  VTIME_PER_SEC_SHIFT     = 37,
  VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
  ...
  AUTOP_CYCLE_NSEC        = 10LLU * NSEC_PER_SEC,
the named type is unsigned long.

This generates warnings with gcc-13:
  block/blk-iocost.c: In function 'ioc_weight_prfill':
  block/blk-iocost.c:3037:37: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int'

  block/blk-iocost.c: In function 'ioc_weight_show':
  block/blk-iocost.c:3047:34: error: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int'

So split the anonymous enum with large values to a separate enum, so
that they don't affect other members.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org
Cc: linux-block@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221213120826.17446-1-jirislaby@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-iocost.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -248,7 +248,9 @@ enum {
 
 	/* 1/64k is granular enough and can easily be handled w/ u32 */
 	HWEIGHT_WHOLE		= 1 << 16,
+};
 
+enum {
 	/*
 	 * As vtime is used to calculate the cost of each IO, it needs to
 	 * be fairly high precision.  For example, it should be able to


