Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC119DF53;
	Tue, 16 Jul 2024 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145248; cv=none; b=ZoVOOSTzqYmr5rSb5gU/69WBPjXpz8yvdNiS5bVZB4bdgbcqE8bZa7ONKO7qTZ7cUCdwNLCo+YrYv/qP00U9ivj1M/1CAu4T7Y+NGhkhxFeiy2Iod+2VsWtqfFQeOUq0eHkc/oNz2jGu7koYQHHDEt7HA5QiSP3jmjgVIkYzd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145248; c=relaxed/simple;
	bh=Q/C2zExKg/jhjkN1NfCN8MLtTQvqwErYGz6c2dcGW1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJfMxBXboUBeKTok7V4ZH6ByvFtVVyeg0df5sQrg+nAm4ryFjwvrmwa9LyDE6vIYlLDQDeoYi5Bcxpfm0eJlnbW2oVMaj7+6bLyZfDOzC5Zs1qBO5wEpo7yowRas9zLrUGu6i/1TgJbkreA+CDNS5e+NQmabkwyy/UceZq32jMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxblnWI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxblnWI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B5AC116B1;
	Tue, 16 Jul 2024 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145247;
	bh=Q/C2zExKg/jhjkN1NfCN8MLtTQvqwErYGz6c2dcGW1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxblnWI3ZVGedMn8vMyTtTP2Il6gcf91EGR/sUP7ff3GZFhJelDhxPrjTZ4A+YSvC
	 veLksFhvejmdI86qDimJjzamY9v0oeqdwtWX9Fhtf3liX1T9MPAsrP3ZctSG9sX5jX
	 7EHUn2uImVtqEEpZfVAwLxujErw4XwUSx0L5ttYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 129/143] misc: fastrpc: Restrict untrusted app to attach to privileged PD
Date: Tue, 16 Jul 2024 17:32:05 +0200
Message-ID: <20240716152800.948199863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit bab2f5e8fd5d2f759db26b78d9db57412888f187 upstream.

Untrusted application with access to only non-secure fastrpc device
node can attach to root_pd or static PDs if it can make the respective
init request. This can cause problems as the untrusted application
can send bad requests to root_pd or static PDs. Add changes to reject
attach to privileged PDs if the request is being made using non-secure
fastrpc device node.

Fixes: 0871561055e6 ("misc: fastrpc: Add support for audiopd")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c      |   22 +++++++++++++++++++---
 include/uapi/misc/fastrpc.h |    3 +++
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2087,6 +2087,16 @@ err_invoke:
 	return err;
 }
 
+static int is_attach_rejected(struct fastrpc_user *fl)
+{
+	/* Check if the device node is non-secure */
+	if (!fl->is_secure_dev) {
+		dev_dbg(&fl->cctx->rpdev->dev, "untrusted app trying to attach to privileged DSP PD\n");
+		return -EACCES;
+	}
+	return 0;
+}
+
 static long fastrpc_device_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -2099,13 +2109,19 @@ static long fastrpc_device_ioctl(struct
 		err = fastrpc_invoke(fl, argp);
 		break;
 	case FASTRPC_IOCTL_INIT_ATTACH:
-		err = fastrpc_init_attach(fl, ROOT_PD);
+		err = is_attach_rejected(fl);
+		if (!err)
+			err = fastrpc_init_attach(fl, ROOT_PD);
 		break;
 	case FASTRPC_IOCTL_INIT_ATTACH_SNS:
-		err = fastrpc_init_attach(fl, SENSORS_PD);
+		err = is_attach_rejected(fl);
+		if (!err)
+			err = fastrpc_init_attach(fl, SENSORS_PD);
 		break;
 	case FASTRPC_IOCTL_INIT_CREATE_STATIC:
-		err = fastrpc_init_create_static_process(fl, argp);
+		err = is_attach_rejected(fl);
+		if (!err)
+			err = fastrpc_init_create_static_process(fl, argp);
 		break;
 	case FASTRPC_IOCTL_INIT_CREATE:
 		err = fastrpc_init_create_process(fl, argp);
--- a/include/uapi/misc/fastrpc.h
+++ b/include/uapi/misc/fastrpc.h
@@ -8,11 +8,14 @@
 #define FASTRPC_IOCTL_ALLOC_DMA_BUFF	_IOWR('R', 1, struct fastrpc_alloc_dma_buf)
 #define FASTRPC_IOCTL_FREE_DMA_BUFF	_IOWR('R', 2, __u32)
 #define FASTRPC_IOCTL_INVOKE		_IOWR('R', 3, struct fastrpc_invoke)
+/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_ATTACH	_IO('R', 4)
 #define FASTRPC_IOCTL_INIT_CREATE	_IOWR('R', 5, struct fastrpc_init_create)
 #define FASTRPC_IOCTL_MMAP		_IOWR('R', 6, struct fastrpc_req_mmap)
 #define FASTRPC_IOCTL_MUNMAP		_IOWR('R', 7, struct fastrpc_req_munmap)
+/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_ATTACH_SNS	_IO('R', 8)
+/* This ioctl is only supported with secure device nodes */
 #define FASTRPC_IOCTL_INIT_CREATE_STATIC _IOWR('R', 9, struct fastrpc_init_create_static)
 #define FASTRPC_IOCTL_MEM_MAP		_IOWR('R', 10, struct fastrpc_mem_map)
 #define FASTRPC_IOCTL_MEM_UNMAP		_IOWR('R', 11, struct fastrpc_mem_unmap)


