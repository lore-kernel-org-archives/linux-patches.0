Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211353;
	b=3Jns4Ix358Y90SvZPfy9hif+acTPnO79uFbm+matJcsQdF+qtDpHRBsHGtdE4dBtVRO1
	 Q5/8qPBP+j9owQDTRbeOKmhTp3BHB4TrG2xrfhzSVtwLHWw8S+aax5MW4SzryfMT2xKoC
	 cUbTfyEw5LVVu2eieugAdRiJmrHwESCmTwCqDnovxou3vbtRvlAEaP/AmWiAgrW8Cgzo/
	 +B4n+l5oyEpOnuMzFs0yULIrjDxjuP4n1WL3WTvqz+HhQHmhg7um/iSQCOEZhQJCAMJDn
	 wUh+rBFfNTNxpleD+mvF1JBPcZkIscEyb4T/iEiTyQ039SkPxwzPqAIX/FMlpIznryg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdW2IzBe/1juoU5r+f62h0X5S258+hnYqpv2ig99EN8=;
	b=bDRBs+NZeny7PV4bmrbHaBJWPpcBVIc96+GRGz8lkB4MG91LABwOBLXy68jnjgtjO6OJ
	 YnJneNFGiDUDBuR/DFHGeREsMnpwcH4stUWwiGoFu0vGz6bB2wG0mBhGb19mEHelNI6Nv
	 +oTQewdpLl3/arpMJFygKaQptlRS0Ym84+Os9WgbM/VqLO9LDYUqepT7R/bENxBVJFUo8
	 mIT6jH9/R6OG1SxvwHAP2u/PsX3SIWipNp2lf9buZ6wFm3O7AvxH8p0xkhDjPJWDYFsU0
	 k/S8KM5REIVplRSpjW/EQqsBYKh9dexG60PgaLlCw1MibpzhVYrEgQDD34wtUlf8YEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYda2dkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D268606A32A;
	Wed, 28 Oct 2026 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYda2dkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF481F01825;
	Wed, 28 Oct 2026 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211353;
	bh=rdW2IzBe/1juoU5r+f62h0X5S258+hnYqpv2ig99EN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYda2dkt2F+AfpcgRFKgI86GkDf33WUITk6KiIYQVqNTizeEtAsEeMTM4xPLmAQdR
	 /UsHLDyplryLU1K8NU8FgCu+wVSJVm1xb7GJKmP/hvO2sXOQhSKla0wRVO3jRpXbCZ
	 7pazAlu0P5r4TaLxx65frBw74egLs1cQqe4UyGuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 347/571] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Wed, 28 Oct 2026 17:58:14 +0100
Message-ID: <20261028170016.250929676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -685,8 +685,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


