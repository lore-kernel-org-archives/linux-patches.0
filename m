Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C913FBB72;
	Fri, 15 May 2026 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861989; cv=none; b=oM0RQiJWsW3DnIAgi2J+kF24G0mMZws2AzUVQPLlIfoEyuAczH0VXJhrSvGjVmCBmNFsZSzC8vepH98ivLps+n4BypYksbUm1x4hGIl04zzFv/4ORKM1IRUQJpnczOdAU8p6We6yvdn7/yZuM2r104KuYeLlkMGOYXTeIFWmGlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861989; c=relaxed/simple;
	bh=//3imWa6DubH500Aoj9tWHfALzZgc3JzWmLCbCAhSfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcWOAMR1HkCO12CO7YYAyu3QeAwja1Bsx41IljD7ECobJPKC8ZFgl3YOZ5d/qNWtKXaKC8dzWCcHLNOHlRqc3L+rhSMefVTKP37C/C2hNeQDf3fw+npk0rXFsDLLrICc7LP+kxFFECeIVwMQi13Y/eO3q1lsLvnTwiEOYkvOG5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLve8OYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLve8OYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B2CC2BCB0;
	Fri, 15 May 2026 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861988;
	bh=//3imWa6DubH500Aoj9tWHfALzZgc3JzWmLCbCAhSfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLve8OYTSolVEtFRBD7jGpswU3X1AUQTA9sYcMFjAAsoUjIaoaK2e8SPp89pkpW+8
	 jv9/RxjbZASJ6YucW2A82DFUx94V07E41z1swEp0VHiuXf4iTwPFvDC/Wu07ArpHeM
	 ShwqWZr574/ZTm2C2aYnuCoHluOrVUgfmC+8Yu9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 022/188] staging: media: atomisp: Disallow all private IOCTLs
Date: Fri, 15 May 2026 17:47:19 +0200
Message-ID: <20260515154657.788669752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 2b7eb2c5dc72f0fc954ac4aa155f9e285e937f7c upstream.

Disallow all private IOCTLs. These aren't quite as safe as one could
assume of IOCTL handlers; disable them for now. Instead of removing the
code, return in the beginning of the function if cmd is non-zero in order
to keep static checkers happy.

Reported-by: Soufiane Dani <soufianeda@tutanota.com>
Closes: https://lore.kernel.org/linux-staging/20260210-atomisp-fix-v1-1-024429cbff31@tutanota.com/
Cc: stable@vger.kernel.org
Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Fixes: ad85094b293e ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1357,6 +1357,10 @@ static int atomisp_s_parm(struct file *f
 static long atomisp_vidioc_default(struct file *file, void *fh,
 				   bool valid_prio, unsigned int cmd, void *arg)
 {
+	/* Disable all private IOCTLs for now! */
+	if (cmd)
+		return -EINVAL;
+
 	struct video_device *vdev = video_devdata(file);
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	int err;


