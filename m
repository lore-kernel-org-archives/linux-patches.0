Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016129;
	b=EwEvP9ls9cBBWMgYSoeQZsoBYWKZEbmyGXxSUGeekFeG71zdstj/fpCf6xPLWNwTTGKx
	 HRW/EM6MtqmLH9P58B2MG2x5TIneOYMj0KKjecw76/a3ULreTIickDFwuLxoj6QRfuDzl
	 6eO2ZIuo1YcjnQuhRTIGHQJcG4tXF9aujwL65NmodooWTTVLYh4dEaZ3Zhe3Z3UEHEzRY
	 DZzviYnAH/C89uscw+peD8ex6SDk6rNx0w9c7wwaMM784IJz9zRjMDQeT3RIGboUWyi2Y
	 GJY3Eo2WGO6n5HB+3ILGPU3k5FBcVJOCuQ3+OQKBiMFb1u+2wLvPDv8xnCTUOHEjKUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vUo0v/hjjaCY8aWU5DYwjQUlURgrtAmv52q23RR4PM=;
	b=z9tj5C2q1VxBiCJcwddnho+RZlyK8hW+4DSRi5OvpVR86SeL0IonPp7fb4Sz08Tw9cnG
	 Hoo664ytKEuRdOiOA/tHhvF9KPoF7KJqBdwSAazK7ePgGex6FCXtMDbQMwaL/Efg9xPWr
	 RVB5EKPuvcAk6O8Thzytu3YkFeECohdEUQH4b7HrN8r50xFuLdd1TB+HLQ8+c4D+jmJfJ
	 ON8Bf6psxSxPbQQUV6XfZQ0Kpcpf/yKK/PkpqeN1zgw/E5Bgpk6wJfE065PnQzx2S2VF6
	 u7FEuSiE7HVca6Uc2fBTW6Zlnbeehus5Db8dz1ZQo5XUYZ3KNUg9vUU+YjW+NKgKu+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7IK9lHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28741606A32A;
	Wed, 18 Nov 2026 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7IK9lHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7726F1F000C4;
	Wed, 18 Nov 2026 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016129;
	bh=/vUo0v/hjjaCY8aWU5DYwjQUlURgrtAmv52q23RR4PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7IK9lHH2B+OLGoTOijzozOfmCC3Nyrz+kPlqbr3HimC/fwE14pbD7BZp+JWUSTNu
	 Gol4ToEz7Fm+g3vJBCbqMgHuwbqS5Zk1/c1K6SI6tEgbnpEo1HZF+H391ZTZW4bTR0
	 XIIcYMyQMbWb4XlL8bBtagKnsLXRADU98D2iTp7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0418/2651] accel/amdxdna: Fix potential deadlock in BO open and close callbacks
Date: Wed, 18 Nov 2026 15:27:38 +0100
Message-ID: <20261118150302.882034784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 1bc13a9d9366d68ebf7aa12137b362d539b4f0d0 ]

In amdxdna_gem_obj_open(), abo->lock is held when calling
amdxdna_gem_add_bo_usage(), which then acquires client->mm_lock.

However, the heap update path may acquire these locks in the reverse
order, creating a potential deadlock.

Fix this by saving the client pointer locally before acquiring abo->lock,
and releasing abo->lock before calling amdxdna_gem_add_bo_usage().

Apply the same change to amdxdna_gem_obj_close().

Fixes: 1f513a3ec3a9 ("accel/amdxdna: Add per-process BO memory usage query support")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260902180955.3999242-2-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 34 +++++++++++++++++++----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 08e22829f72da..1dd3c0014d5a5 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -641,10 +641,8 @@ amdxdna_gem_skip_bo_usage(struct amdxdna_gem_obj *abo)
 }
 
 static void
-amdxdna_gem_add_bo_usage(struct amdxdna_gem_obj *abo)
+amdxdna_gem_add_bo_usage(struct amdxdna_client *client, struct amdxdna_gem_obj *abo)
 {
-	struct amdxdna_client *client = abo->client;
-
 	if (amdxdna_gem_skip_bo_usage(abo))
 		return;
 
@@ -656,10 +654,8 @@ amdxdna_gem_add_bo_usage(struct amdxdna_gem_obj *abo)
 }
 
 static void
-amdxdna_gem_del_bo_usage(struct amdxdna_gem_obj *abo)
+amdxdna_gem_del_bo_usage(struct amdxdna_client *client, struct amdxdna_gem_obj *abo)
 {
-	struct amdxdna_client *client = abo->client;
-
 	if (amdxdna_gem_skip_bo_usage(abo))
 		return;
 
@@ -694,14 +690,20 @@ static int amdxdna_gem_obj_open(struct drm_gem_object *gobj, struct drm_file *fi
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(gobj->dev);
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
+	struct amdxdna_client *client;
 	int ret;
 
-	guard(mutex)(&abo->lock);
-	if (abo->open_ref > 0 && filp->driver_priv != abo->client)
+	mutex_lock(&abo->lock);
+	if (abo->open_ref > 0 && filp->driver_priv != abo->client) {
+		mutex_unlock(&abo->lock);
 		return -EPERM;
+	}
+
 	abo->open_ref++;
-	if (abo->open_ref > 1)
+	if (abo->open_ref > 1) {
+		mutex_unlock(&abo->lock);
 		return 0;
+	}
 
 	/* Attached to the client when first opened by it. */
 	abo->client = filp->driver_priv;
@@ -712,26 +714,34 @@ static int amdxdna_gem_obj_open(struct drm_gem_object *gobj, struct drm_file *fi
 		if (ret) {
 			abo->open_ref--;
 			abo->client = NULL;
+			mutex_unlock(&abo->lock);
 			return ret;
 		}
 	}
+	client = abo->client;
+	mutex_unlock(&abo->lock);
 
-	amdxdna_gem_add_bo_usage(abo);
+	amdxdna_gem_add_bo_usage(client, abo);
 	return 0;
 }
 
 static void amdxdna_gem_obj_close(struct drm_gem_object *gobj, struct drm_file *filp)
 {
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
+	struct amdxdna_client *client = NULL;
 
-	guard(mutex)(&abo->lock);
+	mutex_lock(&abo->lock);
 	abo->open_ref--;
 
 	if (abo->open_ref == 0) {
-		amdxdna_gem_del_bo_usage(abo);
 		/* Detach from the client when last closed by it. */
+		client = abo->client;
 		abo->client = NULL;
 	}
+	mutex_unlock(&abo->lock);
+
+	if (client)
+		amdxdna_gem_del_bo_usage(client, abo);
 }
 
 static int amdxdna_gem_obj_vmap(struct drm_gem_object *obj, struct iosys_map *map)
-- 
2.53.0



