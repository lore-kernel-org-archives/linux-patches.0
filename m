Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345E019F485;
	Tue, 27 Aug 2024 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770248; cv=none; b=RPB3YsWmuhQ0iKVWP7xTH1dYAF3wWhFVPsqpnlWmXjYRL33StgHA9Opm+7xOP/+dLOO/HSTKN6dNT0hxPuSMvDcpBEIRC4N/oG8az0yeHqRMGsNUEkVq5uazmFObOQu8Dun073vbX6ZKacVH3JlR8GZrr8lfazItL+ifPULnqLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770248; c=relaxed/simple;
	bh=1rVIjyRB6tPU5L7eLb9bEiprobz58TWiXEDExZXgHTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBTF1vibWl5YcnGKG48yIkxiFWvSMXbxvW4FnG0DwKHx35tKE2PVL0Trazcvx7eli17qG8WxaxNLsT4bEHUV+1HKgOWHF7/KFkmeEqiBWsk05O7Ofh3PCQxas3GlY3aXH/NBEJuIl/8wQXor8tPBNilwKY2S3ZKY0idWOOynKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+9hoCJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+9hoCJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC6C4DDFB;
	Tue, 27 Aug 2024 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770248;
	bh=1rVIjyRB6tPU5L7eLb9bEiprobz58TWiXEDExZXgHTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+9hoCJzfEaOhdDl/HInNEqYDM616kPoU7983AqgFJLvVbfXG0sUENvPSBVTJGp6l
	 HbC01idJPifdNnxzX97A/Uly5P3DFFxmAi72bCSI1XdimgoGKoVlOZLvgUtLNiMgV7
	 +sO+JAYR3Ic1dO7DkJLC7Ogp/DK/jVBXCiqdiYqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/341] virtiofs: forbid newlines in tags
Date: Tue, 27 Aug 2024 16:36:42 +0200
Message-ID: <20240827143849.921278101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f1be1da92ce9..d84dacbdce2c9 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -323,6 +323,16 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
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



