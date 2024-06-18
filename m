Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7D19CCF9;
	Tue, 18 Jun 2024 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715894; cv=none; b=VqteX/BHVzAM3fcB/Wp6z03mvFmkkcUM334YfLZEQD3WbSn9uFpaAIFvAafK8eWhiolHAfgeVL6K9dnV8jnv02dBQgt9rsf9lOiTQAYfOHLRCak2X1Dk6vT0V8tk99QdLiea6W7+Q3enUXsPMXK+6lWWPgUpIEOXr94Tdz6U/Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715894; c=relaxed/simple;
	bh=zLP1abi6NRaFc8xO33ptE7XzfmijTDXM3Ubl+m88pCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iv7xphamq3SlsAe0ouFJsJ+hdpY5l4EZpG1XpxfSsk+vt0Z6vOT8/F4K+ypVkqBF0+4qx7LIGiM/ugeDrvaq2AZ//VPCc/G6KXJLPgqlhL75jqHORgznkcHlRRngVtSgMSQZSsTSlUaG62ivs3xV8JXPXarrib74O21s7ChmNxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/Mqqqvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/Mqqqvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA27C3277B;
	Tue, 18 Jun 2024 13:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715894;
	bh=zLP1abi6NRaFc8xO33ptE7XzfmijTDXM3Ubl+m88pCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/MqqqvqTxpqi8hYCnxoGVnWak6SztrDPOpg6intM876X3prM5WPOnnU1tLfYQk8v
	 zoDpPl/AntgcIuvsP/AG3YqD3SrP70VgUtwDoCESir+BgYzwP6/R+/pl/1DVJL545+
	 NBKgllLUrr3fOnm2P7aRZRTPkSlkLKVJODy24Tio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Woithe <jwoithe@just42.net>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/770] lockd: fix server crash on reboot of client holding lock
Date: Tue, 18 Jun 2024 14:35:16 +0200
Message-ID: <20240618123425.186258532@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 6e7f90d163afa8fc2efd6ae318e7c20156a5621f ]

I thought I was iterating over the array when actually the iteration is
over the values contained in the array?

Ugh, keep it simple.

Symptoms were a null deference in vfs_lock_file() when an NFSv3 client
that previously held a lock came back up and sent a notify.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index cb3a7512c33ec..54c2e42130ca2 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -179,19 +179,20 @@ nlm_delete_file(struct nlm_file *file)
 static int nlm_unlock_files(struct nlm_file *file)
 {
 	struct file_lock lock;
-	struct file *f;
 
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++) {
-		if (f && vfs_lock_file(f, F_SETLK, &lock, NULL) < 0) {
-			pr_warn("lockd: unlock failure in %s:%d\n",
-				__FILE__, __LINE__);
-			return 1;
-		}
-	}
+	if (file->f_file[O_RDONLY] &&
+	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
+		goto out_err;
+	if (file->f_file[O_WRONLY] &&
+	    vfs_lock_file(file->f_file[O_WRONLY], F_SETLK, &lock, NULL))
+		goto out_err;
 	return 0;
+out_err:
+	pr_warn("lockd: unlock failure in %s:%d\n", __FILE__, __LINE__);
+	return 1;
 }
 
 /*
-- 
2.43.0



