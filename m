Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EF4215060;
	Tue, 29 Apr 2025 16:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945415; cv=none; b=IrfKE+N82lklb/xtxi9UmCtJuRK9XGpBu+Xw/cSFB1JC19XReBEluIoun4soLzcOsGPsVbBagtNxFfv/tL89S9FcvuUdyIEnQoiWhpnefegs+5KrIyzmsGdsdAYZfe1ipusN0Bsl5JUeE+SSeZmc+CzXn6F9JvRkei4kGQynkHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945415; c=relaxed/simple;
	bh=DeuvOHXv0/FqG1Hzl2Fi9Eji11gaRUU+eu2yoKPRZuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6FLmajqhOTdbgeJ4fsobZ6nDfffy+OvWnVHACf97NQmM0APFN2JzVm2X3+2NsmwLBp1FaCb0/Ou6DMJndetYsLbZx1hB+HJwPOZyGAnmm9GAU0/eYC6mTxmyNRZ89WK4A+bLI1JVHEcprBjpJ3qa0qM/zJoPKTH+ebw8pBtwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLDAgEc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLDAgEc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C183DC4CEE3;
	Tue, 29 Apr 2025 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945415;
	bh=DeuvOHXv0/FqG1Hzl2Fi9Eji11gaRUU+eu2yoKPRZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLDAgEc9ynHfoJ/hYuGcNiPeKdB/EgHRutqb4YdMB5PecnFr/uWnVtFYEUTph51yj
	 Fp96Xxele1HnsKLvv4TIjR/rOA238wzIhxVcVA7oC/szijZrG70C3gjP6RQXPGKi2r
	 8MxnDFF2Aal01cqadPIQHNE3Fl96+znH7bKtGQoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 104/179] virtiofs: add filesystem context source name check
Date: Tue, 29 Apr 2025 18:40:45 +0200
Message-ID: <20250429161053.609893615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiangsheng Hou <xiangsheng.hou@mediatek.com>

commit a94fd938df2b1628da66b498aa0eeb89593bc7a2 upstream.

In certain scenarios, for example, during fuzz testing, the source
name may be NULL, which could lead to a kernel panic. Therefore, an
extra check for the source name should be added.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Cc: <stable@vger.kernel.org> # all LTS kernels
Signed-off-by: Xiangsheng Hou <xiangsheng.hou@mediatek.com>
Link: https://lore.kernel.org/20250407115111.25535-1-xiangsheng.hou@mediatek.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/virtio_fs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1206,6 +1206,9 @@ static int virtio_fs_get_tree(struct fs_
 	struct fuse_conn *fc;
 	int err;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


