Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC713F4101;
	Fri,  4 Sep 2026 06:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502241; cv=none; b=nIgWraSqDv8n0Mgt2QEecjpTzz9H1Aom+7lxQsyLqWTrtlf2aEJnTY3jSj3aac0oitXUwU38gm3LkeMx8zvNCiUyHam8UCkopYgBFZnAo5Je3+T9lo1eYXlxkrspmlpvmVNjEg5ay4dqI9Aayd9UrthxGNmDGf4dbjDwCK8fI30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502241; c=relaxed/simple;
	bh=5Blh5QcPYXRyRq9opDWaqCyb6tggkcH9yFhWKU0kRrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5tfL+5gsIMMTKYkGfRftttmR5Qm6DNFkN2uRCH8vKaHieGr/2RUIpEAXyaCGTf0ko9tEFi7MAHsK5AK4CJyYCyI/mkJIhRJqhAr5jaHTSLDxUTnwMtw9rvxWl+SfkkO3Hk/97g+WsmPrEQ8peW3zKmuB9JTsudvQa5Yh/u5k4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc7iaX02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc7iaX02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396DA1F00A3E;
	Fri,  4 Sep 2026 06:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502239;
	bh=iIbs4am+0Chec77RcSwJr9ya/LQ0Xp+AM3L7Qz0AT2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc7iaX02TUPXiJRDbshNS24X+SHtzn6I3wGAnHzK8fU5Soz1r0gSlFUoihjtpEczf
	 HX6YZf0Slejioiky0Sd8jkcgkABF6dFz5erBIeXsks2yBaT9deznA5BXJhVaj2J9eA
	 sSR+MSUaSi2wI62kuqA4y1wRl1+6rqp0hnhxkA0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 095/403] nfsd: fix reply size estimate for GET_DIR_DELEGATION
Date: Fri,  4 Sep 2026 06:58:18 +0200
Message-ID: <20260904045736.993693554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 46f929b907b3bc488593c006f0c97e35baba9ea4 upstream.

nfsd4_get_dir_delegation_rsize() returns its estimate in XDR words, but
the COMPOUND reply-size machinery works in bytes: every other op's
_rsize helper multiplies its word count by sizeof(__be32). Since
GET_DIR_DELEGATION is OP_MODIFIES_SOMETHING, this estimate is consulted
before the op executes to ensure the reply will fit. The ~4x too-small
estimate lets a compound near the session/reply limit pass the check,
grant a directory delegation, and then fail to encode the reply with
NFS4ERR_RESOURCE/REP_TOO_BIG, leaving the client without the returned
stateid.

Multiply the estimate by sizeof(__be32) like the other _rsize helpers.

Fixes: 33a1e6ea73e5 ("nfsd: trivial GET_DIR_DELEGATION support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260616-dir-deleg-v7-17-6cbc7eac0ade@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3141,7 +3141,7 @@ static u32 nfsd4_get_dir_delegation_rsiz
 		op_encode_stateid_maxsz +
 		2 /* gddr_notification */ +
 		2 /* gddr_child_attributes */ +
-		2 /* gddr_dir_attributes */);
+		2 /* gddr_dir_attributes */) * sizeof(__be32);
 }
 
 #ifdef CONFIG_NFSD_PNFS


