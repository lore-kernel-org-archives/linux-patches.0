Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3689E257AD1;
	Thu, 17 Apr 2025 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915055; cv=none; b=N9irnQOincBtqtROn1o/fp5fJ6P7jIP+nXVyDiI4y7SoderjFJTQmYhnP9A04pOwwujqpTeaOXx7mAZyQUGnyIX7tXd2fNycZwYNboOhDse/3/VD7zot1/wdudawjNcb9Mbo5cVDBsdA3Mtz/1Jk7qcOXv91DHHDKQQnmYJAaIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915055; c=relaxed/simple;
	bh=UgtfDeboa4mQ8SLLBkXR3/oGC+FrBhtjROA0+IfjVck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1RzBj5YW6Mr5YCkNj7MI1c0rOECkBfzv0gfGIqUaOhnb3B41QdQinGAkHnLpBtrdknox/E2are/HdjtgILiQIUwe95eLgzTUEbQonh6UBvL2PiCfuTHAv5m1QHaL5hQ8W3tqPxO9qsR5s/2wHO+jGXeig7XH3nOF9T0nQ2s3QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUXCioj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUXCioj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C0CC4CEE4;
	Thu, 17 Apr 2025 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915055;
	bh=UgtfDeboa4mQ8SLLBkXR3/oGC+FrBhtjROA0+IfjVck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUXCioj6KdjOgJp/yjLt90P4EIdLWv2YrVlF64Im1ktlUu8frsZ1FxLVct0Cg18nm
	 5t59AmbEfvpeZHQG7Hk+RqCPtF+PqRWZnl0Ewwlt1vpU9H0GvJ9fsj4KpPve8fa/7T
	 j9giu+Q3Riyx1mbv+oQDHReGDs39P/HoZk+LmxJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 409/414] NFSD: fix decoding in nfs4_xdr_dec_cb_getattr
Date: Thu, 17 Apr 2025 19:52:47 +0200
Message-ID: <20250417175127.932004749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 1b3e26a5ccbfc2f85bda1930cc278e313165e353 upstream.

If a client were to send an error to a CB_GETATTR call, the code
erronously continues to try decode past the error code. It ends
up returning BAD_XDR error to the rpc layer and then in turn
trigger a WARN_ONCE in nfsd4_cb_done() function.

Fixes: 6487a13b5c6b ("NFSD: add support for CB_GETATTR callback")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -647,7 +647,7 @@ static int nfs4_xdr_dec_cb_getattr(struc
 		return status;
 
 	status = decode_cb_op_status(xdr, OP_CB_GETATTR, &cb->cb_status);
-	if (status)
+	if (unlikely(status || cb->cb_seq_status))
 		return status;
 	if (xdr_stream_decode_uint32_array(xdr, bitmap, 3) < 0)
 		return -NFSERR_BAD_XDR;


