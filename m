Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540532BB17;
	Tue, 11 Nov 2025 00:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822088; cv=none; b=bl9AHHN9XOAst/ijbJ71C+NkICsS5uA4HdrUlKuxgCCqvMeNqluCFxW98jDAnEMoUgX5VYW9ysGWfZW9/IFcPASoXByNgKXP6P5v57ZoxkGf7wYQzTyCFd5shywmnF7TqSjK26XeR+ZN1HLQm3BJRyOS8nW8D5X6oc0otpE1E+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822088; c=relaxed/simple;
	bh=bcJ3qbmr5dascvKcEGYzq8zjCzQ4eq96Uc4/I5yAnDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldiEx4qM/jA7z+jNBUh34S7BAhqc0T8Q+k7MNFeTeSTH7TDJTXi6ArR5YuLV3zq2IxsngSBFg8n9lhPyN5vL7oTPfJhGWlL9uW0p8Sgmz8LvfJmb6OSm+3SdzKvjyLFK9GPBjF1Xeffjtc2eaPQ8nTAiPjsXSkz6GhS3qYFoLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0w9Jzdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0w9Jzdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823AAC113D0;
	Tue, 11 Nov 2025 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822087;
	bh=bcJ3qbmr5dascvKcEGYzq8zjCzQ4eq96Uc4/I5yAnDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0w9Jzdd9zXVy4q7xUkiRkubPPW5xaE6rzSkT9Ypi2N1vHm6f7hdIiPYSTlEDCzVz
	 tIxjCCLMNcE1hd2GLc+fHcAuubiVqSbBg7cR4dh2lJL7AFGscPnPOhkYEApGw5exaO
	 +yuaeFO3jZ/e+hW82FoDttjEF8CVA2j3EqObwlIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 004/849] NFSD: Fix crash in nfsd4_read_release()
Date: Tue, 11 Nov 2025 09:32:54 +0900
Message-ID: <20251111004536.569758099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -988,10 +988,11 @@ nfsd4_read(struct svc_rqst *rqstp, struc
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


