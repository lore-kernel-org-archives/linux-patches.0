Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F237B1DF98B;
	Mon, 23 Jun 2025 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713190; cv=none; b=m5UtbtSBZZhY1ZV1uCQbareGDL60G5G8uZk5hIX/ZNi3gTd1y9qqyecjYZYIFOgpd9wVnvUQ3r9tDrJAkdsyHzEyJsTlJXMdA6ISoA08qvp2lW72UYWdhVaU2PVuzeP3okHhZRz7X7ny+Ojy9AxxzmbRMYsd4fpB+3oANcZGyvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713190; c=relaxed/simple;
	bh=Dect0mPDWo+B5KtR7I9DLdYepVAfpkBy0GBOYInrq1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua3sV9Ph3bnBq3VbZqqMvH/NfbZpASxBzUgK9iTl6kmbsIqLHHTm4zb/+rk2ahiAtxJcieEdBrkyrm8y2AQlhNhMuHszgujJIea4prJm29yjDct8OV3g7GV8l5jLc3WDwg4EYabZ91O7m3tB7+FNeU/oEcVifcd00vJw33/t994=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTyOc05V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTyOc05V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A555C4CEEA;
	Mon, 23 Jun 2025 21:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713189;
	bh=Dect0mPDWo+B5KtR7I9DLdYepVAfpkBy0GBOYInrq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTyOc05VH3viOetjKNLM3O5X7hXgByidU27sQWfZZSc26sprBhROAW19BguLsos4H
	 aCvMUumMGP1va4iMJygq5DGqqp9e36SI2BxEQsr2zWVGpOR1vICrHYyoI0Okt01knD
	 p4qvjHUeHgS7AJLo3NIRndU/i5FATokRcukTm6LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 031/414] nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request
Date: Mon, 23 Jun 2025 15:02:48 +0200
Message-ID: <20250623130642.803757931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
@@ -3658,7 +3658,8 @@ bool nfsd4_spo_must_allow(struct svc_rqs
 	struct nfs4_op_map *allow = &cstate->clp->cl_spo_must_allow;
 	u32 opiter;
 
-	if (!cstate->minorversion)
+	if (rqstp->rq_procinfo != &nfsd_version4.vs_proc[NFSPROC4_COMPOUND] ||
+	    cstate->minorversion == 0)
 		return false;
 
 	if (cstate->spo_must_allowed)


