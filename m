Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F39715216F;
	Tue, 18 Jun 2024 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715147; cv=none; b=TenpSU0cYwgSf90BEAhGoIo7Mkn+1ht/J4LjXNOTLGSurfBkyqTebFVkkHFLjgvDqwIU4IYKfcoj98TY2ZH24xvdrUhDDEPtmzw7tFRZEBAIMMAP5GYxZtYKuX/6M1vHAgxbTyeMNjIihD3jxl0lTkY0yU0uyV+DA1GPf4ZvREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715147; c=relaxed/simple;
	bh=P4igxkh4ojS9qC6RU4Xns2JpDkXOhJkuGWWpTAtqDk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUmZa8Hzw8CRPDs1C1u+y9t1PxZx152RgCb7Qekgfv6d7eHPqf2UtmpL/no2YvRc6wunMa6lysssXt5AxC/ohpoG70rzCk+GKUdtox6mKyt9ZY0Hlo+R8uJUgCejByZ3IcMqTQd0scwL29P2fnz8e2UdatUHM/j3QrEnN5CjduQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUoKI99v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUoKI99v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C3C3277B;
	Tue, 18 Jun 2024 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715147;
	bh=P4igxkh4ojS9qC6RU4Xns2JpDkXOhJkuGWWpTAtqDk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUoKI99v9zKT3cXP9WWzPU2vX/muLo1Z1gMfuuLDADzVfOnFE+bVaztzS2/0irv0A
	 1pd6FoeLlphzU0IgxIqx8ROpCF6T1hw4Kc2t7GBiZIRyZZZ0RM+Y1lLfWOMCN6kfnd
	 ZPMgut1oxbzcE3r/x0tblkLds8YuzQVFFGDkaH6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/770] nfsd: simplify process_lock
Date: Tue, 18 Jun 2024 14:30:32 +0200
Message-ID: <20240618123414.178655535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit a9d53a75cf574d6aa41f3cb4968fffe4f64e0fad ]

Similarly, this STALE_CLIENTID check is already handled by:

nfs4_preprocess_confirmed_seqid_op()->
        nfs4_preprocess_seqid_op()->
                nfsd4_lookup_stateid()->
                        set_client()->
                                STALE_CLIENTID()

(This may cause it to return a different error in some cases where
there are multiple things wrong; pynfs test SEQ10 regressed on this
commit because of that, but I think that's the test's fault, and I've
fixed it separately.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3f26047376368..15ed72b0ef55b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6720,10 +6720,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 				&cstate->session->se_client->cl_clientid,
 				sizeof(clientid_t));
 
-		status = nfserr_stale_clientid;
-		if (STALE_CLIENTID(&lock->lk_new_clientid, nn))
-			goto out;
-
 		/* validate and update open stateid and open seqid */
 		status = nfs4_preprocess_confirmed_seqid_op(cstate,
 				        lock->lk_new_open_seqid,
-- 
2.43.0



