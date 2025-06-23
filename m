Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086A1254AEC;
	Mon, 23 Jun 2025 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685583; cv=none; b=K2PlW/ZsuCkZqVXR+3xHCmUzvyI9QnLQKv8YgDN/6PsY8ieqOmTYFN7N9BZsgQfL4jh7dbHXpt8E031SuEffLCsKAwqmE8zVUwIOzrsV5dgCp4NLj4WNJzpcnRHQDkBsI32/AlY+5r9TXqzTi5CcNZQdIBbLF/jyS971f8PKpgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685583; c=relaxed/simple;
	bh=hcJDqM8/Mrezs7heiUuB9lthKdZhVcMWKKMyDReow2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzWjP9dLL0OyeCu+GlmT9IEPHtfWdibQuG70PZ5rf58+0fYLouP12uqxAUKzFjWsk2lZpn5m30uehbagZLv0Qpf2QVNVm8CvbWXOxJY53mCZEudkL+Ia9/ldWHSzszkbe4IK/0DaISXLGeJtkA+KHu+O/wRZVVW0/zOqdG9//ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BK/yI1Eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BK/yI1Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEB0C4CEEA;
	Mon, 23 Jun 2025 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685582;
	bh=hcJDqM8/Mrezs7heiUuB9lthKdZhVcMWKKMyDReow2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK/yI1EojWi4psy8YEA4KuDFARkw8bA4/cZWYlqKosAYRejSiV9JjJqutGS9JsFIK
	 oJjolV7uVHKBCRg2WFuvqmNNxmlEllYa0FX738bQbnJb7tG+qqkwuv7qRnbW7uWomL
	 TYFtQAs5xY7fKNem5Rn1fUOZCNT1BwSGWf1h3WAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 105/222] nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request
Date: Mon, 23 Jun 2025 15:07:20 +0200
Message-ID: <20250623130615.272504326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit 1244f0b2c3cecd3f349a877006e67c9492b41807 upstream.

If the request being processed is not a v4 compound request, then
examining the cstate can have undefined results.

This patch adds a check that the rpc procedure being executed
(rq_procinfo) is the NFSPROC4_COMPOUND procedure.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2750,7 +2750,8 @@ bool nfsd4_spo_must_allow(struct svc_rqs
 	struct nfs4_op_map *allow = &cstate->clp->cl_spo_must_allow;
 	u32 opiter;
 
-	if (!cstate->minorversion)
+	if (rqstp->rq_procinfo != &nfsd_version4.vs_proc[NFSPROC4_COMPOUND] ||
+	    cstate->minorversion == 0)
 		return false;
 
 	if (cstate->spo_must_allowed == true)


