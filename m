Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC12264A3;
	Fri,  4 Sep 2026 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500663; cv=none; b=ACdbx9CHW/aV6TC7Rw5872A2SHKu8CaOlkc9DZwerT30MbpZezgeSsyD+UBamDm0b4M9NC9ilafu7PB/6v5UODLXW/c8NDUmtwcG1OWrgpGG7XdlW/cpthcS0/oshCTKOu4zaagDcXAXW3at23o1d/4wwWjXx52k7dXDs912JgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500663; c=relaxed/simple;
	bh=HqkyaIH5O8JkmPZ0GZIv7XpxN0IP1zEkmHmcfuDAvow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gdh4FR/N3hxDGz5c7mTCl8Ukvkn3oyrOF2EZAcb7oLizn6wAu7J4aFMglVCw/7JvEYKJOBxQ2XGLscZSI3QkwtyDlJoWchyQITijDgj3PF15lRRw+4JES9NBi3lRLaINEoO6hppCFsy0VbiCTyhuDMqcbuXqQA57Jd7tUGErX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRDpbIyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRDpbIyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B551F00A3D;
	Fri,  4 Sep 2026 05:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500660;
	bh=69wVAy5IlzU4pOzmY6tWRepxp+9Emq8fW/8pB2JTiU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRDpbIythAkrwb0HCcu2OwVDCd5EubmlGEjVeGh2+q7wadmQuEcmzo7u67UqKobY8
	 GXp1kk9pKommXccZ7h3dwkfJcTjtNpUo5KG1Obc6RCUXAyC1QcrgtKacjhl55ZkqIR
	 su1AJCZ34Rg1Xdhn0x5R9ooJrslvfNeboyRDpkUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 118/552] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Fri,  4 Sep 2026 06:54:35 +0200
Message-ID: <20260904045750.679857969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7921,6 +7921,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	destroy_delegation(dp);
 	smp_mb__after_atomic();


