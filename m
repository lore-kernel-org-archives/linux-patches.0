Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB9E14AD12;
	Tue, 20 Feb 2024 21:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463344; cv=none; b=erHAkX2ubSUQp8mtXMNU38Jih/RNiSJAgFnNMYV1k7c9itJx8LWBZZKn8IZ0D3IwaYxl/Iv7GXC722MKMp/vC8xEhW2bLBh3kLQPPPR12SOxZMISlTCXVECpFCVyxEwrrzlPY+FAqXLC/CjfnYXVLAytFdgO4Di4n0sPrwvhbGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463344; c=relaxed/simple;
	bh=H7UVuALMMvza4udjflVKC888AZPb79K+ypjlKdLqsd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0sLnVpYzPbT0LjJRta8vvsEme1Yg3Jt/BQvDVmfFKSSfnp3+R1IbC4+wP//GsYObNA1s5p8kamnjWEk5RkPC72j8dZdVekdYIlRsRGiFFYOsEYFnrYHw1jU+62GKMAcK/5f+DLhXfNMZ3XXKQXwkkVPDoV9GWtiHaWT5O57G9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wQrP8fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wQrP8fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071A8C433F1;
	Tue, 20 Feb 2024 21:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463344;
	bh=H7UVuALMMvza4udjflVKC888AZPb79K+ypjlKdLqsd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wQrP8fv0U5kTw3Hb+9fpIW7PjZzLQzU4fhBjrdewcQxk+lph1neAiJUcwlpzWMAK
	 528l0cOt1Rn1o72xj0qRiQ81jfQ6MrNvfCJ95+IdDO9P3gJPDBW560bhL9yC6CHVGk
	 sqyhilQNEWwK2auo6n2nGalN88UBayOwk6qxP6hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/331] KVM: selftests: Avoid infinite loop in hyperv_features when invtsc is missing
Date: Tue, 20 Feb 2024 21:52:11 +0100
Message-ID: <20240220205638.065692134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 8ad4855273488c9bd5320b3fee80f66f0023f326 ]

When X86_FEATURE_INVTSC is missing, guest_test_msrs_access() was supposed
to skip testing dependent Hyper-V invariant TSC feature. Unfortunately,
'continue' does not lead to that as stage is not incremented. Moreover,
'vm' allocated with vm_create_with_one_vcpu() is not freed and the test
runs out of available file descriptors very quickly.

Fixes: bd827bd77537 ("KVM: selftests: Test Hyper-V invariant TSC control")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20240129085847.2674082-1-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 9f28aa276c4e..a726831b8024 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -454,7 +454,7 @@ static void guest_test_msrs_access(void)
 		case 44:
 			/* MSR is not available when CPUID feature bit is unset */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = false;
 			msr->fault_expected = true;
@@ -462,7 +462,7 @@ static void guest_test_msrs_access(void)
 		case 45:
 			/* MSR is vailable when CPUID feature bit is set */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_TSC_INVARIANT);
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = false;
@@ -471,7 +471,7 @@ static void guest_test_msrs_access(void)
 		case 46:
 			/* Writing bits other than 0 is forbidden */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = true;
 			msr->write_val = 0xdeadbeef;
@@ -480,7 +480,7 @@ static void guest_test_msrs_access(void)
 		case 47:
 			/* Setting bit 0 enables the feature */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = true;
 			msr->write_val = 1;
@@ -513,6 +513,7 @@ static void guest_test_msrs_access(void)
 			return;
 		}
 
+next_stage:
 		stage++;
 		kvm_vm_free(vm);
 	}
-- 
2.43.0



