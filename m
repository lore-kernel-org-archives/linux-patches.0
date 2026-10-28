Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216073;
	b=2G5/owQtMV8iLfwLrL73CZmAMH3ErLehWdaknSLD6vVBMY7pKx/8xOve1Vt9FVXPEyrc
	 b7XH1y0NDW4tkBMd+P7Q9nq6CEuRSTVkRK211bChljc5wUZO1SSn6jcBwtpyGRlh+EoKr
	 LvM0Ot3VBm2HmQGId4Xwc7Ui4oIjwFaBU+hTislc6h/aMHveyW2D9X3lo4IP+DxWsSnwZ
	 3jH7ruihTh5v66toi9aHoENm2LzLREAFX1iTHUCXfR1xh9i74a0cuu9TVtKriqRDZtVDe
	 QQNEjMu3o72t7pFHjHFMxfWiRsgEcz0jjuCd5MogqPi9mwbP2o04fcGT+4ej56ALIRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3cG3WRTso1AgbUwQ7H7jMQ9SaN5I5VC13ZuOO/eAak0=;
	b=lK8e/m6SgHE10lc1/uhgR7807Fs/8Kj9kcyPj1Wi1MNsAC577fwMsSmEMW9z5ElnFrxd
	 meRSgCsRdK+TyUt+N40rrDhlH74M7i7878nxzooAc3PUSb61oav07o22eot9MXExryxbm
	 oEH3MnUkI1OF5Tx70wHXXywG8KOcP8kk+SrTAXKLhl9/mG/wVSK4rHsCCnljhYj5/EhRf
	 f+w90T0WpfdrgSQx6XleE9sMmK9OE/JIJmErKlpI0LyydC/qqc6pFK7mbiHufPo3aPbzy
	 XPns+f2AWbcs3Vo71ByKwi8HZXNd2NCC/1BCULJMDt4PzkD1p5GsQJr01azauTDrJ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdANkH32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24C3606A31D;
	Wed, 28 Oct 2026 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdANkH32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A651F01825;
	Wed, 28 Oct 2026 19:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216072;
	bh=3cG3WRTso1AgbUwQ7H7jMQ9SaN5I5VC13ZuOO/eAak0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdANkH320e8TtMuWa7njqFCPGAl66GCX0Gt82aOSuyonk0fz8Y9Bd4lKFTWCBEv+N
	 1fU2Xiwr31AEmIvhUo5JpfgS4mVtxelLO3ggLKRDX+jgVCs4nULHbKwb9Kt6DplGFJ
	 /Fjc7ThQU19yT1EJLYSXViKi8XQtlu1Fw6YBNMe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1431/1887] nfsd: fix stale s2s_cp_stateids IDR entry for async COPY
Date: Wed, 28 Oct 2026 17:58:47 +0100
Message-ID: <20261028170532.024222390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d0beaee498e11880e72826026db0e9c9890fc114 ]

For an async COPY, nfsd4_copy() called nfs4_init_copy_state() before
dup_copy_fields(), so the s2s_cp_stateids IDR was pointed at
&u->copy->cp_stateid -- memory in the per-rqstp COMPOUND buffer that is
reused by the next request. dup_copy_fields() copies only the value into
async_copy, so the IDR slot dangled at the transient buffer for the whole
background copy. Any IDR walker then dereferences reused request memory:
the laundromat reads cs_type from it and, if the bytes look like an
expired NFS4_COPYNOTIFY_STID, follows into
refcount_dec()/idr_remove()/kfree() on garbage; manage_cpntf_state() has
the same exposure via idr_find().

Duplicate the fields first, then register the stateid on the stable
async_copy. result->cb_stateid is unchanged.

Fixes: e0639dc5805a ("NFSD introduce async copy feature")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-3-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 97d48dea5ac3a..00681c82bebd0 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1820,11 +1820,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;
-		if (!nfs4_init_copy_state(nn, copy))
+		dup_copy_fields(copy, async_copy);
+
+		if (!nfs4_init_copy_state(nn, async_copy))
 			goto out_err;
-		memcpy(&result->cb_stateid, &copy->cp_stateid.cs_stid,
+		memcpy(&result->cb_stateid, &async_copy->cp_stateid.cs_stid,
+			sizeof(result->cb_stateid));
+		memcpy(&async_copy->cp_res.cb_stateid, &result->cb_stateid,
 			sizeof(result->cb_stateid));
-		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
 				async_copy, "%s", "copy thread");
 		if (IS_ERR(async_copy->copy_task))
-- 
2.53.0



