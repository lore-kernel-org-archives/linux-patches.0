Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7892D524AF6;
	Wed, 30 Sep 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791015; cv=none; b=ELcf+hr2NB+TaSa/J2oz9ZMdPKB32hBAMsogIQB+qpW0b2GHi4eUtl7f7thmkIqH95Uso8lRv8DjD+ha3UBSXS0S3PVuQsgrK/dAXOVDhGfEgptHX1P/LWS8TDa7CVqJ3EB8idTiActkogDp16FHNIIGlSlDvcDuU8BzIqkz3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791015; c=relaxed/simple;
	bh=K2CcVCUD0HHClmzgKLy09iROL0NtdPuFj+/xr994Q6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUShSw25ONzwvBfesbyMMioTPSHKF+sMar2jYP/WewrXBjl8QVTqH0OVRBrSTT+t/Vyos8OkGIaAqZhuugPIKWXMtmIHQBjL2wP2vZOhu8wMFfbR/sxhkL90bL4KRhaNzoLJEmXz47YprpKoJJbYxhkH9StnhFpgE1Mh59tJO0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S66632qF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S66632qF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51441F000FF;
	Wed, 30 Sep 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791014;
	bh=uHMEPYsftFpgKrNcBAT2j+6/RdcF34YaeYoMy9Pzd+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S66632qFVt/hTSp3FXGE4vql88g3NdCEiqTaM31E1ni5HhLKsGiX1J0Ob6NuRM1wr
	 xN2n7zBLkULEsjxFhjzb4N+4riyW1P+1WGcKkPib68v5FU+c9uvBAWHZmhOd9zTXvO
	 zwjlzDH+pd2fmt+BoCWuR+/jB5HRhL5LE6C/yQOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/752] fuse: set ff->flock only on success
Date: Wed, 30 Sep 2026 17:20:24 +0200
Message-ID: <20260930152401.520076243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 71947173cef279be5eed209ec28f8c11f9d73159 ]

If FUSE_SETLK fails (e.g., due to EWOULDBLOCK), we shall not set
FUSE_RELEASE_FLOCK_UNLOCK in fuse_file_release().

Reported-by: Li Yichao <liyichao.1@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index db9211464f1e0..b6b06f760162c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2610,8 +2610,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 		struct fuse_file *ff = file->private_data;
 
 		/* emulate flock with POSIX locks */
-		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
+		if (!err)
+			ff->flock = true;
 	}
 
 	return err;
-- 
2.53.0



