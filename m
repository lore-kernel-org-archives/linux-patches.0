Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E011358378;
	Fri,  4 Sep 2026 06:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502092; cv=none; b=LHp0A/Bs1epYIjmPT2VmAwcy8TYWrlXZiuqG5D7XQeZNnVApHJy8hBNPOYVZMBXxsUBUuWNHwHvdzG6ca3qqSeS1NWPlSo0twDTL+nqcwfsYYtl8SA+bAF67j3gg0K1phbZ/7EEx3t60uIt584BRy/K1oE7VTDbSCikXb39OsPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502092; c=relaxed/simple;
	bh=fBu/Sgr3Fbd+62GFLVjqXxbHw2Wz2+14dS72j/Ldbd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2D2FEx852f6tZJ3cew8YBxxBpcZJJoj5DMVpih5VArzb7YHd48R17frm56pAh4XfvUMuTDJH7ojO+mwPO5lAx/IA7vIv9ql90DVeZX+9UUtmXmQqYvRPujGIJZrQr8Ro1IDVkZDA/3k9gZCxSLjjjW+HFMXn+CfgbntyFjukx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6FidtYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6FidtYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8700B1F00A3D;
	Fri,  4 Sep 2026 06:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502091;
	bh=1qLQnDB4mzts7cKrzhsZMsUjCT/lEq9uQb3ICpapo8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6FidtYun1x1CkOCc/Kkcih3NWn96JFx3alZshuhHkulsBvND7K5k+zmNQUQ9+UUI
	 7ZFma4e6yGqjeiKsORo7V8S9/YJdaQFDYr/trVQ9wWrNKgQK2rG06hkd/7A3Qq4XSK
	 eiadwGuy/YN9Re8nqpXcem1tUOX0CNrQjyikE9Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 084/403] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Fri,  4 Sep 2026 06:58:07 +0200
Message-ID: <20260904045736.743406277@linuxfoundation.org>
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

commit 04cce9d79f2b1a114f7128e08bf60a473e10f1ec upstream.

nfsd4_delegreturn() is the only stateful NFSv4 operation that does
not call nfs4_check_fh() to verify the delegation's file matches
cstate->current_fh. A client can DELEGRETURN with a mismatched
filehandle, destroying the correct delegation but waking the wrong
inode's waiters.

Add the missing nfs4_check_fh() call after the generation check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-6-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7643,6 +7643,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	destroy_delegation(dp);
 	smp_mb__after_atomic();


