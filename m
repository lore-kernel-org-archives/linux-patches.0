Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF0158D72;
	Tue, 18 Jun 2024 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716305; cv=none; b=Vuy69bTQGSsNALOIBUq9kKfCiFtczZJYACLRnB2lgZPHrDC7eYq+9mUiEfpTq15mKvE+4ZgS1g8AykjZllhOyEsNKHoigRvWdzJCbP8fyJp+QxIfwF7A88nG8FIGHh9HsTzuGbhwvrAsWOLnwzaKs1TTYE02tHRoY5Ew+CBVSLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716305; c=relaxed/simple;
	bh=u+jaebYJBKjnL1SMdz6orvT42AqbfIz0b0BGG2nVeso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpaAzGFwG32a2RzK/ojTbd3/Vrjw2sPTJ6ksJgpa0jA8j1aJ9xhJsU43GX7PGbBHLYbL5mFNbyQ+8FBjUbJKj9sZ4cc/fQaN1/q8vf5srLjYNDj6MLDN/IDnq6uNPTFpFbcx6AKxL2McUuWYiMyCgB2Ud3c2QQ6GctBbkE/ftsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhnLxxtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhnLxxtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069E8C3277B;
	Tue, 18 Jun 2024 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716305;
	bh=u+jaebYJBKjnL1SMdz6orvT42AqbfIz0b0BGG2nVeso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhnLxxtzC9Vvukjh2/3yFBAU80a4OtB0g//TQrEvLhbN8KH+BU4sdf3PkN9nnI/gi
	 nXnrFFCEyTEjYVxqsoTXkEtnJub7szpmlXj8KmXcWbFSmGX1VxqridUteQOThE/hvR
	 +aTfjo8nJeRKrNWuffEky6CujxqCss3W4BUQfyRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 601/770] NFSD: Reorder the fields in struct nfsd4_op
Date: Tue, 18 Jun 2024 14:37:34 +0200
Message-ID: <20240618123430.489468989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d314309425ad5dc1b6facdb2d456580fb5fa5e3a ]

Pack the fields to reduce the size of struct nfsd4_op, which is used
an array in struct nfsd4_compoundargs.

sizeof(struct nfsd4_op):
Before: /* size: 672, cachelines: 11, members: 5 */
After:  /* size: 640, cachelines: 10, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/xdr4.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index c44c76cef40cd..621937fae9acb 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -606,8 +606,9 @@ struct nfsd4_copy_notify {
 
 struct nfsd4_op {
 	u32					opnum;
-	const struct nfsd4_operation *		opdesc;
 	__be32					status;
+	const struct nfsd4_operation		*opdesc;
+	struct nfs4_replay			*replay;
 	union nfsd4_op_u {
 		struct nfsd4_access		access;
 		struct nfsd4_close		close;
@@ -671,7 +672,6 @@ struct nfsd4_op {
 		struct nfsd4_listxattrs		listxattrs;
 		struct nfsd4_removexattr	removexattr;
 	} u;
-	struct nfs4_replay *			replay;
 };
 
 bool nfsd4_cache_this_op(struct nfsd4_op *);
-- 
2.43.0



