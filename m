Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0AC8F6A
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D27C433C9;
	Sun, 16 Jul 2023 20:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540529;
	bh=iYTekjNKkmEGDKBmB09O++cqqZm4w0ktLimgiNwIHfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7m2dsDY4sjnXNbX8ohZjdVUeqICuRvGEaYrwKeb5upMJYuT6t6adQrTubIhpvqjK
	 c2nn6cQA+e9QWjRMdJPifCUtQR3WLT0tsgmGYt+M6I49vFS8d62sMfHwFFSEulCvMC
	 /gbEZLIx2RQ/rwerpSYRG61QyLgghnhtm08J6WIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	"xiahong.bao" <xiahong.bao@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/591] media: amphion: drop repeated codec data for vc1l format
Date: Sun, 16 Jul 2023 21:48:54 +0200
Message-ID: <20230716194934.137221600@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 668ee1a3a1870381225002c246972419b98e4253 ]

For format V4L2_PIX_FMT_VC1_ANNEX_L,
the codec data is replaced with startcode,
and then driver drop it, otherwise it may led to decoding error.

It's amphion vpu's limitation

Driver has dropped the first codec data,
but need to drop the repeated codec data too.

Fixes: e670f5d672ef ("media: amphion: only insert the first sequence startcode for vc1l format")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Tested-by: xiahong.bao <xiahong.bao@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_malone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index ae094cdc9bfc8..36e563d29621f 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1317,6 +1317,8 @@ static int vpu_malone_insert_scode_vc1_l_seq(struct malone_scode_t *scode)
 	int size = 0;
 	u8 rcv_seqhdr[MALONE_VC1_RCV_SEQ_HEADER_LEN];
 
+	if (vpu_vb_is_codecconfig(to_vb2_v4l2_buffer(scode->vb)))
+		scode->need_data = 0;
 	if (scode->inst->total_input_count)
 		return 0;
 	scode->need_data = 0;
-- 
2.39.2



