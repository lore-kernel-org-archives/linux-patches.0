Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B924330567C;
	Thu, 30 Jul 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426147; cv=none; b=lrd9DSDxqL/Mm0s7k2AYhiqv/P6tClfL/lYS5X852fiL88S8rfve0ET4b3Eyn7P7x4UHXw7SftVbHZM/etNWcu7E4zKCDL8M/EZ/LF4ke9mWLOfSPG2qDKP5Ava/faUewelZuvj4H/rhs2m9/9ojNWyNSPnlHgo5wjksnLuxSjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426147; c=relaxed/simple;
	bh=8kKvmqwBrgxps/WKB06kZw//XQgTSrVNV3AuWUmVvjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmawdAUriFD0/a/650MAWJ0ZxNORR4oNjX9WlQG7ayYtRY0wqHW6sqybEgyV78Q+zuZpa2FlsznnFVZOjExH+oveNPCYxE902Brl3N5uFgTXfUvf0ksKGH8jq1gbKUB3HC4MFDTFsUW6NKKdHSU2keurL23yah33gNnZV1e48jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tV4BeqWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tV4BeqWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088A1F000E9;
	Thu, 30 Jul 2026 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426146;
	bh=OWHUemFgpGD2MXGvksiavN9q6z5u2QqLTohadlnO6Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tV4BeqWyY+ez5rOHNFI0KdLr4xM2BRzzWr8rYfTc224abh263d4m6PRfe1k35p7E8
	 HmByOG3Sct8V7UjWafdlgXPlMzZnVGivjzQdqrzvS2pxJqOivg/OzgSQaEH8msuY39
	 ApdFF1ScGBUfzVIwgWCiNSRxQwkK9nj+acwaJP/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 316/602] media: nxp: imx8-isi: Clean up already-initialized pipes on probe failure
Date: Thu, 30 Jul 2026 16:11:48 +0200
Message-ID: <20260730141442.605316206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -501,6 +501,8 @@ static int mxc_isi_probe(struct platform
 	return 0;
 
 err_xbar:
+	while (i--)
+		mxc_isi_pipe_cleanup(&isi->pipes[i]);
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
 
 	return ret;


