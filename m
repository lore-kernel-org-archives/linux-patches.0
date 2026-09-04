Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE8412BE7;
	Fri,  4 Sep 2026 05:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498782; cv=none; b=MPxFvOjFGrnEO4OCOiWTA4Mj1hMCDUy8hPtq+uB9m25DWXKErpxqkW3/D8DOPQb3LHlO9AQy6bIK/8YRzQfr4aaj6a5VxoTM+Ehsi2j7Jwuv+2E2BQ9MldOze1F3pYCKs2xnt0ng3bRoyfyN0cnVinwYJebBJHUXxGzR6b8aFpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498782; c=relaxed/simple;
	bh=9DP4EVF7kXuV89vTE9YPMu8ZG/jUP8tXCKOY/SIRafY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duF2LUVfarSbaF9TaINVuCkYwUqiewj7dHOmKXmksFJSAC5MlAxcRBuHQSFC+utl/WjqSV5hreMpYLh8PbAJPXKzJ8pXzEMrWGvEKIzkZ1L/8Q2MVtzhucQRsiRKMtnBuEvMR4nwJCtYYb+X21FmasHPxppdfLn7XmlaH20lP40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGfHecEN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGfHecEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F185F1F00A3D;
	Fri,  4 Sep 2026 05:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498781;
	bh=Yu0dwmzqyckXN2q2ROWZ247P4S4qK8aNNJ0ipqYMwAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGfHecENjKKnU6+MWN2v3DShl0mMsagYewclrKI+ggCaXfVoaKFFrXpulrrJIijyM
	 NDqaC44+kTuDV8sYV3UoNvucGBiFeCe6QJ7N6pyyt1DsZ0IxbNHEJGPQMH4pWBWPai
	 z0GqhxLqSFyAvErPe0lcRawvwCv1q4NPqbltHWnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 186/713] nfsd: fix partial-write detection in nfsd_direct_write
Date: Fri,  4 Sep 2026 06:52:34 +0200
Message-ID: <20260904045807.984097960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit 250ec14932d5cfe102f68a57892bb566eee7f83e upstream.

nfsd_direct_write() walks a list of write segments and, after each
vfs_iocb_iter_write(), tries to detect a short write so the loop can
stop before placing the next segment at a wrong file offset:

    host_err = vfs_iocb_iter_write(file, kiocb, &segments[i].iter);
    if (host_err < 0)
            return host_err;
    *cnt += host_err;
    if (host_err < segments[i].iter.count)
            break;	/* partial write */

vfs_iocb_iter_write() runs the iter through ->write_iter(), which
advances the iter by the number of bytes written. By the time the
check runs, segments[i].iter.count is the residual, not the original
request length:

    before write_iter: iter.count == original_len
    after  write_iter: iter.count == original_len - host_err

The condition then reduces to host_err < original_len - host_err, so
the break fires only when less than half of the segment was written.
Any short write completing between 50% and 99% of the segment slips
through; the loop advances to the next segment with kiocb->ki_pos
only bumped by the short amount, writing the next segment's payload
at the wrong offset and over-reporting *cnt to the NFS client.

Snapshot the segment's byte count before the write and compare
host_err against that snapshot so any short write breaks the loop.

Fixes: 06c5c97293e3 ("NFSD: Implement NFSD_IO_DIRECT for NFS WRITE")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-7-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1382,6 +1382,7 @@ nfsd_direct_write(struct svc_rqst *rqstp
 	struct file *file = nf->nf_file;
 	unsigned int nsegs, i;
 	ssize_t host_err;
+	size_t expected;
 
 	nsegs = nfsd_write_dio_iters_init(nf, rqstp->rq_bvec, nvecs,
 					  kiocb, *cnt, segments);
@@ -1403,11 +1404,13 @@ nfsd_direct_write(struct svc_rqst *rqstp
 				kiocb->ki_flags |= IOCB_DONTCACHE;
 		}
 
+		expected = iov_iter_count(&segments[i].iter);
+
 		host_err = vfs_iocb_iter_write(file, kiocb, &segments[i].iter);
 		if (host_err < 0)
 			return host_err;
 		*cnt += host_err;
-		if (host_err < segments[i].iter.count)
+		if (host_err < (ssize_t)expected)
 			break;	/* partial write */
 	}
 


