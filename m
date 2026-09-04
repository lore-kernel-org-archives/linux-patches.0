Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409E33FE09;
	Fri,  4 Sep 2026 05:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498718; cv=none; b=hBSmRXMY2pHsMCGzVaL0iT4qKWxD9ViRl0YArmOGLat2CTSSn1198ra1b75Nx07Nva2Q8vX2EMVRJV6In6v5xaozYEDKrLn6STz0LeDq+aP9RqL61X04XrHS+vsoGeE4nFkYu2Y4hyTaSPAO59Hdb0/MgqZ8ku4OXSg/cBqLWH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498718; c=relaxed/simple;
	bh=s8xJNYa4Ktsui36WhDdZypLz6XOwCx+4Tmg+jKRbLV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0SMTFYTjIc6ZsX4iq9E5KdKHc5f8Dm0EGKqSzyIJ+xVJBLHdZJ05ovm8VnPlJygNlWwYdnfkt7SMYppbloJNuYW4XgsRvn370tS5dNtSYv1yBDPu+2zszr9I/90g4ruc2ZosMo/EwfisAOsF9SKVBjRr+9bmTrIMvk9WIFrS28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fi6MA5ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fi6MA5ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C72A1F00A3D;
	Fri,  4 Sep 2026 05:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498717;
	bh=C37R04YdlRC6A6JYFcBruQEc+rP/6IKlA9AnC8pQnHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fi6MA5eyhcGLA6u107thRCxGTwr9eoQZUQkoTPJFbuD0L65K3AsjodM1fiCvUY/yr
	 A1/h+yfOSLEXF7Un/kdVfFu+fqEozF/ec3NZ0TLi0KTohlB4epk7hQKdlK8tvLYGrY
	 8o89QlaCAYtakW3d6GA93sp+r/zYBIb+l3OgvE58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 161/713] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Fri,  4 Sep 2026 06:52:09 +0200
Message-ID: <20260904045807.434471801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8043,6 +8043,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	destroy_delegation(dp);
 	smp_mb__after_atomic();


