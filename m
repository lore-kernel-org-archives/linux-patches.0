Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6F29DB64;
	Wed, 23 Apr 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422042; cv=none; b=hCCzNH115Mm1AnRPva3kjQ3fY90cULT9X0NkBf4JLg9U+EWu3KE2+zIPIP6L8STH3SCf1/6Fcv81r5egfzesQUVDuWzjnCU+4KWGUXbBBQj/3fLBrZeHVa0qO0ERC4NfQMraK76WotXNMHM0cVrp+lCpdMMAkMb0dP6CI2Yqzec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422042; c=relaxed/simple;
	bh=OfwdPLDlEVfLbxOawXANDLW/gGmRkP3jAq5byFV+t+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx1LTQ3bT454Zed1dRZoXbpivhHF/z0Yee/Y0hQnaGox3RFerxXB/J/PHbedebzUckQ6zc9COkcumgWNwh/AeFQHlrfQcboyTEeq1MRG+dm5R5WCYQWrqRzzNcQlfAFq+k3+uS/K/b7OJ/H8olQxCeVkIaUNFf/fGBbFr05YTC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZYd54Fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZYd54Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE031C4CEE2;
	Wed, 23 Apr 2025 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422042;
	bh=OfwdPLDlEVfLbxOawXANDLW/gGmRkP3jAq5byFV+t+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZYd54FcdGy8Rqon7yrUIUPrnTlLJ3ZNkQRwJgLy5XpH+b1sYEkqX0MowT0f6c3j5
	 853nR6tGI4taQGl3D5MqTk/TqGTcB4Ntx/HolzKsKSP74k4wDQ7zfO0sQAGEYh80zU
	 UfKu69mkGoLz2Ojp38duN5E+1wRXsalosJFSzpzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 223/291] virtiofs: add filesystem context source name check
Date: Wed, 23 Apr 2025 16:43:32 +0200
Message-ID: <20250423142633.535174815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1429,6 +1429,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


