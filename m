Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E532941687B;
	Fri,  4 Sep 2026 05:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499546; cv=none; b=eANHA6vvs6YDTAtnl8Bcs5udR/NfhieVnQxCEPEDzKtIkrXJQQ2rc4ZfIy6bTqO8ufH0ZkAU2tG+qG+NTgOLfsvCQ/5mAwShZ6g163b5dQ/VvPoA3ebR+XWCd61tOQLN+E8MwgS7S9aXdI+hrgKTi44u6a5nnfi5ENyjoQjGco4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499546; c=relaxed/simple;
	bh=dcmzQQQ2nij+vagg8ivnt/jX/HuebKyE/vrTeEQWxKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOzMTyclAmSQsbb9D2EqME0XnW6o61ExDfm9WxKeS1yTTTbPn5oZa83cN4BBhZiakZY+vs8lzez2gmpLdByr1pGLyEl+q1QlyQuJidkkgES+7QEx+d/2lDAiL0vcdMTTLX6ptN1eh8HKygIef+1OWNH0R3g5Hw0nMkUh+PkMyXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPea4Hjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPea4Hjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5021F00A3D;
	Fri,  4 Sep 2026 05:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499544;
	bh=q3ez42wNZkCCtrr/5/MfUfuP1pg88jhbUKyXM51EL2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPea4HjpHdirNHwJPry8/1/ViNke3qgOUuTafmcmrHgqOAWY4EzDUV2rh9MplfJgv
	 fvK97hRShe/8mBVkmufiHA9700RMt46/90iTPpY5Y95JQ3GP+ViJ2uClo9dGV7IVKx
	 zw3XvKs9DOj+ZNwWOOuAtJWyckCLrR4jHGPrerq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhang Pan <242270054@hdu.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 448/713] RDMA/uverbs: Guard legacy bundles without method_elm
Date: Fri,  4 Sep 2026 06:56:56 +0200
Message-ID: <20260904045813.871533541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuhang Pan <242270054@hdu.edu.cn>

commit 60a42d510113f46de47e86a84bf5758597644487 upstream.

The legacy write() path dispatches through a uverbs_api_write_method, but
the uverbs_attr_bundle passed to provider code does not have an ioctl
method element. If malformed provider input causes the common uverbs
validation code to emit an error message, uverbs_get_handler_fn()
dereferences the uninitialized method_elm pointer.

Initialize method_elm explicitly for legacy bundles and make
uverbs_get_handler_fn() return NULL when no ioctl method is present. The
legacy dispatcher continues to use its local write method, while the ioctl
path continues to use the registered ioctl handler.

Cc: stable@vger.kernel.org
Fixes: 7122ff96068a ("RDMA/core: Do not read wild stack memory in uverbs_get_handler_fn()")
Link: https://patch.msgid.link/r/AOYAQgCQK3IXqJLr1TB5Qao9.1.1787036796115.Hmail.242270054@hdu.edu.cn
Signed-off-by: Yuhang Pan <242270054@hdu.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ib_core_uverbs.c | 3 +++
 drivers/infiniband/core/uverbs_main.c    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index dbbc0875132a..41c84ffe8c09 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -424,6 +424,9 @@ static uverbs_api_ioctl_handler_fn uverbs_get_handler_fn(struct ib_udata *udata)
 
 	lockdep_assert_held(&bundle->ufile->device->disassociate_srcu);
 
+	if (!bundle->method_elm)
+		return NULL;
+
 	return srcu_dereference(bundle->method_elm->handler,
 				&bundle->ufile->device->disassociate_srcu);
 }
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3ccf58e96aed..0d88b2ee68ff 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -556,6 +556,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	bundle.ufile = file;
 	bundle.context = NULL; /* only valid if bundle has uobject */
 	bundle.uobject = NULL;
+	bundle.method_elm = NULL;
 	if (!method_elm->is_ex) {
 		size_t in_len = hdr.in_words * 4 - sizeof(hdr);
 		size_t out_len = hdr.out_words * 4;
-- 
2.55.0



