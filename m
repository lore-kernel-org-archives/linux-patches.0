Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74933BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2AEC433EF;
	Tue,  7 Mar 2023 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215738;
	bh=EDnOlfdMO9WC1yJ+tYfhzS6owgNkEBOFpkRuKUwlRNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KePETZ+0ui/UuJzhjafqwkW1wvxmjC3qIkZbfSBWYC7ozjCr3wJ1khzXRkYnkyRfb
	 N8R90fYJKOR9N+Px02OSKVd2ARN4yBG76VQInpwZTD3e8mk3xX6bgWtKPYvMAzad7d
	 jKgKoathu1AssPOuKfSeH3kr0bkgw6fwDPX7RLKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/567] media: v4l2-jpeg: correct the skip count in jpeg_parse_app14_data
Date: Tue,  7 Mar 2023 18:01:33 +0100
Message-Id: <20230307165921.364105958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 41959c4f973b837a12061b84d3a436fc64c73a30 ]

The curr pointer has advanced 14 bytes in jpeg_parse_app14_data.
1. jpeg_get_word_be(stream), it goes forward 2 bytes.
2. jpeg_skip(stream, 11), it goes forward 11 bytes.
3. jpeg_get_byte(stream), it goes forward 1 bytes.

so the remain bytes of this segment should be (lp - 2 - 11 - 1),
but not (lp - 2 - 11).

if driver skip 1 extra bytes, the following parsing may go wrong.

Fixes: b8035f7988a8 ("media: Add parsing for APP14 data segment in jpeg helpers")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-jpeg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-jpeg.c b/drivers/media/v4l2-core/v4l2-jpeg.c
index c2513b775f6a7..75c2af763d55e 100644
--- a/drivers/media/v4l2-core/v4l2-jpeg.c
+++ b/drivers/media/v4l2-core/v4l2-jpeg.c
@@ -474,7 +474,7 @@ static int jpeg_parse_app14_data(struct jpeg_stream *stream,
 	*tf = ret;
 
 	/* skip the rest of the segment, this ensures at least it is complete */
-	skip = lp - 2 - 11;
+	skip = lp - 2 - 11 - 1;
 	return jpeg_skip(stream, skip);
 }
 
-- 
2.39.2



