Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC1136988;
	Mon, 23 Jun 2025 13:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684369; cv=none; b=eBByWVsdKbHmqUmqgT9izhdiESU7YrUos8Dn6eZuj03weU8GNQMg8tgbr/ghLpVTUCqJlNVwz/TKK9+efwmIk447t+y/744U/SKkjOGxDF1Uq001DDj30DCtOyKEv1UjwdPKSo/R6BS6AcgvcoDwUiQoT/Eyy2ANwYjQiWZneT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684369; c=relaxed/simple;
	bh=6AAyiXzcfljFWomO1Mge0DTX31C356xRL9Uu8V5/VK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyiRoxHKWMDj+82WzFfuib8hU0HRw0IQNuSXolZYYYYQWhfwvS6/7vdX8afxHgGQ6U+itVLe3ruK4PERG9lOR0Wgm1cx+yIGcUt708bm5FKZ1WvrsOj7RubTPCP2ehU3ACqRVFMCmN4ScRqhiu+8907y4JCh7WXvzqT0BiK6plo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VP/nSKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VP/nSKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A6C4CEF1;
	Mon, 23 Jun 2025 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684368;
	bh=6AAyiXzcfljFWomO1Mge0DTX31C356xRL9Uu8V5/VK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VP/nSKGSMj7+KBc6jdJQVDUbottlJE/yLfWX2fHzb9vhFTCJ9Q//K0cuWZwzNxJX
	 iU4LUxZ9Fa92XctwGJaHdj4WmpAaqbBuqah1GsmwLmbRSHT/4h5Nf4xj95yliOUFqb
	 l+9ZFzIqVWl4IenRAzyyidfakDOYnQmOHz4nBcow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.15 043/592] nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request
Date: Mon, 23 Jun 2025 15:00:01 +0200
Message-ID: <20250623130701.270172994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3766,7 +3766,8 @@ bool nfsd4_spo_must_allow(struct svc_rqs
 	struct nfs4_op_map *allow = &cstate->clp->cl_spo_must_allow;
 	u32 opiter;
 
-	if (!cstate->minorversion)
+	if (rqstp->rq_procinfo != &nfsd_version4.vs_proc[NFSPROC4_COMPOUND] ||
+	    cstate->minorversion == 0)
 		return false;
 
 	if (cstate->spo_must_allowed)


