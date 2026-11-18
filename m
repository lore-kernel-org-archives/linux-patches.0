Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021472;
	b=g3jkIr4ciEcXN8gePgpxU6ed+4BsarNCc1brDcLisjDH6moRMULVahoG4+IuJ+/8FmgU
	 mZqkpwJqJ7pun7Qu8WPheCGQtkt383e0hsI15DIXtupGGrUiHoGj0+/89mg3b4pUk1L6D
	 ABKM//vW3knuGajW0jtGXOnGtIj4JtNnVCp8BiC2XhixVe+ZHUdXV5EJacHJkwdPdJ7k+
	 rk9O3fwkjAMG8F02LVyweGrjUGgnuIhJmExRk/6078bJgr+lcXH1dAxEOL74jghI9lo0h
	 imJfDk/wzwLlJkb/VYSket9X5bGcwUg6ophpRok1+Xpuhjs1uJQ8UbsaWxWFpzLtDXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hHrHOl8XOSOkAFtWUWVklUA3G8C3vcwE9YVgTbJG4EY=;
	b=sdZWT0ajbqSMxiuRoAdRYhHdcy9AUzheNmbukWCajJPBoHhBGMZCb4sIDKrKL4Ta676E
	 IJ7LpXIO5Pmei2esfRokmCodnkwlxynGwlclZri69E4vNnPHaZrxNyg2iYtj6e66OEnf4
	 zKQo4tcaowjcDKT9xNnnPrigVaHAENNkzInrDgXFXDmmxyOxs3equl1l6DuchUCz0R5Sg
	 hO+GHehRkVB6n8WhCaVJrYg8+NSZ0ZgwU1fvj0bLUjAw07YbmCe3Ng3SEEXrNaoj07wvr
	 2OqHHoXIq+hEV0w7utGW8u2DYfo9wojnuTVodJWBDYisAAGhTy/IFRVTSRcIJZFsjJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1k29ekO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E04A60A3832;
	Wed, 18 Nov 2026 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1k29ekO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB871F000C5;
	Wed, 18 Nov 2026 17:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021472;
	bh=hHrHOl8XOSOkAFtWUWVklUA3G8C3vcwE9YVgTbJG4EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1k29ekOk3/hkhtQYjc6SWxNFSBUYqa+Ab+NeVoOOwLst1ZVIW4dEG//FWcLoE2Ub
	 lUzI5IGrxOGco2SN6TQz0wW3p76fwbsGniQqfoegWJpeb1tIFdeTqK7ciMamBadJqQ
	 Y2w8j7avvWxyZerAECnAgF8OUrhg0qDa6x3UhcIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2278/2651] exfat: fix used_clusters accounting during cluster allocation
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150407.331110917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit cb9dbf8a4e34b4fdf311598835ab4d76ed7e07c1 ]

In the current exfat_alloc_cluster(), p_chain->size is incremented as
each cluster is allocated so that the partially allocated chain can
be freed by __exfat_free_cluster() on the error path.

However, sbi->used_clusters is still updated only after all clusters
have been allocated, while __exfat_free_cluster() unconditionally
subtracts the number of freed clusters from sbi->used_clusters.
Therefore, when allocation fails partway through, the partially
allocated clusters are subtracted from sbi->used_clusters even
though they were never added to it. This corrupts the free-space
accounting and can cause sbi->used_clusters to underflow.

Increment sbi->used_clusters together with p_chain->size as each
cluster is allocated. This keeps the accounting consistent with
__exfat_free_cluster() on both the success and error paths.

This issue is caught by generic/476 with 256k cluster size:

    Ran: generic/476
    Failures: generic/476
    Failed 1 of 1 tests

    *** fsck.exfat output ***
    ERROR: <path>: more clusters are allocated. truncate to N bytes
    ...
    /dev/vdc: corrupted. directories 331, files 526
    /dev/vdc: files corrupted 9, files fixed 0
    *** end fsck.exfat output ***

Fixes: d5c514b6a0c0 ("exfat: fix the newly allocated clusters are not freed in error handling")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index a8b11e2ce43f1..a6728c3612899 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -509,13 +509,13 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 			}
 		}
 		p_chain->size++;
+		sbi->used_clusters++;
 
 		last_clu = new_clu;
 
 		if (p_chain->size == num_alloc) {
 done:
 			sbi->clu_srch_ptr = hint_clu;
-			sbi->used_clusters += p_chain->size;
 			mutex_unlock(&sbi->bitmap_lock);
 			return 0;
 		}
-- 
2.53.0



