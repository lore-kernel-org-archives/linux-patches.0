Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EB11CC14E;
	Tue, 27 Aug 2024 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772396; cv=none; b=n2Wb8DsZczle27q+iHkB05Ksr4ZgqkDMjsZZgMpjeccE0OpLRNVIkjNcaC4kiU5PdQtj2WGE7o2I7kKCNI5aHxlqntMnAKWPLKOtloufhVrSydDKQSt1oqO+kVj46Qqz9Jm8dVCD215q8yulxS6Gf5La0T/8OP9j80RSPz1GM4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772396; c=relaxed/simple;
	bh=Z/NLcNm78RZGY+0j0tzuWH6PzhNzBjCXBcERUqge3Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhy7r92fHkLuA/3NGyA6A0cmJt77m6qqBc3mEpAxVBO2/tKNygviaLB3YK0QPyOJskgyIKQ0bMkCgOfaY/Ci8VO1uDbMbniYU52lbJdirsrr1nBFf17zNo+i6frDBr+YWMXPWxbtm71c0VCJWJ1WbwWBE8eWyHVJvObo3I0OUtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O65WlAIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O65WlAIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AB2C6107C;
	Tue, 27 Aug 2024 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772396;
	bh=Z/NLcNm78RZGY+0j0tzuWH6PzhNzBjCXBcERUqge3Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O65WlAIv2lfQkjRvEqYA2TQls0nJB2UzObCcZEz0UMgswcy4lPGjlyppGjRfs5/xS
	 5IcYJE5Rv1SdZauu9gcRq6kgZZPdsI4U/DsMPSBqckjC4DnkRh8LNTocAge9YICMBX
	 9IUoWTXpMC6u2/wHZK08M6538GKE3MZFvD2LD0dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/321] virtiofs: forbid newlines in tags
Date: Tue, 27 Aug 2024 16:37:59 +0200
Message-ID: <20240827143844.740497703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8d4f16c727b..92d41269f1d35 100644
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



