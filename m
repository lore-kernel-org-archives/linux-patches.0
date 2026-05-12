Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC8036F900;
	Tue, 12 May 2026 18:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609659; cv=none; b=nvefVgAnnamvcdZhxOkyAKAQgGwcQGyP+mFJaN6nDohhy+7DwOCMk/m0lEPxYMV1ZKb0LyAQTc3l1HjCCSCjT2qBfmIf7GvKloaXiRU8Wwf/oW4SeLeLUv1Yj52rsLJVyesIHC8EQObdpKP7DAMYPHrT4qfkpBbzat0a4+5oKxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609659; c=relaxed/simple;
	bh=fTvcUXzVRUbbO5Xu5X2a/BYfvOgKtfdthbQaj4nsjwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1cW6QU6Sy9ccV2XBhUsxTyyLwqmv2Yy7CldYayN0Wcs6SV3MCdhZz/darDOYbGTLbkDtaNIUX7y72LYZS6uQXn4s4pv10PZFBQeuhO9zdBjeIATmd44p5wD+LVpb78WxhjkpXp3H9vvCvQMKXixrIeFjjQXSJEZYUwLiDThrfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2IBCq/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2IBCq/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9903CC2BCFA;
	Tue, 12 May 2026 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609658;
	bh=fTvcUXzVRUbbO5Xu5X2a/BYfvOgKtfdthbQaj4nsjwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2IBCq/tcyE45tXHgy9Ig+DahXYCGSD7NNUyVq99x4YVr4wdi+QCkQG9AoYwh6DuW
	 3CCOM6mr4CVL/Axm+qMLax7niylTEwPTXnN6pQKdMoh10PF0XSwkuqGEqhLPebsQzD
	 HAwOrlF83Om4byd+PzRcHI7o+S7GAUacyrl9oJ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 280/307] KVM: arm64: Fix initialisation order in __pkvm_init_finalise()
Date: Tue, 12 May 2026 19:41:15 +0200
Message-ID: <20260512173946.037377996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Perret <qperret@google.com>

commit 5bb0aed57ba944f8c201e4e82ec066e0187e0f85 upstream.

fix_host_ownership() walks the hypervisor's stage-1 page-table to
adjust the host's stage-2 accordingly. Any such adjustment that
requires cache maintenance operations depends on the per-CPU hyp
fixmap being present. However, fix_host_ownership() is currently
called before fix_hyp_pgtable_refcnt() and hyp_create_fixmap(), so
the fixmap does not yet exist when it runs.

This is benign today because the host stage-2 starts empty and no
CMOs are needed, but it becomes a latent crash as soon as
fix_host_ownership() is extended to operate on a non-empty
page-table.

Reorder the calls so that fix_hyp_pgtable_refcnt() and
hyp_create_fixmap() complete before fix_host_ownership() is invoked.

Fixes: 0d16d12eb26e ("KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260424084908.370776-7-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -312,15 +312,15 @@ void __noreturn __pkvm_init_finalise(voi
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-	ret = fix_host_ownership();
+	ret = fix_hyp_pgtable_refcnt();
 	if (ret)
 		goto out;
 
-	ret = fix_hyp_pgtable_refcnt();
+	ret = hyp_create_fixmap();
 	if (ret)
 		goto out;
 
-	ret = hyp_create_fixmap();
+	ret = fix_host_ownership();
 	if (ret)
 		goto out;
 


