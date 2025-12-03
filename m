Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07453559C4;
	Wed,  3 Dec 2025 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778672; cv=none; b=Q5Vo5LYVrZG7S/ujaAqu/Ln9hlLXs9AWCQ53RpeoFhSyfmUswSyOou3QYrV8YaEWq12fwgqCt/J4bQjvvcvovy5xIbNgzrQRxuPV0Gl+A51pDaEMRD6uml/a6NzLUSFxKzouBofygpHuv2j8jZa0Oi24hUM5MIH2g6CorYRoof8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778672; c=relaxed/simple;
	bh=9zarvc9YeiikFXRwtcQVR8FtTj3yZk97SEvhqFIcpqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6xa48XcwT8C+oTx9BxKK4cCeddMlRSFXH8qfR9QcuKIIvNelLdNLrItS/wYO4EGzi5WoSLPvKixPI1YTVy7x6KmUBFQfkIkyxbDYsPL24sRuhwNHbm3JJ4RGJjhiqMmg6yv7IIdQIkKf5yQXZ1m2Bb6haexSFD0ilTGJX6bVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5MMd5W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5MMd5W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFB7C4CEF5;
	Wed,  3 Dec 2025 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778671;
	bh=9zarvc9YeiikFXRwtcQVR8FtTj3yZk97SEvhqFIcpqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5MMd5W0Sb+N/dGQjeTk3IMezRv2mEiqPZAx2Yiu6iYttzgnWwFg9AozCMbENkG9r
	 YQ8UpyY1Zl1HMZes/MBZHhatoSEOYwd74i9QVAYFiOQIv8qTKnvB17uIpp8gxbc1oO
	 qMBPAay8GApgdNtht1Rr9IGYOSYMx7CGjzonB0f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 024/568] NFSD: Fix crash in nfsd4_read_release()
Date: Wed,  3 Dec 2025 16:20:26 +0100
Message-ID: <20251203152441.547519978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit abb1f08a2121dd270193746e43b2a9373db9ad84 upstream.

When tracing is enabled, the trace_nfsd_read_done trace point
crashes during the pynfs read.testNoFh test.

Fixes: 15a8b55dbb1b ("nfsd: call op_release, even when op_func returns an error")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -944,10 +944,11 @@ nfsd4_read(struct svc_rqst *rqstp, struc
 static void
 nfsd4_read_release(union nfsd4_op_u *u)
 {
-	if (u->read.rd_nf)
+	if (u->read.rd_nf) {
+		trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
+				     u->read.rd_offset, u->read.rd_length);
 		nfsd_file_put(u->read.rd_nf);
-	trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
-			     u->read.rd_offset, u->read.rd_length);
+	}
 }
 
 static __be32


