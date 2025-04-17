Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90101257452;
	Thu, 17 Apr 2025 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915058; cv=none; b=LRSSVrgXNVMVQIOHvRo8k6kx1Vxlln2ePmPYZoGdD8/qU3mctaEId6YZAWj3TIXPQeZmDL0WSrpcRGN+5X1KfU1f0jWcVNEZOUQ7G7z566zp1yq6IePhj9VWzMqHfs936V9CWRAgvcxHuCh8mZmPq0KRLxtzV5yUDVdo54FD8r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915058; c=relaxed/simple;
	bh=hGz4UTRzNZlbXIaZFYWlJSBMLzRLqfwZMFjclnF0fj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfcTlsCMNJNuCspn2d3bTuHwFeAbu2VtdQkvmfY/ovDLEjAzHG0faqX9dClb2BtLc4B6wikyLliBZC/B7o/e1J8pA5NrQ36Tz8G4hFr8Sk3XWoCMRYJFqaiqSWHnXecooJ2JqjOTsR26CgIUS7B6NNRqVl9bwkw5V9pbnVsBqQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8zsc1qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8zsc1qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED56C4CEE4;
	Thu, 17 Apr 2025 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915058;
	bh=hGz4UTRzNZlbXIaZFYWlJSBMLzRLqfwZMFjclnF0fj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8zsc1qh00K3XvZSD7Wk4Cpd24X/Cz/q73ZXEISbzJGSkJLZ+otn1iuN1nWOX/ONB
	 eIjpbC7L+pnIrzUJTej15hHjZQLshQ653c16t67A38Jl8SZZ2BfI1wPMSO33Q/dp/5
	 xYB3n3LKM+0VuoKpv04XobYi0vkJajX7wAT9IgNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 410/414] NFSD: Fix CB_GETATTR status fix
Date: Thu, 17 Apr 2025 19:52:48 +0200
Message-ID: <20250417175127.973248496@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 4990d098433db18c854e75fb0f90d941eb7d479e upstream.

Jeff says:

Now that I look, 1b3e26a5ccbf is wrong. The patch on the ml was correct, but
the one that got committed is different. It should be:

    status = decode_cb_op_status(xdr, OP_CB_GETATTR, &cb->cb_status);
    if (unlikely(status || cb->cb_status))

If "status" is non-zero, decoding failed (usu. BADXDR), but we also want to
bail out and not decode the rest of the call if the decoded cb_status is
non-zero. That's not happening here, cb_seq_status has already been checked and
is non-zero, so this ends up trying to decode the rest of the CB_GETATTR reply
when it doesn't exist.

Reported-by: Jeff Layton <jlayton@kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219737
Fixes: 1b3e26a5ccbf ("NFSD: fix decoding in nfs4_xdr_dec_cb_getattr")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
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
-	if (unlikely(status || cb->cb_seq_status))
+	if (unlikely(status || cb->cb_status))
 		return status;
 	if (xdr_stream_decode_uint32_array(xdr, bitmap, 3) < 0)
 		return -NFSERR_BAD_XDR;


