Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C8F15855C;
	Mon,  6 Jan 2025 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177517; cv=none; b=owgAaGARhop4iW1mUHxd2rbJau0Y0qht7HLSiW54lOKDlloqe8SZg/U35AZa+A+Zk3eGY/bIxVVLcUWR/VYtw/dy5AsyaX0yzEqaGyI0HgzgfpcFDnztdcpSN3jzMp1cfiwe1+RT/HE0q8I3U63xZAQ21da6OgLFrBWSXYOVNCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177517; c=relaxed/simple;
	bh=u8UJqXWh0TRf5UT02pOFO8KQPvZz/QvWBOR4uAjpXXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8Ijyi6bQEIYSDLIPNvaaBadbJxRnj0GZDjJi8aujp03QYuKmSE5WHAk+7hwFszC5H6Q9erUFsxRhgLDsb1FC+s4xACXa9lnuM5fSv74ke74PPtNFhXH8rAu9KW8fDDNhLB0IavTAoTjOlLgXJEqpJ/+oT2rxDoa4A6Cml2CC5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8MWrV0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8MWrV0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9989C4CED2;
	Mon,  6 Jan 2025 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177516;
	bh=u8UJqXWh0TRf5UT02pOFO8KQPvZz/QvWBOR4uAjpXXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8MWrV0nDXBqnHHCiEqH2nxFq4ZN/s45A/mGM47NgAEIDD3pM/Lj549MJb0C4nS2m
	 ShGkDTTX/qLn0SaGXscIHyE6vDEy8XviErL+sxD/8tsBRqT5YwpkfoNIQQBzwxoSh4
	 uQE9DUB80TlNNGkTajeHOR5xGp4iAOlSFkn7riKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hobin Woo <hobin.woo@samsung.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yoonho Shin <yoonho.shin@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/222] ksmbd: retry iterate_dir in smb2_query_dir
Date: Mon,  6 Jan 2025 16:16:31 +0100
Message-ID: <20250106151157.843052901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Hobin Woo <hobin.woo@samsung.com>

[ Upstream commit 2b904d61a97e8ba79e3bc216ba290fd7e1d85028 ]

Some file systems do not ensure that the single call of iterate_dir
reaches the end of the directory. For example, FUSE fetches entries from
a daemon using 4KB buffer and stops fetching if entries exceed the
buffer. And then an actor of caller, KSMBD, is used to fill the entries
from the buffer.
Thus, pattern searching on FUSE, files located after the 4KB could not
be found and STATUS_NO_SUCH_FILE was returned.

Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Yoonho Shin <yoonho.shin@samsung.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 12 +++++++++++-
 fs/smb/server/vfs.h     |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cd530b9a00ca..7216e2cc498b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4225,6 +4225,7 @@ static bool __query_dir(struct dir_context *ctx, const char *name, int namlen,
 	/* dot and dotdot entries are already reserved */
 	if (!strcmp(".", name) || !strcmp("..", name))
 		return true;
+	d_info->num_scan++;
 	if (ksmbd_share_veto_filename(priv->work->tcon->share_conf, name))
 		return true;
 	if (!match_pattern(name, namlen, priv->search_pattern))
@@ -4385,8 +4386,17 @@ int smb2_query_dir(struct ksmbd_work *work)
 	query_dir_private.info_level		= req->FileInformationClass;
 	dir_fp->readdir_data.private		= &query_dir_private;
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
-
+again:
+	d_info.num_scan = 0;
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	/*
+	 * num_entry can be 0 if the directory iteration stops before reaching
+	 * the end of the directory and no file is matched with the search
+	 * pattern.
+	 */
+	if (rc >= 0 && !d_info.num_entry && d_info.num_scan &&
+	    d_info.out_buf_len > 0)
+		goto again;
 	/*
 	 * req->OutputBufferLength is too small to contain even one entry.
 	 * In this case, it immediately returns OutputBufferLength 0 to client.
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index cb76f4b5bafe..06903024a2d8 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -43,6 +43,7 @@ struct ksmbd_dir_info {
 	char		*rptr;
 	int		name_len;
 	int		out_buf_len;
+	int		num_scan;
 	int		num_entry;
 	int		data_count;
 	int		last_entry_offset;
-- 
2.39.5



