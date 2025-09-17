Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2D61EB1AA;
	Wed, 17 Sep 2025 12:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113771; cv=none; b=qvhhB4DzEXGOQqi8XtuoSf75MxfwjFo0ob3rGXlmADRzVBL+kNOz+ZwX14hRFD5IYnGoifA8BkDAaqTsz3f/py7aOHiLPIRB5v5NY3wjI31gJJ0UyyQT+iVrBKjKkOJXVVArk8+yGi7uN31s2LchtkdopDkSn9MErdCdGtNer8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113771; c=relaxed/simple;
	bh=VP9H9XSrAFQK0/kQr6sYsy/z1Bz5Mz5sXAeNQyftevA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDIVEyJfZjIagb1QLbnFHE8wkxAwUw7KPS5Y0vMiom4FDxF0swSUnBYCo2ebP+Ag8ltEIURqhXYQVvnizdBF3llvU+8ydBjrgPtRc83imI+ZF9P117kTU0VCV9l3an6GmghZQw1VdMRU+hpmFfYJKXqVZv5aJx3bfn95ArILUas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+UTQdpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+UTQdpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC794C4CEF5;
	Wed, 17 Sep 2025 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113770;
	bh=VP9H9XSrAFQK0/kQr6sYsy/z1Bz5Mz5sXAeNQyftevA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+UTQdpoIp6MdX9vXSH52E1lg9lABItX25b1eKAiUofr76vXrnCRjnpXoemrIZUq7
	 vwDK7tmoXJP/t/d5QI/WwRJcwT8Am+a8Mm/uUulyjp0G4EX3zmdzbe58aVP4Cma/RW
	 cqyuHUlDytN/YjvawMTd+hB310k4AkaTonmqZutw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/101] NFSv4.2: Serialise O_DIRECT i/o and copy range
Date: Wed, 17 Sep 2025 14:34:03 +0200
Message-ID: <20250917123337.348631083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ca247c89900ae90207f4d321e260cd93b7c7d104 ]

Ensure that all O_DIRECT reads and writes complete before copying a file
range, so that the destination is up to date.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 66fe885fc19a1..582cf8a469560 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -356,6 +356,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		return status;
 	}
 
+	nfs_file_block_o_direct(NFS_I(dst_inode));
 	status = nfs_sync_inode(dst_inode);
 	if (status)
 		return status;
-- 
2.51.0



