Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6C125742A;
	Thu, 17 Apr 2025 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916270; cv=none; b=AHxk93/6e8NjpAogAdLd+j0JRu9TfqAuYKPyxsZZVUujbbtp0bkM8JX3J9T0OOeqaNEK4LHDisaJxl+IleYCDSPi+CnWHK0W7VMSyfT5q1ipdPNZTp8xclKH0TR5joLjnd8pCbGLp0XbDhu4e+ECFSR39Cm8waFMPDdDKiwLL3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916270; c=relaxed/simple;
	bh=0hlPnt1FQkfIx9z3vHgZM7v9joLe+5DvS1zH5Jmv9BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgkCtNlOHCKDx7xkZSzgoPq4Nh6jqaassnFBAifJG2nEFKEnoZYjuO/d/9mxULzIktT9OymEqrWHa8qIYm2mXPRQ9uyQ1Qi4jIWJ6b6fhH97PQHBlaZWKPKuxp45J4aIZAAC/Rghh+9RG6KJDoik/EP784aFHCmaX1Elt7TUYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCeNNaXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCeNNaXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADC5C4CEE4;
	Thu, 17 Apr 2025 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916270;
	bh=0hlPnt1FQkfIx9z3vHgZM7v9joLe+5DvS1zH5Jmv9BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCeNNaXLahm9/uBajIj4zNWLMkkw1you+4HS2UK1Zo3DE6rg4qS9u3x7xEdRFfJEU
	 X2M03GB7kTKZI5MODoknoNHQTIEtUv96wDd45BlTmDg+JuU2ulprDDsmTZ670EgD3S
	 3I+AJDh6+hWS/f8ZA44RjJFbjCDiWeekVqsh3IQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 386/393] NFSD: Fix CB_GETATTR status fix
Date: Thu, 17 Apr 2025 19:53:15 +0200
Message-ID: <20250417175123.133926282@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -605,7 +605,7 @@ static int nfs4_xdr_dec_cb_getattr(struc
 		return status;
 
 	status = decode_cb_op_status(xdr, OP_CB_GETATTR, &cb->cb_status);
-	if (unlikely(status || cb->cb_seq_status))
+	if (unlikely(status || cb->cb_status))
 		return status;
 	if (xdr_stream_decode_uint32_array(xdr, bitmap, 3) < 0)
 		return -NFSERR_BAD_XDR;


