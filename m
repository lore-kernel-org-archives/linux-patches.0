Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1021ADC7;
	Tue, 29 Apr 2025 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947072; cv=none; b=fw0veAYv83FwsZ6X46TvvfkaM/rXmb04WVmxPJEjjofyQgnbI5khrOIwhR8TIqktawjwMOue27I809PFERV5qCoKsbH2MOluzrW0blTjwolae4Xr6Bkigw+5y8FKlerWAdUY/0vXiLisCmB68E/oAaanwqjwodh84uDSwdFB+N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947072; c=relaxed/simple;
	bh=AbDMKLXvvHrU9LAHR6uGB20JWFHtxFYvwNCvtLYC8l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdfQtD2t6vh2ZTRJ/8Nlu/iJqCW4YTY26RRMeqJKfiYsXq+h0dlEk+fL7mi6aecXZ8GSFEFky6aaOlddC+CnzPEMD+x4jKiQFDtAr8nKfigo5hxnc2C3Vr90/iJ7tCr2bt8Z8d6gfFVxnaP5a7j1yQ3fkE7sZeiSqWss2NAwcFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiH2sejA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiH2sejA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1761C4CEE3;
	Tue, 29 Apr 2025 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947072;
	bh=AbDMKLXvvHrU9LAHR6uGB20JWFHtxFYvwNCvtLYC8l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiH2sejAuyeyH1hLS+hUlviiiYeSradqZLWvRCjVZScnYLYwsxx/dlzmwiEXEL0Xe
	 aqfnmViECu9ElbmYdBPbU6qUWDSUyUwZXadog2hDVEms6FQrE35vcdvTp8xfxBFzQ1
	 nBl+6Ae3t9VAJwymzyBdgmyNLca3Sp0UOeNOMXoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 133/286] virtiofs: add filesystem context source name check
Date: Tue, 29 Apr 2025 18:40:37 +0200
Message-ID: <20250429161113.339240408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1447,6 +1447,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


