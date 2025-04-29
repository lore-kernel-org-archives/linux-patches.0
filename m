Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF37C239072;
	Tue, 29 Apr 2025 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948948; cv=none; b=ofn8phgIPNE+RHiU5oVh6KK+C8bxd+00XSY0udkPYO8h5cUXhbOqg5KZR3TPX2wBBrM/WZFgesy+Krs0qz4z8rPfPagiQcaQlnHV+g4yhcqBwdDR8UQqbhwXSnmbK5MedFULhXOHG05vaRFoEaImxBYxtkzQplcAS5+atU6wic4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948948; c=relaxed/simple;
	bh=AFU/xwxuea5PcENdWqbXZT0s+foOgV29P+DSPaN3Njg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppI2UUnSRDAvLCDS2jOiDOR8HrT1jca9kzeX98WE5+l896o717k0ERbDLnQeVf2Ssc6e3klkfYpmryicJN3of2tWaFt7GjnKDpBJXU4bK8yP1ABk3+vHaa19cpddnOieCHSHypxvJNF8dODFkeLndm/qTuXhsXRk0sevqAFVZuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqBY3Oec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqBY3Oec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F727C4CEE3;
	Tue, 29 Apr 2025 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948947;
	bh=AFU/xwxuea5PcENdWqbXZT0s+foOgV29P+DSPaN3Njg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqBY3Oec40JGkNE7pfjwvM5cIlpx1wzsLkp+Y6vG6b2UW9DDdv7FGqbetd6h/JI2S
	 YoTq9v89kUQNpdSQCnpiU9pgWAwtKBXAUa3TTVGpCy842N++Keo33O0M1fk8/3Jddp
	 Ggb9lIXK64fkpZcgreUFUjRIxSfFn1ic6RJwNtzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangsheng Hou <xiangsheng.hou@mediatek.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 172/373] virtiofs: add filesystem context source name check
Date: Tue, 29 Apr 2025 18:40:49 +0200
Message-ID: <20250429161130.248706794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1431,6 +1431,9 @@ static int virtio_fs_get_tree(struct fs_
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (!fsc->source)
+		return invalf(fsc, "No source specified");
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.


