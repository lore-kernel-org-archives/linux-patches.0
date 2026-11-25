Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621976;
	b=V6ECDhb8gec/ilLcLD3eC1nRRCkI+BeI0qwca455E692Oo74b2AJWyL0fEjl9+mKzhzl
	 P+wAaTlLMi1OZCx7qU0fWuzus56bjcuMMXGp01wyB68eAVj9vLnYS9UaUUhxvH6d/uk8i
	 vfATk7eqTIN2Hl53HqAOB2wR/EBAqQyminT2CKtTkF0bGPJ+VCFlNMvNAsaDmjlT7S/Wv
	 7nHMeRbZFHC/adGLZqLp9IVW61UR9jz0tpVjCHLIeH+F6Gd4l/FD2Z2N7E1Qe7ahwrvYx
	 AED6czlY8ShRo3v+sEoZDriAsmQv+5s7s0UBI7p8Q6ovquG0IEMzSuFm8Iz939/oF1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPtVaq2DWv+bcMnyEscIUPQMzTR31McOmP3ksUa6PSQ=;
	b=HzPWpqHLCTF1WfIX7tzV8iOG7W7pqO/FCmldqqO/z9JpNd+E2puT4nR/nlHCJWRoVWJj
	 jkqo2bRoANCHJiIEy2ejWBSSjgKsd0Ldjk8vzIrYv8zs1va6Jv/uPSh54Jg9y4lb0XfzZ
	 7GsrobGQMIHW1yeez37C32MIfr0JbqKdnI5owlVd/WAvSjwmhcYz13MoOnvjj9L0hdDEw
	 ecvhmv08ZE8SunTYq6cvd9sNl/ccPTfen/7lktdaElgmL0buyfgbit+YKj4WKjBruSrol
	 EuT+vmXDTIv66pbiW2Hh6SJOIWTjGtkpUu8+//7j5ASljUiU61t12G+0dLVyfEJMR5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfTWVR8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA44606A31E;
	Wed, 25 Nov 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfTWVR8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E289E1F000CF;
	Wed, 25 Nov 2026 15:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621976;
	bh=bPtVaq2DWv+bcMnyEscIUPQMzTR31McOmP3ksUa6PSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfTWVR8wF6JD0BCbD/kvOcIdF0lqmnuM60EnO+DHeDOleR8sB5EOSAnuq1NmHZ4t0
	 L/N0+K4HoRXy+uubMs5UhZS+4YnLD0cvBYOCWqQhYiVGXANjts8gAXr9POI13KjsBo
	 VU4V0Oe0rhjhG3uf2a2KYoFnR+CNgi6JXjbri+Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/990] NFS/localio: hold the client across an asynchronous LOCALIO probe
Date: Wed, 25 Nov 2026 15:29:17 +0100
Message-ID: <20261125143831.232012674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 000a87910213562ff09f5bc38cd366ce34fccf71 ]

nfs_local_probe_async() queues the client's own cl_local_probe_work
without a reference on the client, and nfs_free_client() does not cancel
it.  The work takes a reference only once it runs.  If the last
nfs_put_client() comes first, for example at umount after an NFSv3 I/O
queued a throttled probe, the client is freed with its work queued, and
the work then runs on freed memory.

Take the reference when the work is queued, and drop it when the work
has run.  If the work is already queued, it already holds a reference,
and the one just taken is dropped.

Fixes: 76d4cb6345da ("nfs: probe for LOCALIO when v4 client reconnects to server")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 3138439d19109..f4bd5922e6ba6 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -204,15 +204,22 @@ void nfs_local_probe_async_work(struct work_struct *work)
 	struct nfs_client *clp =
 		container_of(work, struct nfs_client, cl_local_probe_work);
 
-	if (!refcount_inc_not_zero(&clp->cl_count))
-		return;
 	nfs_local_probe(clp);
+	/* The reference nfs_local_probe_async() took for this work */
 	nfs_put_client(clp);
 }
 
+/*
+ * The work is part of the client, so it holds a reference on the client
+ * from when it is queued until it has run: the last nfs_put_client()
+ * cannot free the client under a queued probe.
+ */
 void nfs_local_probe_async(struct nfs_client *clp)
 {
-	queue_work(nfsiod_workqueue, &clp->cl_local_probe_work);
+	if (!refcount_inc_not_zero(&clp->cl_count))
+		return;
+	if (!queue_work(nfsiod_workqueue, &clp->cl_local_probe_work))
+		nfs_put_client(clp);	/* already queued, with its reference */
 }
 EXPORT_SYMBOL_GPL(nfs_local_probe_async);
 
-- 
2.53.0



