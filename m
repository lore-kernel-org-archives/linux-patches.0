Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8081A76A4;
	Tue, 30 Jul 2024 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359951; cv=none; b=YvDtkqtURWMe5rVU+/1ZAp6Jb+0ZM1MvogBjZc5urxtMdivHE53vUdEX2iWP1XFc02awuFG3CX/HKERoKwX7vUFI6ClrHcJyYYDo8V7+MrRbqKhHnfho6WlXG4wD8k+DvTFbHw9SY3NgyLbUe5tmLtdMB4AMRTWz23XsX95MAI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359951; c=relaxed/simple;
	bh=uUshivuwMt2u8I85yYt8Ra5W/1CzlGGXeQbZYslywd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRduDqflNkH6dgnWfSG5WZ7p6uClH/iUFbF2+3M/cX9vQQBfmIAjUnWkxqsfIUB9ZFo+nMUNVf8vuAlhz49WOpWtDeKB+K7bRNzBUlsDg3lMS/U+CoCSnqsa/OctD7RsfeI8QgS2fOCadw8YaQyll6ekjVBstsd/yc3t9PtjlN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlovGSNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlovGSNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCA8C32782;
	Tue, 30 Jul 2024 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359950;
	bh=uUshivuwMt2u8I85yYt8Ra5W/1CzlGGXeQbZYslywd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlovGSNY55ycFxrXHtaLLQT47nCd2twDtAfiudXEPTcTWhq43KqRyZHgvQA1ojJzf
	 IppF/OYvJraCNFO3cGpI4/HAm0rPcLihuAJbAq5eoo8010LjMwwB+80YaYBfkTm7+S
	 fECirqr7WAJpv3SfrGC7epFxor2cTybiiuOAR7Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.10 558/809] NFSD: Support write delegations in LAYOUTGET
Date: Tue, 30 Jul 2024 17:47:14 +0200
Message-ID: <20240730151746.800250245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit abc02e5602f7bf9bbae1e8999570a2ad5114578c upstream.

I noticed LAYOUTGET(LAYOUTIOMODE4_RW) returning NFS4ERR_ACCESS
unexpectedly. The NFS client had created a file with mode 0444, and
the server had returned a write delegation on the OPEN(CREATE). The
client was requesting a RW layout using the write delegation stateid
so that it could flush file modifications.

Creating a read-only file does not seem to be problematic for
NFSv4.1 without pNFS, so I began looking at NFSD's implementation of
LAYOUTGET.

The failure was because fh_verify() was doing a permission check as
part of verifying the FH presented during the LAYOUTGET. It uses the
loga_iomode value to specify the @accmode argument to fh_verify().
fh_verify(MAY_WRITE) on a file whose mode is 0444 fails with -EACCES.

To permit LAYOUT* operations in this case, add OWNER_OVERRIDE when
checking the access permission of the incoming file handle for
LAYOUTGET and LAYOUTCOMMIT.

Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # v6.6+
Message-Id: 4E9C0D74-A06D-4DC3-A48A-73034DC40395@oracle.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2269,7 +2269,7 @@ nfsd4_layoutget(struct svc_rqst *rqstp,
 	const struct nfsd4_layout_ops *ops;
 	struct nfs4_layout_stateid *ls;
 	__be32 nfserr;
-	int accmode = NFSD_MAY_READ_IF_EXEC;
+	int accmode = NFSD_MAY_READ_IF_EXEC | NFSD_MAY_OWNER_OVERRIDE;
 
 	switch (lgp->lg_seg.iomode) {
 	case IOMODE_READ:
@@ -2359,7 +2359,8 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 	struct nfs4_layout_stateid *ls;
 	__be32 nfserr;
 
-	nfserr = fh_verify(rqstp, current_fh, 0, NFSD_MAY_WRITE);
+	nfserr = fh_verify(rqstp, current_fh, 0,
+			   NFSD_MAY_WRITE | NFSD_MAY_OWNER_OVERRIDE);
 	if (nfserr)
 		goto out;
 


