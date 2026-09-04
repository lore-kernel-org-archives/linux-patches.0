Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56E4137B2;
	Fri,  4 Sep 2026 05:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500096; cv=none; b=boaKC/CWlPdeJS1ncSH9BTZ0MHOYo4rfPQd/sOlzClCL6zRHsZfvew1YZTkBQdY0CoG4sYVFoAMIgOwnhSNLlMXJ+ImaC5XdDs7d9Q68G45sFO0uM1soRt//G9uZwmCbsi/7TupiBd4M/RZONC8NYMF6vM/AbKjLJYZD1NzRBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500096; c=relaxed/simple;
	bh=Q7bSDdalGCEiSo7EyivCP2PGYuw0ujKDClM9C0AVZl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG+AWS6k+ytfMmp8w4P97ARcsXPEPTheMoyX4bIEgM3BBIOrwKhjthGWjkCohdLHQXLDbKhZ2pepuPcLfYpuLHGnJeG6bxUQ/ewyFhKxNlA9lEtec3btESpGSc0jp6M4YTtoBYL5bK/bwZJ/idA1UD0J2tZb5Zj2A342V20XqoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=El0Hnoln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El0Hnoln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE39E1F00A3D;
	Fri,  4 Sep 2026 05:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500095;
	bh=aBmMi0jbuVTj/nkTca6diyMqZLFqY5+uWd6bbDfuQL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=El0HnolnLQ4oiMlebIkzciCuvpfhMohzptAQ4Plm61tj9cO4tuuPvCU7luq6KsyYO
	 cd1OLyvvv8+Lj0v2ZSNyc955uWv2o67znZY/2OARVT9JGQfp5hsvRlajHy4HTO16HY
	 McHFtDoEdX1lrKhSdq83doiRNZNFnoCg85HNPsJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 650/713] rust: num: reject Bounded::shr overshifts at build time
Date: Fri,  4 Sep 2026 07:00:18 +0200
Message-ID: <20260904045818.403227432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit 223aa25aee82e188ddf043a8703b16e5fdfc37d8 ]

Make `shr` reject shifts of at least the type's bit width at build
time, instead of panicking or masking the shift amount at runtime.

[ This implies we can break the type invariant, which in turn means
  we can trigger UB via `Deref`, e.g.:

      rust_kernel: panicked at rust/kernel/num/bounded.rs:528:22:
      unsafe precondition(s) violated: hint::unreachable_unchecked must never be reached

    - Miguel ]

Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c59a2d14cd24 ("rust: num: add `shr` and `shl` methods to `Bounded`")
Link: https://patch.msgid.link/20260810-pramin-split-v2-2-65a00b3c7309@nvidia.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/num/bounded.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/num/bounded.rs b/rust/kernel/num/bounded.rs
index 304ef04d86cd9..6d766c22e61b5 100644
--- a/rust/kernel/num/bounded.rs
+++ b/rust/kernel/num/bounded.rs
@@ -495,6 +495,7 @@ pub fn cast<U>(self) -> Bounded<U, N>
     /// assert_eq!(v_shifted.get(), 0xff);
     /// ```
     pub fn shr<const SHIFT: u32, const RES: u32>(self) -> Bounded<T, RES> {
+        const_assert!(SHIFT < T::BITS);
         const { assert!(RES + SHIFT >= N) }
 
         // SAFETY: We shift the value right by `SHIFT`, reducing the number of bits needed to
-- 
2.53.0



