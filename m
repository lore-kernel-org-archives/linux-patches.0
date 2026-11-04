Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829149;
	b=F2YZP17gQj0fMDTfRp3ekcbgCYxgnnz414+LLYMBo9TXoA+1iRUGzUq1/68BAk7+sRhr
	 p2j5uDZbnNIJmKrcPChf0Pc+uxrZ9cfsvm4/rmAmTWzPjxw93pT0Tgg+5E2gh5gCTVGUT
	 HtGJE+kL+gGnfG41voQXnPpjPrs4OoYZUNmSCwdhKi1b8bJ90/0gt9Sh41FZk2DJTdHKc
	 66wTwNOMyBXsxoPSzjbsaWJRaTOU3fgTYHjN7auBpGrVn8rqzypkC0tkilWW1HKAV6Uyg
	 9POmIHCPXwikOw+oYpGS9tnUiBE4SPOmH7zMNudr43fMNOC81yd0hJ1FkhoS7Tq4LSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2lyNgpt1TFY+wtTsKJ+il3sS7orFAi+5qVmgnXg3Ao=;
	b=mDNi3eepdrUnmzl3PQ8TJIZkBClSQ8xZ+GGZeuQxobR6tXTxaDMwG+V7+sST2zvGmd7X
	 9AnCszGQlz9bs2SJSvpRzvlxxCYW7Mr7HuMRAVmqkGEvUTjavu3Wi+4zdJi4nKfvF/mth
	 kCB244XEk/FMcPhZfnLoGTeou7M4gE90YuPeXpjld/muTHIbqFmXrntyegn49QyZtl7Rr
	 e0QMRmrMElpe+4hgUD6iMs3RMcCR1uoHHAxAkGM3qD1RDVfLXcjasvw+r7OURdQzxuerG
	 wxBP/5OfjZOokYSLu+yxil/oPpg/LSJdzrHlwS/F/PY8+RdP6RCrXnodR4hgp9LBo3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thBLCtQQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6312E607031A;
	Wed,  4 Nov 2026 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thBLCtQQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52F1F000C1;
	Wed,  4 Nov 2026 21:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829149;
	bh=u2lyNgpt1TFY+wtTsKJ+il3sS7orFAi+5qVmgnXg3Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thBLCtQQvfYhIED99TNCVi5vIwB3zeSxYcaTkNRg/lMHyxSGUXNjmXlbutCa5guPy
	 E39d0UvcXbfCEfunJ5ll8SW+/CGz/KLaD5sPr8k/iZT6d0ySPzaMpTQ1mvuA7xf1rK
	 IhGMz/+IylVcTzUL2CK0VKH4W8hdCE+aJ5/YTudk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 438/547] SUNRPC: keep the first error in svc_register()
Date: Wed,  4 Nov 2026 16:10:22 -0500
Message-ID: <20261104211050.791308382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9ed91d7c4698e611ea5bfca45076008def831fb3 upstream.

svc_register() assigns every pg_rpcbind_set() result to the same "error"
variable and returns the last one, so a later result erases an earlier
failure.

Keep the first error instead of the last.

Fixes: 642ee6b209c2 ("SUNRPC: Allow further customisation of RPC program registration")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-3-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1208,13 +1208,16 @@ int svc_register(const struct svc_serv *
 		struct svc_program *progp = &serv->sv_programs[p];
 
 		for (i = 0; i < progp->pg_nvers; i++) {
+			int ret;
 
-			error = progp->pg_rpcbind_set(net, progp, i,
+			ret = progp->pg_rpcbind_set(net, progp, i,
 					family, proto, port);
-			if (error < 0) {
+			if (ret < 0) {
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
-					progp->pg_name, i, -error);
+					progp->pg_name, i, -ret);
+				if (!error)
+					error = ret;
 				break;
 			}
 		}


