Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D1938DE1;
	Mon, 23 Jun 2025 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713461; cv=none; b=YqhXuzjsA+TcWSfe3bffYG/E/vVvHbstNXk9SqUwTg5rvyVfSa5nZQrOEp+9ARMpvor5f3sidasm1cN68LQ/Qo06ViPGXhDNqU4+j/6JFcVcGjMCMyO+46gOl83hDv8+shfbps/QD7pirt1zx3vNMDsDMAhYZXy19l5fAoRbzBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713461; c=relaxed/simple;
	bh=5QnARNm0LE5W72WlCh0WNncYh9ZLlES1eoRyhGgVuFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIKcgXVzLdmPw0ABKwoXYl86pRJA/bE8tfFu/RYhKrdNWDSDie9iKzZHWcLy+xc1ydnfxgHKKJD4WMq6m9VWhTUZAUZhbnYMUfV9RpQcWq2X+AGCYQvmky29b5cPcBx11tdhdAU0NO2nGHAGkb1ylSMPOoGkDes+Vlb9UUI4WDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AoDsNK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AoDsNK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8500AC4CEEA;
	Mon, 23 Jun 2025 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713460;
	bh=5QnARNm0LE5W72WlCh0WNncYh9ZLlES1eoRyhGgVuFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AoDsNK6k6xpSNerQgVJQrMf5Av3VlNyfdkReX38jI1MtbjmLWl9fiXqOF4CMmQa5
	 0YUtudM57j3i7SxuIGicRa9UVXamg41bgB2Bm1LqCbrBy6iv1Eh9KVoYKBzrsuOwCh
	 8+fTCayJ8rlOV8uzNZuvSPUDwDU4hFrT/AnPaL0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 167/355] nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request
Date: Mon, 23 Jun 2025 15:06:08 +0200
Message-ID: <20250623130631.724461134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


