Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC121ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF54C433C8;
	Tue, 25 Jul 2023 11:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284115;
	bh=bI7w2jO6T9iXGj+U4OdYtSctNP3OGYp0WAORTYbTihA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKijGzr/UQp4iGnYC4XO1PtRWagSx98zDAhJR1ye1tnfQ82mFB6+bsFRTip7cqCZ4
	 Eo7haeYKCp1AjAexdrzsY9mz2G/jl3F8cU6BoJaXTnD7wIIxUOO722gZxsLKU8+BLq
	 EHWuAqPuy1fXXMsK3NUDzWcbdx4ncTJYhXRmXF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/509] media: venus: helpers: Fix ALIGN() of non power of two
Date: Tue, 25 Jul 2023 12:42:59 +0200
Message-ID: <20230725104604.740823113@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

[ Upstream commit 927e78ac8bc58155316cf6f46026e1912bbbbcfc ]

ALIGN() expects its second argument to be a power of 2, otherwise
incorrect results are produced for some inputs. The output can be
both larger or smaller than what is expected.

For example, ALIGN(304, 192) equals 320 instead of 384, and
ALIGN(65, 192) equals 256 instead of 192.

However, nestling two ALIGN() as is done in this case seem to only
produce results equal to or bigger than the expected result if ALIGN()
had handled non powers of two, and that in turn results in framesizes
that are either the correct size or too large.

Fortunately, since 192 * 4 / 3 equals 256, it turns out that one ALIGN()
is sufficient.

Fixes: ab1eda449c6e ("media: venus: vdec: handle 10bit bitstreams")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5ca3920237c5a..5fdce5f07364e 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -917,8 +917,8 @@ static u32 get_framesize_raw_yuv420_tp10_ubwc(u32 width, u32 height)
 	u32 extradata = SZ_16K;
 	u32 size;
 
-	y_stride = ALIGN(ALIGN(width, 192) * 4 / 3, 256);
-	uv_stride = ALIGN(ALIGN(width, 192) * 4 / 3, 256);
+	y_stride = ALIGN(width * 4 / 3, 256);
+	uv_stride = ALIGN(width * 4 / 3, 256);
 	y_sclines = ALIGN(height, 16);
 	uv_sclines = ALIGN((height + 1) >> 1, 16);
 
-- 
2.39.2



