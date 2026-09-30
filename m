Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326EA515997;
	Wed, 30 Sep 2026 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786968; cv=none; b=BZX6kN7bsECeyuI8A/+EN8LFRlLhmfudbsNiLztzFqTd86Y7rD7hUPpShe8/coGGZ6V3tutKDTKPVoHfZB3pJbAUyX8Ic4NMuTWaGNWvdNz4kBF0LsWn/YJm+iUwx8PTRooedWL6mKlNbdUvH0l/4MipTWQRelunes2+rJGnY4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786968; c=relaxed/simple;
	bh=acEKMVvxhBCHyxW4f5ceyXC+pwcy16MvZwz1iI3dsH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad9EUth5ma5gDTCQFtAKeJOQuIZRPqz3SIN7LwdzvA6++DPfLf37uMnqw4HOh3oFX5mmWV0VQvMCWvS1kd+uQiH4VXw/zTkZGJu5Tn7lRBpXuSZ9pmyK10+EQmg1Sn6iOxnUpVCwvKH7mjKPVLx/vHwo0sCkH8g6OSXN1iG6hgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhfHqa99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhfHqa99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5871F00898;
	Wed, 30 Sep 2026 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786967;
	bh=HV7GtgOHAkLXVMx1sOtpxTLxx+NAEveH103FNhJ5k5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhfHqa99bapkRXi/+mGdlckcBXq7MO8adygrVI6msI4fPX2S0S3fxhe7pqVvPAn4N
	 K8xLsWaVQHkG+lU5QXskjRsFzNUrYjKzLr2bxVUWV2UgZq3ZMNWsauC042IhENfOBP
	 52Exjly8paSzsHdRGK9eQ+BoEk1XyiHde0CujWhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 010/457] KVM: s390: Properly handle NULL pointer in dat_cond_set_storage_key()
Date: Wed, 30 Sep 2026 17:21:55 +0200
Message-ID: <20260930152346.255099328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 88e22ffd1e46b95e40a6afabe486deb1d31a3ae1 ]

Some callers pass NULL as oldkey. Calling page_cond_set_storage_key()
will cause that NULL pointer to get dereferenced.

Fix by checking for NULL and assigning the pointer to a dummy local
variable to avoid crashes.

Fixes: 8e03e8316eb2 ("KVM: s390: KVM page table management functions: storage keys")
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260812104436.109741-2-imbrenda@linux.ibm.com>
Stable-dep-of: 27554b9505dd ("KVM: s390: Fix potential races in dat skey functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/dat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 3f2d6e8902d76..165c704fcf299 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -722,9 +722,12 @@ int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gf
 	if (rc)
 		return rc;
 
-	if (!ptep)
+	if (!ptep) {
+		if (!oldkey)
+			oldkey = &prev;
 		return page_cond_set_storage_key(large_crste_to_phys(*crstep, gfn), skey, oldkey,
 						 nq, mr, mc);
+	}
 
 	old = pgste_get_lock(ptep);
 	pgste = old;
-- 
2.53.0



