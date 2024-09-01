Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012E81DFD1;
	Sun,  1 Sep 2024 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209506; cv=none; b=goCERXXSalM7VZepSXbu8csY2Ee5AcXafAbc1iXPLPIVy79RDQpvwTFcdlXZRVim73BN+yM4mJzrEm8VDNW+FgNsIXPlaqHwJs0Km1i420Ua31H+VfeqqNscH08dzUoQFReadq56E0kkuGsd1i9X3LsbtrL/aEhggDBYt8Yjq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209506; c=relaxed/simple;
	bh=LR0XDEZ5gG2n2gIgkQYFFxNRVOl9Twm7qAbSfVCv+Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLB5QNBzKRrwPnamuUm6KKIc5AiBiZ4wvOamAFmvuIo+wl+bEol4Wo6n7biDCJKB+ZF76bCCEvWQpQ/jSnVPQcRDM9qzPmhBWXE284WnYrGQLpl7SkyETsMlHpCmtSaKnpH5Rf+/h3C8PuX2jpyKNWR5S2smfFQF3CUrqiTgy1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjO1tm6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjO1tm6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B530C4CEC3;
	Sun,  1 Sep 2024 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209505;
	bh=LR0XDEZ5gG2n2gIgkQYFFxNRVOl9Twm7qAbSfVCv+Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjO1tm6YlkOUOLYPUM7LDaGaZi0NMGRr+8jPGR3pxYv7bOQtf3JSw/IuoWj3nLHYP
	 YO7bn/CDhDQCWQdBsTTNKmG2gDAzs4y/Tr8s+Gl+MAkbuO6LqLZWzuyoN9e9Hiof53
	 SqjLy0parhlWrjEze9ezYKGkfltd0Vd22iqXIRG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/151] virtiofs: forbid newlines in tags
Date: Sun,  1 Sep 2024 18:16:56 +0200
Message-ID: <20240901160816.226031702@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7d4655022afc6..c50999ad9f7ab 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -315,6 +315,16 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
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



