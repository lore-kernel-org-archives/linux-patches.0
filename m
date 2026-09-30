Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEEE4EF13C;
	Wed, 30 Sep 2026 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789494; cv=none; b=hUHJVMA6mGejiMaTgosoUtTEnQaIrKX6Z7Alg2UFubiyb3tX+jR8y1AU/MxvHw7DxYO55zovtAOJFn1U/KLOpQiWKT/I7PjcKdEtcfPqrnZ0B3P/Jgx3oZVdQ9iYYeRx2qgDU6M4Vs0BqZaN9p/wLMyfCXV2f3RKQP3baU0FWEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789494; c=relaxed/simple;
	bh=B+o9GOe8rguLdJmtt7C/ZlGWWRU8m7y0JuKvA8LbDbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqFc7NyH+NEwX7Z6BV4VMkGqT/8vyZt8y0sYZiTwSZmwWimAYiVROpKaKYlt1chQ/M8TQq9dRQWrxmHh5KUlzWzc3OgVMjRv38O+AJ7M5NXyZvETEN9Tv3QKti2Soe2Y1Y89yJes46/+ZdLA3gp5Sp2AT2UlHkpr8G4tYBZ8NMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t+Gq441; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t+Gq441"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF79F1F000FF;
	Wed, 30 Sep 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789493;
	bh=KI5jhwK1v5vhczi9e0F8AKv8i/2Rd2QzPCyQqw4Xozw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0t+Gq4418uMmD3cPeIaJFpPPJmy6Q0T4Rp2yIOozQ49uv5EFYi3iCbKKulLfQeiTQ
	 QzhWKZsyaJE+7lgi3U9hbYYypp7pxGWyZsz3DyCQQcwatQ7NP1otR8GaO72j/IZ9wj
	 g/c/8c+nS/z4iVEuIHN/w5FPR2Hf5IZbmMpUHiag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/877] perf/x86/intel: Make @data a mandatory param for intel_guest_get_msrs()
Date: Wed, 30 Sep 2026 17:22:43 +0200
Message-ID: <20260930152424.434770832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a391618e1d563f099e4c2a704f45d08329ccdf7c ]

Drop "support" for passing a NULL @data/@kvm_pmu param when getting guest
MSRs.  KVM, the only in-tree user, unconditionally passes a non-NULL
pointer, and carrying code that suggests @data may be NULL is confusing,
e.g. incorrectly implies that there are scenarios where KVM doesn't pass
a PMU context.

Fixes: 8183a538cd95 ("KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260921191418.950933-5-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 313456a90bcbe..8298b5462d49e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4327,11 +4327,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	}
 
 	/*
-	 * If the guest won't use PEBS or the CPU doesn't support PEBS in the
-	 * guest, then there's nothing more to do as disabling PMCs via
-	 * PERF_GLOBAL_CTRL is sufficient on CPUs with guest/host isolation.
+	 * If the CPU doesn't support PEBS in the guest, then there's nothing
+	 * more to do as disabling PMCs via PERF_GLOBAL_CTRL is sufficient on
+	 * CPUs with guest/host isolation.
 	 */
-	if (!kvm_pmu || !x86_pmu.pebs_ept)
+	if (!x86_pmu.pebs_ept)
 		return arr;
 
 	/*
-- 
2.53.0



