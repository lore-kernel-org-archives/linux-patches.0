Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B37363C6A;
	Tue, 16 Dec 2025 12:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888563; cv=none; b=dzeL8NImjSV0blPFcb8J6ZmP+YHAf3hyjbnH+ah/B9hibVr8VJAGKhHqIVPm4t1iCcILn9yKN7nbgiWOLJaO54EZ/0Hh7JfwY3/3Y/Cjdn1kQ/RGhHjAwD68FOngoUKsf51wgXOVzLbPAB8PeWjswFPEyVTo5GI5b6NAzsse5FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888563; c=relaxed/simple;
	bh=qcpWD3B5Rfw0gEiucNMaav2ZCLLqFHpX4tEdXmJfLIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nelut5E1F+6IkapfWJq/A574pkjPZUyizXt51ukWuTK2zJaHciHsIsbDVRl0TMTc/ks7rKtF45ZqZPLJwNNO/JaZjnLTKLu6DKkLR7l2RH1rcqsLf08cxTSRyguRbw3Mz2bfrIsJ8GSjdMiyNZKJacoMnPJKYys5yv7RKGsCr9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOZ9o2yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOZ9o2yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EBCC4CEF1;
	Tue, 16 Dec 2025 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888562;
	bh=qcpWD3B5Rfw0gEiucNMaav2ZCLLqFHpX4tEdXmJfLIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOZ9o2yi32GRgU+o1wHsL7OvS+k8va4QY9vLs4etmCKgWpeLXp19jx4XO8/czK8Gz
	 TqY2NePAB7ooup2ujTTzTBnw7DytI+dTJHDkU1DCF2qQdlXY+gNn+QeIej8XAoc9m6
	 VGmgFr7zRJItwKVx4gPaKglSnbGiW7V85DFmfbt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 572/614] nfs/localio: remove alignment size checking in nfs_is_local_dio_possible
Date: Tue, 16 Dec 2025 12:15:39 +0100
Message-ID: <20251216111422.108170448@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@hammerspace.com>

[ Upstream commit f50d0328d02fe38ba196a73c143e5d87e341d4f7 ]

This check to ensure dio_offset_align isn't larger than PAGE_SIZE is
no longer relevant (older iterations of NFS Direct was allocating
misaligned head and tail pages but no longer does, so this check isn't
needed).

Fixes: c817248fc831 ("nfs/localio: add proper O_DIRECT support for READ and WRITE")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 656976b4f42ce..512d9c5ff608a 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -339,8 +339,6 @@ nfs_is_local_dio_possible(struct nfs_local_kiocb *iocb, int rw,
 
 	if (unlikely(!nf_dio_mem_align || !nf_dio_offset_align))
 		return false;
-	if (unlikely(nf_dio_offset_align > PAGE_SIZE))
-		return false;
 	if (unlikely(len < nf_dio_offset_align))
 		return false;
 
-- 
2.51.0



