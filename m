Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23928E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81376C433C7;
	Wed, 20 Sep 2023 11:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210681;
	bh=RKrEIAQ6GO/ThjaCaux1iBeA98zJQumw/jgXmFocg0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWlhVjpD/aDcIN2TgHWvyynCvQ0A9rwkyUJQEndZF+JItKR3vui+p99oJYt3QfDe4
	 b/EWAjJ8X/gKHCXKJrE1x8j7rlbgM/qeOF4OxPqASgZouaS+Jt8mABqfaPF3++ERLk
	 HNDu7mVLf75JN8CpqjCD7NtqHNyllTQo8CGStBnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Cattelan <cattelan@thebarn.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.5 166/211] Revert "SUNRPC: Fail faster on bad verifier"
Date: Wed, 20 Sep 2023 13:30:10 +0200
Message-ID: <20230920112851.033286692@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e86fcf0820d914389b46658a5a7e8969c3af2d53 upstream.

This reverts commit 0701214cd6e66585a999b132eb72ae0489beb724.

The premise of this commit was incorrect. There are exactly 2 cases
where rpcauth_checkverf() will return an error:

1) If there was an XDR decode problem (i.e. garbage data).
2) If gss_validate() had a problem verifying the RPCSEC_GSS MIC.

In the second case, there are again 2 subcases:

a) The GSS context expires, in which case gss_validate() will force a
   new context negotiation on retry by invalidating the cred.
b) The sequence number check failed because an RPC call timed out, and
   the client retransmitted the request using a new sequence number,
   as required by RFC2203.

In neither subcase is this a fatal error.

Reported-by: Russell Cattelan <cattelan@thebarn.com>
Fixes: 0701214cd6e6 ("SUNRPC: Fail faster on bad verifier")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2722,7 +2722,7 @@ out_unparsable:
 
 out_verifier:
 	trace_rpc_bad_verifier(task);
-	goto out_err;
+	goto out_garbage;
 
 out_msg_denied:
 	error = -EACCES;


