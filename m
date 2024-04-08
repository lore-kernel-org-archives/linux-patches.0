Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CD16A342;
	Mon,  8 Apr 2024 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584221; cv=none; b=a3kJOoBKYr+4OqmbHtnjlPanHo39nYoYlcG+56bOq75tiscoK5fZ44CTF5xXThF3fQdQwAgwsBj/VrGRBOHrbty0ivIeGoLDyly0bk7PN8fsHjH0I7nFvVeyK63cG3WReSRHCiIGPQ7+m14M6PvPgACHsUqOAXdZZhIA4ARmO0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584221; c=relaxed/simple;
	bh=8PybrSpOIpA18Czmy2830MxlKxF9Wi92o6VTexgN3I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO0sc+1Mn/divtzDbKiM/EohwryNdaMllOdRXWa/3uIxm58P6qoAPuVQOFTFykZQsJ6LTeORrRgU+EwpojEtVxUBK7ope22d3JHl8B+snU6qOuFbEcKMQpv18ezMBBoaWSlRmAB8wJbSXNFEBtD7uiaSHCA49UdbDmoSf8gpD+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1d9kHplm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1d9kHplm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD0C433F1;
	Mon,  8 Apr 2024 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584221;
	bh=8PybrSpOIpA18Czmy2830MxlKxF9Wi92o6VTexgN3I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d9kHplmISEdu7EBzTuTHlMeoMYUZY2pP/dBzt3DY6krjEUHueZarkX7Kbu4w8oqJ
	 bzb7mMKGc6okgzNCDPHrghtipR4Q/3mw1iCBf1GpXL+HVjWdOumMpMKx4460nGfC7L
	 Tg1LpXEyprGD7kTs0hpVaK0lsbl/W7BACohJzzH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 364/690] NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
Date: Mon,  8 Apr 2024 14:53:50 +0200
Message-ID: <20240408125412.765824230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8755326399f471ec3b31e2ab8c5074c0d28a0fb5 ]

Remove an unnecessary usage of nf_hashval.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6a01de8677959..d7c74b51eabf3 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -272,13 +272,17 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+	struct inode *inode = nf->nf_inode;
+	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
+				NFSD_FILE_HASH_BITS);
+
+	lockdep_assert_held(&nfsd_file_hashtbl[hashval].nfb_lock);
 
 	trace_nfsd_file_unhash(nf);
 
 	if (nfsd_file_check_write_error(nf))
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-	--nfsd_file_hashtbl[nf->nf_hashval].nfb_count;
+	--nfsd_file_hashtbl[hashval].nfb_count;
 	hlist_del_rcu(&nf->nf_node);
 	atomic_long_dec(&nfsd_filecache_count);
 }
-- 
2.43.0



