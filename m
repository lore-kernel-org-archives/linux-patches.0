Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DA244693;
	Tue, 11 Nov 2025 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822038; cv=none; b=q8I5Aj36txAtNmeoeYbuTA4Xu/KZ43wsIh517CiI1gqC+ljVU3k1190VFkZpc9eFTc/bf8pNqQCQFoAUsNjheHn/HWFqXexZW2lVIV5E/CVhcH3asGK853b0p5xA2p07VGJuUktQHAukJXuCTFdvegx9EpV9tWMQxLY/w8+dBZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822038; c=relaxed/simple;
	bh=w9EHiAXtZaRwZf36WgAB0NZbQ4DrDzTdCn8Di7krVUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2PFk1hBL8eU1xbjZpjyATgQxmGlAXDTiZ0/zs1cZy3ruZl9EB7IkKyCLALI+l2NThKmBAS6RP+BG+vR204bo2t3FERQbq8yEJY8ZknaYaENzZ98TPPcz+jir4Dqxx0r8u6at13J8P0OSK6lo/Zku0pOETVQehdPRDudqvMsQqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOZJmGWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOZJmGWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AB1C4CEFB;
	Tue, 11 Nov 2025 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822038;
	bh=w9EHiAXtZaRwZf36WgAB0NZbQ4DrDzTdCn8Di7krVUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOZJmGWQP0vAIMXJQgzdFGkG48CFQOgTmn3knhGFLN7U4BB+QZQbS9zQWMn0BjslD
	 8DFhON37WyClM3JE6d0ZIcEzdHuIwnPPWjXWjZc5qKtUT4Rca7xD4fK7xJKEI+sjUO
	 jn/kESSFoCyz7Z4Gy/1Mogkgsa9KF3LzxwEiCdLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 001/565] NFSD: Fix crash in nfsd4_read_release()
Date: Tue, 11 Nov 2025 09:37:37 +0900
Message-ID: <20251111004526.862105989@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -982,10 +982,11 @@ nfsd4_read(struct svc_rqst *rqstp, struc
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


