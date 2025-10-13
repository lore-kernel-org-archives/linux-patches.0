Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB2E30C366;
	Mon, 13 Oct 2025 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367947; cv=none; b=nscDywjeIAZRLX0aliP4CSZ26iHNs7XBMZC1o6mXMNUd3ZnoCyDEWTdpxeKMNibPusQ1W+eVztK+Gkl9qciY7TD9t3Vb0mIi9jaCdch76BeYbcPwfrWmuxxV4ECruZQLs7J1pYOWLI7u1Rn/CP4uGmrRFaBW4l4ZTf1/yLQTlJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367947; c=relaxed/simple;
	bh=BXdePOZK4l0gKWc57ac8RDlYEyyouEJAVXqPwi2Jjk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zqe0Lo8m2TqeOnLLUcCC2laVh85PUmluunYMxdLke/BNwfF1OfzzcempbHPYRTNo8srGfcENLiLtVY2rIPEzarq2PhcFr9AjjNAVElK0Nr03qNKEzwvvoF3f2R7Z8yvnJBMd/sZHhn1PJzzkNTAhP79ovwMmHzvdHSAaVgoocjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABdnJmGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABdnJmGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7391C4CEE7;
	Mon, 13 Oct 2025 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367947;
	bh=BXdePOZK4l0gKWc57ac8RDlYEyyouEJAVXqPwi2Jjk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABdnJmGdtvYsh6fajrWRZuTt9M9zvxsIYubT1UMDK4jpfW9h4ThLVQbhv8TnTN0rS
	 LIVkQyY3dTRj3kJxMEJNoS8TRbcENO01i4pj7CUcGXfAdrIWA+Dp7jWD6noiI3cbyc
	 La9k6gY6Cz2Co99lZe86m12I1LMfSD7ynOtFXDJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Lei Lu <llfamsec@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 189/196] sunrpc: fix null pointer dereference on zero-length checksum
Date: Mon, 13 Oct 2025 16:46:20 +0200
Message-ID: <20251013144322.143542465@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Lei Lu <llfamsec@gmail.com>

commit 6df164e29bd4e6505c5a2e0e5f1e1f6957a16a42 upstream.

In xdr_stream_decode_opaque_auth(), zero-length checksum.len causes
checksum.data to be set to NULL. This triggers a NPD when accessing
checksum.data in gss_krb5_verify_mic_v2(). This patch ensures that
the value of checksum.len is not less than XDR_UNIT.

Fixes: 0653028e8f1c ("SUNRPC: Convert gss_verify_header() to use xdr_stream")
Cc: stable@kernel.org
Signed-off-by: Lei Lu <llfamsec@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -724,7 +724,7 @@ svcauth_gss_verify_header(struct svc_rqs
 		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}
-	if (flavor != RPC_AUTH_GSS) {
+	if (flavor != RPC_AUTH_GSS || checksum.len < XDR_UNIT) {
 		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}


