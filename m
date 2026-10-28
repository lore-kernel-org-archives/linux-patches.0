Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216427;
	b=lEaqh+8qoYtKgwX6VBSS5GYr72+7+2ChBmYjPKP+ULcov8AulY67adFDEqLVcmYYTgM/
	 +tJH4fQmsHprK+2mZo3GB6TQhRRhsImGkhfck7bIDRwcUmfJIJ5sGjTRBtIZx6V63l5WV
	 3aujtdDcP+9vqH3BCa2rA7sn5iPPvsCbuuQsADTH0Bh/W35pfRm4FsnFIByZddPqr0nMB
	 k/F4//xEl0FUwVW3IFkiWdcSWdowZi2JH+lb8vXNYeBzn67vOFow+9SikFXFnSKWY2GF3
	 MmdSkrjy6jCQyCeSqZQaiDaUVqxzIiv8MXaiWyqEO9N7OYm6dnBQoToqOxj6mF547Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mp8jJGdGfOf24SWXbqLelzmyZ7jwrceuUYItyhNDZUI=;
	b=c4KJKMVfomw2I1C6z9+1cwnWTpZBSdcnlIqeMq+XM8hCkdd2ZXsx3ujOopdknIcBkRbs
	 zJpTm7CHleEm7THHXyMU3OGT3hZpUaYHnln6zrNaikmrklVWHn074dqwxwcEsv/v53Ig0
	 JzrS61rrj1A7WgXOXelqDjb8Dy1LWyzGGEkViy4Rlow0c1kVvCpbJgTz4gEeuNhrqfsyc
	 CFXb+TjREMtFL8DT1U7C4l5AdCrdTfDurt2r+YjnxS/nJxsWghzGur6vQCmiLVVC8ev9B
	 o7POFWVTeKmJb/vLNstuhUZT/CUVdmjpXkwXUAMq4sJcs64YgzzPpg5xmvVs0Ik6coA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqcWB5gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116EF606A323;
	Wed, 28 Oct 2026 19:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqcWB5gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E061F01825;
	Wed, 28 Oct 2026 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216426;
	bh=mp8jJGdGfOf24SWXbqLelzmyZ7jwrceuUYItyhNDZUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqcWB5grbZ/Tz/scqD1cnFbSbZEgmrVvwsbuS4bwzOxLyMYQfyhbdbfgk7EC+Exal
	 H4NKLKmr6Pw7hnU+L40No/nNMjdGu784Sd5RoI788Dh1zIY7MRKhF9xargbAnFi4dG
	 f7aef0FgsYUaLTG4eQhLENOv7J2VdUh7S6YgTOPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1509/1887] NFSD: Prevent client use-after-free during close_lru reaping
Date: Wed, 28 Oct 2026 18:00:05 +0100
Message-ID: <20261028170533.803649819@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 2330b788d732f43668b965b3105b37ceb276dfea ]

An nfs4_openowner left on nn->close_lru after its final CLOSE keeps
its last closed stateid in oo_last_closed_stid, holding only a raw
pointer to its nfs4_client. The laundromat reaps timed-out entries,
drops nn->client_lock, and calls nfs4_put_stid(), which dereferences
the client through cl_lock. Nothing pins the client across that
window, so a concurrent force_expire_client() can free it and
nfs4_put_stid() reads freed memory. __destroy_client() hits the same
race, walking clp->cl_openowners without cl_lock.

Pin the client with cl_rpc_users before dropping client_lock, and
skip clients already expiring. __destroy_client() then cleans up its
own close_lru entries through release_last_closed_stateid(), so
teardown no longer races the laundromat.

Fixes: 217526e7ecc9 ("nfsd: protect the close_lru list and oo_last_closed_stid with client_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-8-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d6f1b9f572bf9..ec37aca0949af 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6336,11 +6336,18 @@ nfs4_laundromat(struct nfsd_net *nn)
 		if (!state_expired(&lt, oo->oo_time))
 			break;
 		list_del_init(&oo->oo_close_lru);
+		clp = oo->oo_owner.so_client;
+		if (is_client_expired(clp))
+			continue;
 		stp = oo->oo_last_closed_stid;
 		oo->oo_last_closed_stid = NULL;
+		atomic_inc(&clp->cl_rpc_users);
 		spin_unlock(&nn->client_lock);
 		nfs4_put_stid(&stp->st_stid);
 		spin_lock(&nn->client_lock);
+		if (atomic_dec_and_test(&clp->cl_rpc_users) &&
+		    is_client_expired(clp))
+			wake_up_all(&expiry_wq);
 	}
 	spin_unlock(&nn->client_lock);
 
-- 
2.53.0



