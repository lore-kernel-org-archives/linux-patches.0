Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72892E49AE;
	Tue, 15 Jul 2025 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585934; cv=none; b=QpiI57veQVD6BmjVVB6SgsnDTvGp1zCZqlCMLvMqdmnV+PqLtWnnjbZCWyk4N+dKxLqRIMdnUW65mgdAbClbmtQi7xlUdX/gCBpkC64gTyl6ObxZHqxE4fhN2+POMNPaWBJi8YIo5RgmdOHJc/lZVLZ8HuXkSoLLzEqPbppR/NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585934; c=relaxed/simple;
	bh=n8uPNQKe8maV5A9TuufWy/3FLpDfMLFbyfzim/qFlRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIfYCEfe3h0wZI0BmAfceleBfcaef0qEA2HfYZKh3PbP9O/Mi0fld/GnKOR+OPMttIXebMlNDxmdvtBua2wf6FSzv9gP65ja8OqcdAy9Zrczz5kfciG57sGSIJcTnIEC3hWZDnW/PKbieq2rV+k2Bjr/NfpECvTJaqyk+AslJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc6pUFav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc6pUFav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D2EC4CEE3;
	Tue, 15 Jul 2025 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585933;
	bh=n8uPNQKe8maV5A9TuufWy/3FLpDfMLFbyfzim/qFlRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc6pUFavTwIniyeBJLQ6BrysHmw8jIi1Vf6aXulunfibcOfByP1ziK2xIPDnjLk/8
	 ojYgAkzlxiz1k/s5B5RRw1W0eYYsF/z08ZQCwpu0a25XRhOouSqT4yuhU+mWBUljq1
	 cntr5RJ3Kgk0eURk4UFst8dGT6NqQP8nQZmyUNNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 062/109] ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()
Date: Tue, 15 Jul 2025 15:13:18 +0200
Message-ID: <20250715130801.367134117@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 277627b431a0a6401635c416a21b2a0f77a77347 upstream.

If the call of ksmbd_vfs_lock_parent() fails, we drop the parent_path
references and return an error.  We need to drop the write access we
just got on parent_path->mnt before we drop the mount reference - callers
assume that ksmbd_vfs_kern_path_locked() returns with mount write
access grabbed if and only if it has returned 0.

Fixes: 864fb5d37163 ("ksmbd: fix possible deadlock in smb2_open")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1293,6 +1293,7 @@ out1:
 
 		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
 		if (err) {
+			mnt_drop_write(parent_path->mnt);
 			path_put(path);
 			path_put(parent_path);
 		}


