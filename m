Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB250217723;
	Thu, 30 Jul 2026 15:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424621; cv=none; b=KAFKd/4QfkFGKvLybwmKygTV1x8YTiKl3MR9tNQUhjzJz6RaSyXMPP7jbRnx9NuwsfZ9Rq1VzzMlozOCHgCsegMV2owaSXwSvhEgl3QXMTn0vWex8L6hM5KI8z/5OsYEunxG9miGaRc4rQ14ufsnFtdaNEVp+saLLRED7XIZAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424621; c=relaxed/simple;
	bh=MS8YeAuWxLxBjxHsiLGuPgrf6ajIPxzvCk74ZXxei6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iv+wQADj1QqQMErr4azzNmlJQC7ffHs9NRXjpgbL/cLA4+IuypskOh/RCIYCYxA5N7uOrlG8DJHB7IKre61kItajmhDVE6egr9+cwF4AafjSVJA2Tjf++nIURPQJsTvB8/lhW/2jLxy7o0md48ceJbTnazBpPttDVzJfV4meqj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEDaHZ8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEDaHZ8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213F21F000E9;
	Thu, 30 Jul 2026 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424620;
	bh=xsW8uNbyrZ78+IxhUOa2c04dYY61TnCXNjGf19q0N7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEDaHZ8XAQ0hZzt9ViYf3JXTAvOcF/xL/DgrzzLVkSMdLu3yGZ5Y2OeM4z1vZq1yu
	 goPFeHYYBHrSrPKYdz0A5rqdxlZO2w+btI5ccXubpQSvWBmHawCz1DlXb7znk0vPfN
	 lbGc0DasEHw7+tRORwYAXjiKWL4/tiI2DGIkKURE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 414/675] media: nxp: imx8-isi: Clean up already-initialized pipes on probe failure
Date: Thu, 30 Jul 2026 16:12:24 +0200
Message-ID: <20260730141453.931498129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit d970b27cc48ec42f8a72bc3a4a4ad2e5c7a36395 upstream.

When mxc_isi_pipe_init() fails partway through the channel loop or
when mxc_isi_v4l2_init() fails, the already initialized pipes are
not cleaned up.

Fix this by calling mxc_isi_pipe_cleanup() for each already-initialized
pipe in the err_xbar error path.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260507041318.491594-5-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -517,6 +517,8 @@ static int mxc_isi_probe(struct platform
 	return 0;
 
 err_xbar:
+	while (i--)
+		mxc_isi_pipe_cleanup(&isi->pipes[i]);
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
 
 	return ret;


