Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45A18455B;
	Tue, 30 Jul 2024 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358210; cv=none; b=dYlWDe2e/ZkS35SzDB0vTwegdtxS1UDzjlP0TeTvmhYzDQwwQZotjNtq6e4aPcCREHTkF3qHUpGu2BBKv2s++gptAuu6ZvaUNyOr+pyMx+S0xgAirWzagtQHz4HE1QznFgkigZhUVDK0UOlA7MIwCTGAFm0NXvJIdoGR0cafi34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358210; c=relaxed/simple;
	bh=/Ps/9J053VdsrQg8TnYfJCDPaUT15O3RmQMeANz5xNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwc3y9dC7RQsZeyUFjHEjuwynuTypZzEd7uZyYD29jeKgsHV8iZIz2wQZm8HYq8whzrA3BRbWx5tvyRNdTn9oNiySzoVbY9jjNc2VO1m3n8YSjxNDNoi1LQvRrn9+9PVH3sb0tzJSZowGBajcYLv+ohC+kQfyGyWhIzOEaAZyls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMZhyRjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMZhyRjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D97C32782;
	Tue, 30 Jul 2024 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358210;
	bh=/Ps/9J053VdsrQg8TnYfJCDPaUT15O3RmQMeANz5xNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMZhyRjNUa8u1vTs9h7WcCKfYWscZCuhtYoNiXsgd8/v+eAcQhHMLZQj6expaJnJF
	 JBhD7f4rUXo0PmOwffjcP5hUA4Z761ww4jLx4j12uX9cy9j4SLW1P82QXBF88mP1pD
	 Vz7YA56uV0jwhwGOkerh5xtVktO/gDx31a0krsx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 335/809] media: imx-jpeg: Drop initial source change event if capture has been setup
Date: Tue, 30 Jul 2024 17:43:31 +0200
Message-ID: <20240730151737.851100708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit a8fb5fce7a441d37d106c82235e1f1b57f70f5b9 ]

In section 4.5.1.5. Initialization, the step 4 may be skipped and
continue with the Capture Setup sequence, so if the capture has been
setup, there is no need to trigger the initial source change event, just
start decoding, and follow the dynamic resolution change flow if the
configured values do not match those parsed by the decoder.

And it won't fail the gstreamer pipeline.

Fixes: b833b178498d ("media: imx-jpeg: notify source chagne event when the first picture parsed")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index cc97790ed30f6..b1300f15e5020 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1634,6 +1634,9 @@ static int mxc_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 	dev_dbg(ctx->mxc_jpeg->dev, "Start streaming ctx=%p", ctx);
 	q_data->sequence = 0;
 
+	if (V4L2_TYPE_IS_CAPTURE(q->type))
+		ctx->need_initial_source_change_evt = false;
+
 	ret = pm_runtime_resume_and_get(ctx->mxc_jpeg->dev);
 	if (ret < 0) {
 		dev_err(ctx->mxc_jpeg->dev, "Failed to power up jpeg\n");
-- 
2.43.0



