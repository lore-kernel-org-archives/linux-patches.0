Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985DB331A68;
	Mon, 29 Dec 2025 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025571; cv=none; b=NrBjW7rEtZmP5Iq7KJhnlr1MYIqGfL4nYnOw9hUGCl/2b7g2tSa+xbgHlN/BjSKtQ0GWHOus642dS/XhjSvHY3JTESDExXQn/A+LmPHL9/+54vvyueuZdZ+0aLhhqUROgp8o2v1mRjhgv2YDJ9K3yOFaMLFQvh5p1Lzml04aiPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025571; c=relaxed/simple;
	bh=E/yIZD+Ar7D4K4yMHipDsDC6etY/VdmTqNwmsHbbeyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSJ+sXOxqhTcw47+OMOePZ6a25lXpoXdC1l0kA67E9J8X4pQ17nAoDCZRunee7HEge+hN9GfyR+wlGLGALqCrqFsFArmuHUq4LQvhTsf6qL1YsNGHUSaoJYEOwMXB502jmx0IIfNM+9Q3z4dzmUaBd6oFBq5GtBISc4mbd9s4DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzCy1E3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzCy1E3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211CEC4CEF7;
	Mon, 29 Dec 2025 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025571;
	bh=E/yIZD+Ar7D4K4yMHipDsDC6etY/VdmTqNwmsHbbeyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzCy1E3nnvnJXTi4hzwRcT9BdGA4VQPMUSDOMz6OkyGsP1pOpPOmPkrufJH3RdGHc
	 kZuS1sRmg+HER+OlLEzURczJ2wI+hTrkAB9rNiPMvgX4iZGyEbLmWd1PlGDpa6IdWm
	 EQDbKBeVhnOe03Rhr27T0C3OGJJ3hTsCAe/FHgFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 260/430] ext4: check if mount_opts is NUL-terminated in ext4_ioctl_set_tune_sb()
Date: Mon, 29 Dec 2025 17:11:02 +0100
Message-ID: <20251229160733.923658130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 3db63d2c2d1d1e78615dd742568c5a2d55291ad1 upstream.

params.mount_opts may come as potentially non-NUL-term string.  Userspace
is expected to pass a NUL-term string.  Add an extra check to ensure this
holds true.  Note that further code utilizes strscpy_pad() so this is just
for proper informing the user of incorrect data being provided.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251101160430.222297-2-pchelkin@ispras.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1394,6 +1394,10 @@ static int ext4_ioctl_set_tune_sb(struct
 	if (copy_from_user(&params, in, sizeof(params)))
 		return -EFAULT;
 
+	if (strnlen(params.mount_opts, sizeof(params.mount_opts)) ==
+	    sizeof(params.mount_opts))
+		return -E2BIG;
+
 	if ((params.set_flags & ~TUNE_OPS_SUPPORTED) != 0)
 		return -EOPNOTSUPP;
 


