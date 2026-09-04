Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0D2348C47;
	Fri,  4 Sep 2026 05:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500877; cv=none; b=RhTSnjXF9OHlaPf5jvQBTeJRLs4s0ThEhGhl4lnOgs9J24BuDWtQjwQfXGNjPz8Nd2TW8pfpHvL2bT714W18o4T6aN4TXyKeiP5OpVgSZu+5iV9H39EG6r0bZcUzGJuKxGtCtLPYikBsA+yfTAvQFMmahwqMrfDvVKHyYgqgVQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500877; c=relaxed/simple;
	bh=x1TgWWm02g1Q0hubd+iIzlJL7iy2J727V3wXFo/zghs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5EOH8MdlTRM1EavFn6yLPaUXabDBtdIsJs6jBxrFfIFT1BqTB3gsJqSQN0jjhC9yUdlAJdxMlrEHKOeZQDj3yN5TnWtOF4TyTrPnFX07NXslMehJEroPvQ5Spu3rZ97cESynVHJz+EW16lLUHKYN10Wq6EgoZsdezpViy3mGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrtH55WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrtH55WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CD71F00A3D;
	Fri,  4 Sep 2026 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500875;
	bh=3KzfZjmbrOZpfUld2IMZK4VEybku5cFYBR3UHTDx5ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrtH55WC+GiyACIOUbOTFgX0MwSsvzLYQtF9mKhhoNpYgYHUQITr6uwON2aZjimdU
	 bVfz3F8RmeYcNIDZOxA6NUf+EoM+q/F6ORLi8Wf/Geh7Yfld6mZmWoikeveE/xroDf
	 fb4FwPpq6kp3RowtCF2d7g1a6S0fVv8SO+6C5BTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 168/552] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Fri,  4 Sep 2026 06:55:25 +0200
Message-ID: <20260904045752.835500908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 6c322f5cf7476ded7a9a20f7be72462065a03c68 upstream.

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1364,8 +1364,19 @@ static loff_t cifs_remap_file_range(stru
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 


