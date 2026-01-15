Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E99C25228D;
	Thu, 15 Jan 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495966; cv=none; b=RqOxU/Ww1eEClv4rivIKIbIoCLOgLUHiMzb7zKpNrTD6a2xGjK3a+oY/9sYTsmfvs/Q/YllSESI0nHfIq8g4UV7nWtANN3wSGpNMPR8P13tnRW/R89OlmuPSMC4lnK1GrDygUuYWrQwYJ44DTEnPAfCg2Qf82/u1OVaMSye5ydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495966; c=relaxed/simple;
	bh=Lw2aT1QELepDDS1cEQdnxvxm/I8QbwYiZuxMde9zTHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iteWIUSSwdBjWZi3QBPzj0a7JokcY+358a31sF4WX1hdCy07fTN5ebA2MzVSe4GIeX8h9mIOL1BneyA1EhHSr+pGsW3s2HwlCdwRqZA/lLV/K25nWyNj5tbP6sGZeFeAZW/3a0VFcknG9+ZF3dqudGKW0bMpUCwr08ftCqo+Vm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2FIgH4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2FIgH4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB873C116D0;
	Thu, 15 Jan 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495966;
	bh=Lw2aT1QELepDDS1cEQdnxvxm/I8QbwYiZuxMde9zTHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2FIgH4A5H9G9AmB8N5am+MhRorNrR7Fi6F8sQkKJwwr2bS0prKYaclKF78Iqwpbi
	 PkDLvLFArVQvbBcJCpdx5r4a85RCz4hfJGzYjNmQLdBqsdjx19xTPSbcZqkVS9qt+i
	 qoAarQRvtZGm6wkLh3mrNFPzWJXh/i+O13DP7M6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 003/181] nfsd: use correct loop termination in nfsd4_revoke_states()
Date: Thu, 15 Jan 2026 17:45:40 +0100
Message-ID: <20260115164202.437545857@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: NeilBrown <neil@brown.name>

commit fb321998de7639f1954430674475e469fb529d9c upstream.

The loop in nfsd4_revoke_states() stops one too early because
the end value given is CLIENT_HASH_MASK where it should be
CLIENT_HASH_SIZE.

This means that an admin request to drop all locks for a filesystem will
miss locks held by clients which hash to the maximum possible hash value.

Fixes: 1ac3629bf012 ("nfsd: prepare for supporting admin-revocation of state")
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1780,7 +1780,7 @@ void nfsd4_revoke_states(struct net *net
 	sc_types = SC_TYPE_OPEN | SC_TYPE_LOCK | SC_TYPE_DELEG | SC_TYPE_LAYOUT;
 
 	spin_lock(&nn->client_lock);
-	for (idhashval = 0; idhashval < CLIENT_HASH_MASK; idhashval++) {
+	for (idhashval = 0; idhashval < CLIENT_HASH_SIZE; idhashval++) {
 		struct list_head *head = &nn->conf_id_hashtbl[idhashval];
 		struct nfs4_client *clp;
 	retry:


