Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617787;
	b=vtwJ33rBjcxGd0yetwEBWJYHhCfWMi+uRpOBcqQcJOhPquqo29JUXBxlCBBZyagiO7X9
	 og0uRNkr2ti+4kW/zRmo5K025mG4apoZPcpNyM58d4OzDnP2sUHhafO+gbQVLtxBwFSSy
	 qxxRaB+MOevSo0QCXNkKj6eKnHIrA9qAvJrPzP/CVu7L9i8eI3lrWklQOh7yTUWt9+0Vj
	 BsckFep8lCpYaXFnq9AocjckRmnBGrckg8r78aQAydP9sJk3QOaXaVBaj7KnqF/hRTkIU
	 HMQp8u6xXN+/rFLP5R3ZXwtB/JBaujJI7QX8pvXdQr1P8LnvFdvU9ho990HGdvIQp5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWmvCYj4QBcLkxzRtE2c0a5OhcquZgxN3+WbCmnGtaE=;
	b=GpTn/Eu9P/BbxUaaz3BtcJqlbNbbOKlEbdh/yw9yCv7qlVlKju2s0RGPSsgFPdZw1XzE
	 E8QFeZUhQmJ3HbWpkJwjUiYuE45rkM/yB13HI9PAe18MUePkMe42fsVcDTgYHn5qcefcj
	 V85SYjsxQbpLlIkr4bH+FjmkMxA6RzSdB0rpiTSLAfsIX4Z6Uuwe+ku9emgce6o22glgh
	 G6bBa4T7zgAUvWyMV3oOaSA4IwhzrPE1Hp49pBgj7AGR6Aw7/fwze1II1OpKJ+aTN0ReF
	 PytfY7znd5OFdWX2wiu+M3al9Ou74Cm4g0citEOWyknSggNhwUQhM7rmk9rXtfIpYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBooifoo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE091606A333;
	Wed, 25 Nov 2026 14:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBooifoo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363491F000D1;
	Wed, 25 Nov 2026 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617786;
	bh=DWmvCYj4QBcLkxzRtE2c0a5OhcquZgxN3+WbCmnGtaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBooifoo6jrY/2lGq8xbKrvxtSPXqihTJVUmWYoE4dSN70+MuvY+o533LXfdrvif+
	 YsP5JWt97G1CKtgWnzqSxabDnAdyJ+OvSSzB1nsEUdRopfe1/JebrlI1mWZEUbgDpT
	 4XIhCLwu71kmX/OH0bBfMfq8wmEOI7BYmSNqZELA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0029/1005] net/9p/usbg: fix descriptor cleanup use-after-free
Date: Wed, 25 Nov 2026 15:22:47 +0100
Message-ID: <20261125143822.420468673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 0955472fff1e9f9e410a0300136924ebc8bd7a16 ]

usb9pfs_free_func() frees the f_usb9pfs object before calling
usb_free_all_descriptors().  The usb_function passed to the latter is
embedded in the freed object, so removing the function from a gadget
dereferences freed memory.

The failing teardown sequence is:

  configfs unlink
    usb9pfs_free_func()
      kfree(usb9pfs)
      usb_free_all_descriptors(f)
        dereference the embedded usb_function

KASAN reported:

  BUG: KASAN: slab-use-after-free in usb_free_all_descriptors+0x138/0x190
  Read of size 8 at addr ffff888106a73088 by task poc/95
  Call Trace:
   usb_free_all_descriptors+0x138/0x190
   config_usb_cfg_unlink+0x1f0/0x2f0
   configfs_unlink+0x321/0x6f0

Free the descriptors before freeing their containing object.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Co-developed-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Acked-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260529081817.77898-1-zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260731150414.3135662-1-nicoyip.dev@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 7d600e1288a30..6bc7de04bd514 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -754,8 +754,6 @@ static void usb9pfs_free_func(struct usb_function *f)
 	struct f_usb9pfs *usb9pfs = func_to_usb9pfs(f);
 	struct f_usb9pfs_opts *opts;
 
-	kfree(usb9pfs);
-
 	opts = container_of(f->fi, struct f_usb9pfs_opts, func_inst);
 
 	mutex_lock(&opts->lock);
@@ -763,6 +761,8 @@ static void usb9pfs_free_func(struct usb_function *f)
 	mutex_unlock(&opts->lock);
 
 	usb_free_all_descriptors(f);
+
+	kfree(usb9pfs);
 }
 
 static int usb9pfs_set_alt(struct usb_function *f,
-- 
2.53.0



