Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4291753FD2B;
	Wed,  9 Sep 2026 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962028; cv=none; b=SwibrP5DFqewOIfkxj1xrfTWGdfoQtqryFMEEKLt3k3UM2J6te+pZGuR0KAp6I6rSrg9NKyZLm41RholK1YbWzheX1Y2JoIUAMfQxR5EJX83L/gs/5z1OtXiwUM8eP3GTLVjGQ9fCodSTfCY83LIsi9m1aNL79nJupCK7scEO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962028; c=relaxed/simple;
	bh=N14ki/8JHH9qxbKaYxIvWm1FaOdYC7wVZ84UzVtO8Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buycbM2m1jWyNGn2q93KuO4dO6OeD6rk3wHaDFgBI72JwgbbEf0Kov/MG2GHSSF8MHprn8rkp9QeSOQrS+Ehh4iCdaZn7CCnNPbCVE2D2xF5b06jE3uULiAVOTy5UMDhoB+WUc5hZaE6QulM3x4lqJtX3X0AvhvCrx1RwV/THu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Si8fNJS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Si8fNJS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A14E1F00A3A;
	Wed,  9 Sep 2026 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962027;
	bh=y5SBQGw9MoEQMCOqhWXm/PK1uuCGoaKCEwPZasEB3tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Si8fNJS6xEtXYdk9t8ibD+g0sv3pOzs4kzsjxDzo5bJZ/xYVLYO4vO99tIFnc4NxG
	 jXHD4T9f1k1Dg/ECh9bKo2K4UrQhjHMLgXC23Hk4sKlJjx18jvqGvxvKB8dPZhjkhO
	 2SteoJ4qX0g+SWN4hXv1p8MIzU2KVwF4IJFqbFag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khushit Shah <khushit.shah@nutanix.com>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 148/556] arm64: errata: pass REVIDR when matching target implementation CPUs
Date: Wed,  9 Sep 2026 15:37:08 +0200
Message-ID: <20260909134235.646643222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Khushit Shah <khushit.shah@nutanix.com>

commit 5541432e09dc2031978188f3e8a00b9fc78cf097 upstream.

When target implementation CPUs are provided, is_affected_midr_range()
accidentally passed the MIDR as both arguments to __is_affected_midr_range(),
so the REVIDR mask check operated on the wrong register.

Pass REVIDR as intended.

Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -82,7 +82,7 @@ is_affected_midr_range(const struct arm6
 
 	for (i = 0; i < target_impl_cpu_num; i++) {
 		if (__is_affected_midr_range(entry, target_impl_cpus[i].midr,
-					     target_impl_cpus[i].midr))
+					     target_impl_cpus[i].revidr))
 			return true;
 	}
 	return false;


