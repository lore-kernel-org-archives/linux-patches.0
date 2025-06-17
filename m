Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51420A5EA;
	Tue, 17 Jun 2025 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176322; cv=none; b=U7g0PJvnuNPEC3z64BWW7srUQmGVRE1n90VaGC7JWSf+A+GyQBYYlQn3QLE48QcrqlVx3SLUz/Lx6ZRhhu7E4bJgxmvDkGE8h1zN0Rk4KulMEOnz/nPQwL3GdE5/GBUhbBzkJbZK7zb+Px/TsT4zW0+UfirURhUGdRkI/X9UfFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176322; c=relaxed/simple;
	bh=5ZfWgy9esgahb0QqQijGFmO8QmsKCjGb6OQMi39jBxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkwmXEeJvDiF4XYeqro2pvdTY1L9m2lQh6cCq0Y60K3CyKMlNOEvd2w+mIUBlM9SQwd5fmyIvGxKVLK5yflZoXSqhdbIUXeHdsGAnL5ww/t/kWJg2CHQMIa3sObkOSCTR6SNEiC8yFDzInBQMkPvZ2EJ1HIK4Jn/MvCTFFNibfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoBjmuGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoBjmuGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5D6C4CEE3;
	Tue, 17 Jun 2025 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176321;
	bh=5ZfWgy9esgahb0QqQijGFmO8QmsKCjGb6OQMi39jBxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoBjmuGhxDhgeq/ZHnQlrk8lIPWDu2PPkhkewPJ0w0tOrH30Cz4K6w+blGoBsowuL
	 6mEwpOT4lXA+H/EoaXD0LGUgVeiE6024JFIWtJ7BoO6mVTQ7/sbt9E1uWBGUvgble0
	 4Qk/S9oGe77GiWU1Dvce0ZOXom8WN6Ex2SN/fdoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 153/780] media: verisilicon: Free post processor buffers on error
Date: Tue, 17 Jun 2025 17:17:41 +0200
Message-ID: <20250617152457.730557260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 11beb0fc346e00c412b3bfd19013206f6b655604 ]

During initialization, the post processor allocates the same number of
buffers as the buf queue.
As the init function is called in streamon(), if an allocation fails,
streamon will return an error and streamoff() will not be called, keeping
all post processor buffers allocated.

To avoid that, all post proc buffers are freed in case of an allocation
error.

Fixes: 26711491a807 ("media: verisilicon: Refactor postprocessor to store more buffers")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_postproc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/hantro_postproc.c b/drivers/media/platform/verisilicon/hantro_postproc.c
index c435a393e0cb7..9f559a13d409b 100644
--- a/drivers/media/platform/verisilicon/hantro_postproc.c
+++ b/drivers/media/platform/verisilicon/hantro_postproc.c
@@ -250,8 +250,10 @@ int hantro_postproc_init(struct hantro_ctx *ctx)
 
 	for (i = 0; i < num_buffers; i++) {
 		ret = hantro_postproc_alloc(ctx, i);
-		if (ret)
+		if (ret) {
+			hantro_postproc_free(ctx);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.39.5



