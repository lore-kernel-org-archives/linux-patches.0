Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36263922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1D9C433EF;
	Wed,  7 Jun 2023 20:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171555;
	bh=/aQHJrkPZV+ML/j/omdPFfLwhiWitT9bbB2gtn71rlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEBBdwsjYBmfXH7ZOfKrU5yxMS/RQmKyHZ6UDSEIXxqb+6zC5dx3cY7NYo+wotCYL
	 kEqiMtn0Xd+JLGXEmc0eUKYXCBvjKen0agDwGYT79FpZLhnZ/aXPDJeJlxBnajC4yq
	 oZgLVRaI3nts0FnMvjOunFSA/LBSEwRsrpMYsoNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YongSu Yoo <yongsuyoo0215@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/159] media: dvb_demux: fix a bug for the continuity counter
Date: Wed,  7 Jun 2023 22:16:06 +0200
Message-ID: <20230607200905.749825281@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YongSu Yoo <yongsuyoo0215@gmail.com>

[ Upstream commit 7efb10d8dc70ea3000cc70dca53407c52488acd1 ]

In dvb_demux.c, some logics exist which compare the expected
continuity counter and the real continuity counter. If they
are not matched each other, both of the expected continuity
counter and the real continuity counter should be printed.
But there exists a bug that the expected continuity counter
is not correctly printed. The expected continuity counter is
replaced with the real countinuity counter + 1 so that
the epected continuity counter is not correclty printed.
This is wrong. This bug is fixed.

Link: https://lore.kernel.org/linux-media/20230305212519.499-1-yongsuyoo0215@gmail.com

Signed-off-by: YongSu Yoo <yongsuyoo0215@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_demux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 5fde1d38b3e34..80b495982f63c 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -125,12 +125,12 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 
 	cc = buf[3] & 0x0f;
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
-	feed->cc = cc;
 	if (!ccok) {
 		set_buf_flags(feed, DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED);
 		dprintk_sect_loss("missed packet: %d instead of %d!\n",
 				  cc, (feed->cc + 1) & 0x0f);
 	}
+	feed->cc = cc;
 
 	if (buf[1] & 0x40)	// PUSI ?
 		feed->peslen = 0xfffa;
@@ -310,7 +310,6 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 
 	cc = buf[3] & 0x0f;
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
-	feed->cc = cc;
 
 	if (buf[3] & 0x20) {
 		/* adaption field present, check for discontinuity_indicator */
@@ -346,6 +345,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		feed->pusi_seen = false;
 		dvb_dmx_swfilter_section_new(feed);
 	}
+	feed->cc = cc;
 
 	if (buf[1] & 0x40) {
 		/* PUSI=1 (is set), section boundary is here */
-- 
2.39.2



