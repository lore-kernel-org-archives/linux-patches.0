Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9441A23B0;
	Wed, 23 Apr 2025 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420361; cv=none; b=WhUuNNMZmicnNY51Sb5MTPN0Gz4AVKzugPqfTHUCKn0ahZltlT/oZAAjFpWvBzVD4JAGy9ejqFkX8wbBb3ncLGPPkwmpGglE5GH7llBoCLhTp3KyQk5cbawbodOZhgYFMWIsBERhi5FqCgGZ8eCNNNpu3GHewdWs2XMO3p/xQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420361; c=relaxed/simple;
	bh=c9fPBDIUxvZOJ7+/0VnNfPbmBdfl44poaGguW6pG2+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+tcNN+kmVSPMFFbEVlebZutLS9u3JWASUlnkJdAIcurjDgyV7fd+qbhRqBKnqmpqobmqqxGhUG97y7wmf5/zq0r3nQHTOWCY9xhi8eBgj/jxdmhONleKBv3rUYH74+mrBtgOPBlFTj4rlf+6II56Pv/hHcSM5BEgRr2qsMDg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCsX/5Vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCsX/5Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C461DC4CEE2;
	Wed, 23 Apr 2025 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420361;
	bh=c9fPBDIUxvZOJ7+/0VnNfPbmBdfl44poaGguW6pG2+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCsX/5VuxWeDUXn4ClUlOH+co+i184fUOU0Ehud3Gly+2Ed1QgApFSyU7QQnp3pKN
	 91upSHlr9nGIR+ZrPS+5o2zZykpuAohA4ftFR5N2RRbXPsSXejqi0Ws2JYef+VWS3q
	 te/GVpbO/zQYYPWRK01rjsCIK/JoE+gdVLsyovec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 125/223] ksmbd: fix the warning from __kernel_write_iter
Date: Wed, 23 Apr 2025 16:43:17 +0200
Message-ID: <20250423142622.192643493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit b37f2f332b40ad1c27f18682a495850f2f04db0a upstream.

[ 2110.972290] ------------[ cut here ]------------
[ 2110.972301] WARNING: CPU: 3 PID: 735 at fs/read_write.c:599 __kernel_write_iter+0x21b/0x280

This patch doesn't allow writing to directory.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -496,7 +496,8 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) ||
+		    S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


