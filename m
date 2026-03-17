Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACAF15E5BB;
	Tue, 17 Mar 2026 17:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768477; cv=none; b=RYq1lzW04MpGC4hJfGEu3Rygp4RaUr2CsY0tDbj/eNQBu2DxKyZtzWajWj6deGaUSyQvkhvxDkdguz3AMGMt01MDnGIBuBre9ITqCnbQgEt4CLT0cQS5+222FABuoAAawiN4SVz+EQPQrEtE/bvwwPkHck6pdIFvfeSjwA9UCS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768477; c=relaxed/simple;
	bh=q201tWn09Xb++Yf+i0GtOSw6E69Qad9yxJz+XQF16F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOuFUtElYTNAd+2XnvGsedCPwZM79fe4M04MYiOgiBNnS3/KKARQn0lshjgGkXZOSSFyyjHwxg4CCovi9Lss4GIKs9pP8ghvNK9e/63IfTamaM5zwLlBnMVfKlZwcTw9PcKxRGs2B0R7RYfJ2m7cf9F6igOc+/OBeD4D2t04UuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQvXocKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQvXocKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2735C4CEF7;
	Tue, 17 Mar 2026 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768477;
	bh=q201tWn09Xb++Yf+i0GtOSw6E69Qad9yxJz+XQF16F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQvXocKCVOOB/FPF9e+ftd97fhTjy7QPuTuGs7PMla1axxfpVH2kWQCIbYWsuWkXK
	 0i0HCI8ls/nYn+xY4ScOtQKiIbhRgBBkGeUYIyPD/Ss2ebSfROQRgMraRhoFu580EA
	 ZsphtU8fM0WB2t/Um2MuWbYC/+FWJxQZr4U/qoPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 285/333] smb: client: fix in-place encryption corruption in SMB2_write()
Date: Tue, 17 Mar 2026 17:35:14 +0100
Message-ID: <20260317163009.959172181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

commit d78840a6a38d312dc1a51a65317bb67e46f0b929 upstream.

SMB2_write() places write payload in iov[1..n] as part of rq_iov.
smb3_init_transform_rq() pointer-shares rq_iov, so crypt_message()
encrypts iov[1] in-place, replacing the original plaintext with
ciphertext. On a replayable error, the retry sends the same iov[1]
which now contains ciphertext instead of the original data,
resulting in corruption.

The corruption is most likely to be observed when connections are
unstable, as reconnects trigger write retries that re-send the
already-encrypted data.

This affects SFU mknod, MF symlinks, etc. On kernels before
6.10 (prior to the netfs conversion), sync writes also used
this path and were similarly affected. The async write path
wasn't unaffected as it uses rq_iter which gets deep-copied.

Fix by moving the write payload into rq_iter via iov_iter_kvec(),
so smb3_init_transform_rq() deep-copies it before encryption.

Cc: stable@vger.kernel.org #6.3+
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Acked-by: Shyam Prasad N <sprasad@microsoft.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5172,7 +5172,10 @@ replay_again:
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec + 1;
+	/* iov[0] is the SMB header; move payload to rq_iter for encryption safety */
+	rqst.rq_nvec = 1;
+	iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
+		      io_parms->length);
 
 	if (retries)
 		smb2_set_replay(server, &rqst);


