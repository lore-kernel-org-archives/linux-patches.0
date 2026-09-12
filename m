Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE234E75D;
	Sat, 12 Sep 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232587; cv=none; b=aOZ+JrCip2ILGSlmp0a32oq+rlFKd+UQL6Q3+NphrAic8iouxbOjYFh8jvt9UDk1D4ySLIvXj6vzB9sb6A54aSbaOiJqbXxbnXp+BYqsIYAsdLKfwG1NIalsErzNzOxu5OnF5dzDjWduCiavDoYrT8rMYgVd9SLtAwFbXGeO9+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232587; c=relaxed/simple;
	bh=FKfb+vnl+Tb9aI/gVprTVes69+C1ZoqVQMgd1MMhYUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwRHDEY250df+DF6hv/uG440FHlFAVfEXlC++RewLy7/a2aZA2XYrvvoEo/AMmATwUYmnhuVoqPve9cfCIleupQNcbdHFV50FBE13vc2qmdBhmNhAZHoEJb2TvM/BBwc22mAtAVsKV1VgOYxdMRA1+fFFvx7rhgXh6Q3Nxorr+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+bOV/TZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+bOV/TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CCF1F000FF;
	Sat, 12 Sep 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232584;
	bh=41Z0u9LVklCzdS1e2HUHTr2wxLJ/iwIYJ2eZqKItAow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+bOV/TZpFvRofPLeuBuFotGo4qpubJbZbDbGc5Suo61zRT//5bRDucn95pODBu43
	 AZD8iHSb3kiV6j2qLKxCrovuUcsHfsDqezfDfHTjNJq40/go5jqOfYGi59/ca+EH3x
	 MDvZSBki5D/czFnSRFdHn9f+k17PpnJA+En4d6DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 041/935] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Sat, 12 Sep 2026 08:51:11 +0200
Message-ID: <20260912065527.780187210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7119,6 +7119,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);


