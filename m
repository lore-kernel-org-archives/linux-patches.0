Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829067;
	b=AaASnB/A6yAEXggTRrfOBp5JLZxVMTJ0Ib0N9bA4T0vonU2IbosEN4ESPnyDsqxlipx5
	 vOrW6Q4cMH74Pkbmq2n6BN2oLftvNmvIE7Mp5io81sAgNaE1+uCkT6f1aoZIShaT6qIBe
	 EDqOclZbRRbiJXORheZ46JfwFcE9AuMElieqkOC0kTGoMFvDwASC12Ok9XI/iOaGOn8Ax
	 yzC2qZ5TPAbEHN5WAjzSLF6d1hNynsyQ4u7VZ5q/JnpojhZnB1pR98gIZM6ZVnSP21g0j
	 y77f/dJfkIVk28WlBvYClkmipsvWt/+04YsL2wvZYeLupI8Tde2Puoqlkx0zDdR9x4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=64Xlz3Z6aROe3FQUJXEba+JkA5utEyL5aA/rQSA8+Q4=;
	b=T5rmV9yZ6i5sLtgTyRVE3mdUeGJHrDGb2JKO3Yi88haVWY5COifaCknDfej2Q4HZQRUx
	 5AmKmwkdlQKfsFnoNnZ1WBCmm/T9/49uK0wWfUXIYWEa8yUYqI8N9xdGMcYPKtIKOgTg2
	 A/kp9/RXL5OjvtAQgs6Bg4tBcwXukcMZvVHkAas4i6kiTcB712/oKfdpGpt93STtBpP+e
	 Fd1dWiI7TbHNL58+WLRzLyd97GE21ckZ3zcYGJAj9Gpaesi4ilfWHPax7JwrJ209MqujG
	 9sc2ssKL7Ha6k4kQ9aBQIm8rWOxy3/iz/MpxX/oJTYCz/VEFHaZ+Ku8dYUMkBM3eT0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSUeaPsN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0786070770;
	Wed,  4 Nov 2026 21:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSUeaPsN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2C31F00A17;
	Wed,  4 Nov 2026 21:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829067;
	bh=64Xlz3Z6aROe3FQUJXEba+JkA5utEyL5aA/rQSA8+Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSUeaPsNhfuP82bfVNmxzxQFt67PC8rVfr/BbC8vq+pTKjPssFggGKDfyttYZQEVd
	 HG/FMiTtNFD7lkS1etj80/ZkorlsSdLoc2eU1bzowypkQWMiID1IiTIlQWRvOnuVA/
	 g9AcaS5F7kTbHBfLTSuaL+9Ro293+Y+WCUO+Kqp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 422/547] nfsd: hold cl_lock in client_has_openowners()
Date: Wed,  4 Nov 2026 16:10:06 -0500
Message-ID: <20261104211050.328940379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 5336899b5491eaa2ac22c2925d87daab2b140eb3 upstream.

client_has_openowners() walks clp->cl_openowners and reads so_stateids
without clp->cl_lock. nfs4_put_stateowner() unhashes that openowner under
cl_lock and then frees it, so a concurrent EXCHANGE_ID with mismatched
creds can use-after-free the nfs4_openowner.

BUG: KASAN: slab-use-after-free in client_has_state+0x10a/0x140
  fs/nfsd/nfs4state.c:3718 client_has_openowners()
  nfsd4_exchange_id
  nfsd4_proc_compound
  nfsd_dispatch
  svc_process

Take clp->cl_lock while client_has_openowners() walks the openowner
list.

Fixes: 4eaea1342507 ("nfsd: improve client_has_state to check for unused openowners")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260828041925.36758-1-blbllhy@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4242,12 +4242,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
 static bool client_has_openowners(struct nfs4_client *clp)
 {
 	struct nfs4_openowner *oo;
+	bool found = false;
 
+	spin_lock(&clp->cl_lock);
 	list_for_each_entry(oo, &clp->cl_openowners, oo_perclient) {
-		if (!list_empty(&oo->oo_owner.so_stateids))
-			return true;
+		if (!list_empty(&oo->oo_owner.so_stateids)) {
+			found = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&clp->cl_lock);
+
+	return found;
 }
 
 static bool client_has_state(struct nfs4_client *clp)


