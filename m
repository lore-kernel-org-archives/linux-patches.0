Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7498A21D3DD;
	Mon, 23 Jun 2025 21:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714657; cv=none; b=fQ/qOmIQdAtcm6Aef9eSbkNXS/bd5b+IS4ihy1xavuhNtZT9Y6iGn5x1ZyU+5+z8ZOshFEXqSfwfu5oVFpo/X8VbFhfh0oLkEJdBsFAEy5gyaRpWOqKhDbNLHI6yfyACxUGY28mUKSBQAC9gV41qhLuAwUMQD9ymjDKvhqIKK8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714657; c=relaxed/simple;
	bh=U0G4W0YM15Vm4cVQ7+OrMJM5hhRsAokizpuNpRwmBK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es14JJwzWU0hbHzJ4wnAvJZQCJlnfLJ9C4aTALpcq/dqUNRJcOOeUIvOlikg/fjRZheT6d+WVKmUR2bUzYVZhGjNoH7mWuYM9MTG3LQwEbPXAc10UiJndpcIS7LuxmLWmQJE3rw3tg3GXaYgpXztir/MVBOXwLhDf96G9RFobEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfqVsIoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfqVsIoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBFCC4CEEA;
	Mon, 23 Jun 2025 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714657;
	bh=U0G4W0YM15Vm4cVQ7+OrMJM5hhRsAokizpuNpRwmBK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfqVsIoJzzfIZJA26f95dVqogCInzADTZQDcg2wGVniPPrnHkvFGtH+UbcuiVSJXv
	 AELmXQcCrcRNB/FNPSljYJvi9Z+yv3f/t9QQo1PA0leu2tIs8pOJdRL+yYMk+hCD12
	 q7DrXdUeBN/7Ecd21u27o7UYTmEl3RO7lsMt89WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 201/411] nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request
Date: Mon, 23 Jun 2025 15:05:45 +0200
Message-ID: <20250623130638.733705686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3537,7 +3537,8 @@ bool nfsd4_spo_must_allow(struct svc_rqs
 	struct nfs4_op_map *allow = &cstate->clp->cl_spo_must_allow;
 	u32 opiter;
 
-	if (!cstate->minorversion)
+	if (rqstp->rq_procinfo != &nfsd_version4.vs_proc[NFSPROC4_COMPOUND] ||
+	    cstate->minorversion == 0)
 		return false;
 
 	if (cstate->spo_must_allowed)


