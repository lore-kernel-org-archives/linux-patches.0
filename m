Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F153B3C11;
	Mon, 23 Mar 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278568; cv=none; b=D/goBx5a9fgSCbkJ9N8wPm4o0dWXlK+I1V7tj1c9h2/I62+l5IVnjQ8xhHtHQeQSTZL2JkKwsfYoBjkW28Z4OOByjIYepf6oM/ZhCQxOtptxhLnZ7dxkTp2bABQb6wz5obAD6ZBwSqfwiW5yKdxs1lyOu0oBIfiQ846gLCNE/9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278568; c=relaxed/simple;
	bh=V4Y5iOlsOkwoAafsxVjKfTtKoZ8BnKeJHjOtI+kK8kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ku1K7xkI9sRUCtx0zqiXQdhZksjsjGbbG1De6HH9xVAzOQajJ+bhlkU9QTMPfLSx6oCFnfRHNJnwv9Qc3cfO3t6nJa167RvvDS9fEN+GDFWbF2QBQ8a2P0hlAJTgZTpzynFb6tLTdZrVKzcdsJKNKujpv5YuHI5Evq+kFNYTjEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5+Xz2hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5+Xz2hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FFAC4CEF7;
	Mon, 23 Mar 2026 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278568;
	bh=V4Y5iOlsOkwoAafsxVjKfTtKoZ8BnKeJHjOtI+kK8kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5+Xz2hA3Q4/s+6e4NIQ702KGK4vm1fHqijqraPlhN4UrczJ/Hh7OrdM5snEBl0E3
	 wJ8E+IDUKXeijDgae6FuxwByRioaPKOASHmK/7moYarIVbebr2IDZhLtDPYzhrc9At
	 ZB1oJfGyLwOmU7j3FgsM2gppKlRSDb1tMK35CHNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 349/567] smb: client: fix in-place encryption corruption in SMB2_write()
Date: Mon, 23 Mar 2026 14:44:29 +0100
Message-ID: <20260323134542.471113444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5073,7 +5073,10 @@ replay_again:
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec + 1;
+	/* iov[0] is the SMB header; move payload to rq_iter for encryption safety */
+	rqst.rq_nvec = 1;
+	iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
+		      io_parms->length);
 
 	if (retries)
 		smb2_set_replay(server, &rqst);


