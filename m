Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44729ACDD;
	Thu, 15 Jan 2026 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496483; cv=none; b=MOVfIgIaSmi+HcatRoOhULEeR5/LaTmD2oGaaAVhLVU7s8z1nuAUV1NHlM5zu55sk/kdIFSBm6ZnR04w9P6jftmBaLtuCvA+PQZ+petpoEPwr8wAWLESIQdc0I/VTxrA33ugCXBrSL74B1VcLkoN7zri+CP+wCc3tG19NeToSK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496483; c=relaxed/simple;
	bh=sV8X1fOOl6IOzUChg+BDGHVkXfzVQv/4pdKF/WYT+Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLeAVg7uCmgf6Dpo9Mt/Qq0/f/bIEORHFJUmld2Dh+ytWUVgH1IcxroWUrBvWMLdtZd+wjaLwWjFJRJ3HcQZ8n4f6NjEk5fl/8LX0F/JkzJTGJwHKpemFXUqndCXHfqxpzKl8obyBKGgc8xPzi+culov7RSetBEZPiD0fhRsb48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kb2deSng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kb2deSng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44B3C116D0;
	Thu, 15 Jan 2026 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496483;
	bh=sV8X1fOOl6IOzUChg+BDGHVkXfzVQv/4pdKF/WYT+Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb2deSngxTP3g6ZIDnAWy5qvyR1eGhlFlv3Y2ZScSdA8/7Qh5+9cfkCa3g1FIygTv
	 6yDPY/vVIwXxo5wGLeadYxxPMjI4B0Ecp8aFxmjVIQpvZWIvD1CwuGIgFOF6Q9WGg0
	 4R4j2AivYZYTci2x8QV8kFVJC73YYx0ko8CICgNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 003/119] nfsd: use correct loop termination in nfsd4_revoke_states()
Date: Thu, 15 Jan 2026 17:46:58 +0100
Message-ID: <20260115164152.080393358@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
@@ -1764,7 +1764,7 @@ void nfsd4_revoke_states(struct net *net
 	sc_types = SC_TYPE_OPEN | SC_TYPE_LOCK | SC_TYPE_DELEG | SC_TYPE_LAYOUT;
 
 	spin_lock(&nn->client_lock);
-	for (idhashval = 0; idhashval < CLIENT_HASH_MASK; idhashval++) {
+	for (idhashval = 0; idhashval < CLIENT_HASH_SIZE; idhashval++) {
 		struct list_head *head = &nn->conf_id_hashtbl[idhashval];
 		struct nfs4_client *clp;
 	retry:


