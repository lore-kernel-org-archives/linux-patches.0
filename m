Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102DA2B9C7;
	Sun,  1 Sep 2024 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208828; cv=none; b=fp6cSv+CC9+V43Z101UUFTShWFGE/5RCLeo6A1bv7RoRnYtcOhXrGYZMC/40pXIxUDnGUXlv+nVOX5AtumaS0K/4+cYzCPpUsGzaaBjU7Pi6Usrz2OoiRhBqh8VdMsfY0ku4Vvcn5IUH1eEp/OblDP3Krm8WCqpo2jOR3biCsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208828; c=relaxed/simple;
	bh=GN79wNiymmKEtr1Y0yAE3MnAd/SkEDnPAcNCBVXPzp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru57JBYYvLWDPZA97QCpPBkcGvkZ+PUkAlygdE2YytDG1eKaw5VQsY1Ce8dHX6IiSckC5Jmlo5PqFGUVMpNSo8djd0X9xz80NvmKtCvCnAPFJoF7Fh2LzNccZ5HHvZbvoC3Fe3LEXqYqBrFkA96u7tf/fJu7xOF7Bu+umAOiV5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NImbHk8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NImbHk8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790D2C4CEC3;
	Sun,  1 Sep 2024 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208827;
	bh=GN79wNiymmKEtr1Y0yAE3MnAd/SkEDnPAcNCBVXPzp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NImbHk8h0uaH2TEf9dc6CdsXzwKr1BlJqF9mCt9wKqpWVtu9PXMKNWAf7CdAFLa+l
	 ju/awdV77gweTTq4DQpIXEdxqCyjd8csQwJSG5oDGXBtOE1cKvu7DdBnRqqPW3bg+3
	 ectHdAVojvZl7Twj3LirilJZsIwNz4zfie9DD4t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/134] virtiofs: forbid newlines in tags
Date: Sun,  1 Sep 2024 18:16:36 +0200
Message-ID: <20240901160811.992453661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit 40488cc16f7ea0d193a4e248f0d809c25cc377db ]

Newlines in virtiofs tags are awkward for users and potential vectors
for string injection attacks.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index fadf6fb90fe22..48f144d083813 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -237,6 +237,16 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
 		return -ENOMEM;
 	memcpy(fs->tag, tag_buf, len);
 	fs->tag[len] = '\0';
+
+	/* While the VIRTIO specification allows any character, newlines are
+	 * awkward on mount(8) command-lines and cause problems in the sysfs
+	 * "tag" attr and uevent TAG= properties. Forbid them.
+	 */
+	if (strchr(fs->tag, '\n')) {
+		dev_dbg(&vdev->dev, "refusing virtiofs tag with newline character\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



