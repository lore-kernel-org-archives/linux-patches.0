Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C347642046;
	Mon,  8 Apr 2024 13:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584300; cv=none; b=b5lMlmaFL3wdQbcJ/xXUzlgxWaYx+4lwmdwhzMJF0QJJdYc8GcTaDDtMkVwogGcJBitPjVN+BW2w6eQ0kc9k4WTwJ5uVebmW41zQymxRMYR8kB2EtavOJuuqIlZyIZV+LMGxvqUIOLyOc7/H/EQgswZACdErXK7t/HPrA8w36QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584300; c=relaxed/simple;
	bh=EVBSnpZJg2LPI7XjGpB5ie7PH3TQSJwCxS3HpaK5V/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOBR/s2AiXAf1aeJWc6SA13xM8YvLiK9/TPwXJGilZVgosGZvuJsKf2GTGtKwX5thULVGNP0AOLLogk8fhxbcNxqtR449KyOl2pQRVPgXomoiAdrT0eG505HSAzSfDCUiZE4bI3OlJng7ALSxV8S6C/+fMAsgIKg6QVB3FohbRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6uZX24N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6uZX24N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCA3C433C7;
	Mon,  8 Apr 2024 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584300;
	bh=EVBSnpZJg2LPI7XjGpB5ie7PH3TQSJwCxS3HpaK5V/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6uZX24N+oAWQpO+S+hrhUXdSMFj6fIQ/VXJAiGU82fdvSB8czv5RTfCix3IFkI3x
	 cxvoKBFsIDnIIKVSVSiOceekG+GfflL5jHDAoL+1mQg1tqYkH5uuiXI6sj8VxsyZ+H
	 vfrkmkEWJDpclpIK8VdGxEb7AdpWgr1ZJ+AuF93k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 392/690] NFSD: Reorder the fields in struct nfsd4_op
Date: Mon,  8 Apr 2024 14:54:18 +0200
Message-ID: <20240408125413.730580390@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d314309425ad5dc1b6facdb2d456580fb5fa5e3a ]

Pack the fields to reduce the size of struct nfsd4_op, which is used
an array in struct nfsd4_compoundargs.

sizeof(struct nfsd4_op):
Before: /* size: 672, cachelines: 11, members: 5 */
After:  /* size: 640, cachelines: 10, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/xdr4.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index ed90843a55293..87b4270af59ef 100644
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



