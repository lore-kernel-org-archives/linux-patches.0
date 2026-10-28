Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210461;
	b=OICSin69UkZC5X9PzA3w1y2ze7DsV6rOon06Q32Hpo5G0NY0aFqZamLlTaVqM31QXiCM
	 7a1mgi9pC1jhQ0ykE/+yXfvIyTJnLPh9FF5J7vd8FcYX/o5Y4VErGMQRdmnTj9z7P8Qpe
	 el3+w/n7VnqtqNkM+7muIJCnGlHR8HkznmPSV7feuAqXHXinrZGk8rPJ0p/lxxMnxmlF7
	 89SOad27A8vvMEghJtJuFLs5e2L2Ut/WX5hudTkTCGGQfQOz7CVVq+KJVYdzEl62pJZOz
	 Augm1eGXvB6fY9ArMoQ+Nuj1NhpsmUeIdpsn/4ZegJDiI9DNPpek6OWSzJ/UVnhvUDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PIVzTwE5CgRhkkPyz+8rd+/xdmdGz43ZscgzIhN5WR0=;
	b=F/HYi6NYTQBmPFOBEBx8Adyba88RhaFgsUTrbISkeH7BJtJI9TFXKNdyGVV1wq17TQeX
	 wAe8A+REP2zGWejssJaizHT1DVKdSE9pNJUdJP7om7XR8qSi/XK9uenzXJ6qXq5G9AbYj
	 7aTH1erM9CgSikPn69TdrIhpUb/zvyx/EDaEQhEeTf1UtWXejqibpQ5qDKfafhRHcwXzy
	 QqjZlA5DHmGkUFgxoH2YhMqhpJhNuBJhf3G4tiP+s1aglKKLEqPhO4Cx8AkBIyFL1VTyu
	 18wZZTf58qpkBbhVif0O+2a1/mqbSGaFbMUKApKNeR5p6LBmhDJU+IIfQLNfzDCmYlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZArPdqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A0E606A326;
	Wed, 28 Oct 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZArPdqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E34A1F031E1;
	Wed, 28 Oct 2026 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210460;
	bh=PIVzTwE5CgRhkkPyz+8rd+/xdmdGz43ZscgzIhN5WR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZArPdqNvaRVuunSdvyvXmoB2Z+FdiLZVA5Y9laMHyugbpyh2dTjMvPwJTtRSvYnY
	 eQaAq2H1O0A0CxyrnYZ3On1v+o59WB3sgOY8wPROUw+hWyU3zmkkpZtNgQT9vOsg/T
	 cLm9+pUfrLvWJgOWUxr6zZ00nWq58xB995J1xcFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/571] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Wed, 28 Oct 2026 17:52:32 +0100
Message-ID: <20261028170008.145777357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 88a76145451d703eedd867b5989bf73d17340399 ]

When nfsd4_setup_inter_ssc() fails, nfsd4_copy() returns
nfserr_offload_denied directly, bypassing the out: label where
release_copy_files() would drop the nf_dst reference taken by
nfs4_preprocess_stateid_op(). Each failed inter-server COPY
leaks one nfsd_file, pinning file/inode/dentry/vfsmount.

Fix by setting status and jumping to out: instead of returning
directly.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-3-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ adjusted cleanup paths to omit unavailable trace_nfsd_copy_*() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8db5b820ac558..ecf10e6fdab36 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1778,12 +1778,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out;
 		}
 		status = nfsd4_setup_inter_ssc(rqstp, cstate, copy);
-		if (status)
-			return nfserr_offload_denied;
+		if (status) {
+			status = nfserr_offload_denied;
+			goto out;
+		}
 	} else {
 		status = nfsd4_setup_intra_ssc(rqstp, cstate, copy);
 		if (status)
-			return status;
+			goto out;
 	}
 
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
-- 
2.53.0



