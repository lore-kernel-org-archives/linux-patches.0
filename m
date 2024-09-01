Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0317C;
	Sun,  1 Sep 2024 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210065; cv=none; b=GcOTg0UA/DugQhj6iUMin4adFM1zd89pbQYArmcl6Zb+ftj4OJI10J9OokYSzg/p4aLXZbgFo93jrj0mkYrVbeMYtA3//QewMNxd3bLYKJn/SnOOAKtapT5f+BJZ0joCcfEFTwGaZKEWDelnrZQEOGbah9FOPDYQ0vdcO+g/hKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210065; c=relaxed/simple;
	bh=+IGxl5ylVpOafqIczJyZV1Aeg25CZwX1ZnruYNymCdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss2ZbfyUEywzoN9Kkvv4MnuIQczjbjNuDuXUUuvDqI80xSUh2UM0AFd0K4Kc8zFsvDMR/VMelULIj9fS1P1I/1XAxN0r/fj6F7MA1PufFc3xvPfbWIshUqEk01gFobgy6Zj9NEvwI87nqoORZJlWyejiRYgF27EytV5btttXl/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaeKaK7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaeKaK7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA849C4CEC3;
	Sun,  1 Sep 2024 17:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210065;
	bh=+IGxl5ylVpOafqIczJyZV1Aeg25CZwX1ZnruYNymCdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaeKaK7eGiUwU52TF0EOvKC014cepkX11V0fCo9VA5u1luq+wirhvpEm8ELvJkW5y
	 mWgFjN1gHgqV7yhhq1oRU2ZeUkyDS0t+ezL/ii6OEPBDkeIfj/QoK1xHoNpTgbgweV
	 BtDgPmcvRXRWbnRsIW3mx0iU4yyfYyeOfvdgxJg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/215] virtiofs: forbid newlines in tags
Date: Sun,  1 Sep 2024 18:16:30 +0200
Message-ID: <20240901160826.301383405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94fc874f5de7f..a4deacc6f78c7 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -310,6 +310,16 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
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



