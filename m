Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814543EF644;
	Tue, 21 Jul 2026 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654204; cv=none; b=ZtSX2YesMrfL4gePI4hr+2nGqlSRd0L+9+nCf2ztt5Uv7LGgjJykOrgMzwm+KE+iq4aaOzsw3MRDHr0Be3pTJL32O4W/rOb+B+3GQa8OJJ5/Kh2kPeTU21JSK2h2fow7EMapdHDVF0crCLWJdu97SoNrjNcBcipXdIvU0kppcsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654204; c=relaxed/simple;
	bh=wM/H1+ryuTtIbfC8FBt9R0dT6lsdFkMq+fDD+1VLpZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu4r/nsc8vrWJtffOZr7zun9c5tzp6Qw0blYTGBhh1qbFVjezdW9J2BjawfWNDH+rznqJ6HddeVLr0FFB1H396/tLTrfCjtJ8pJisAW3SgEj0DU2V7sdn71FXyWM0UIgD6pJF+amj05dlvDODE21PwDR3XlN3TDTJxBg8ZAd0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpZn/f8N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpZn/f8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90FD1F000E9;
	Tue, 21 Jul 2026 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654203;
	bh=KFQSK0XKxTP6u0k+1EfriLCem6D7RnhPASiyUZl36MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpZn/f8NK80Jcte8xq1eHadac1Sn1cD+Hfm7JEw5KQRdSo0PlTC+znKLXvV4V9Zf0
	 kA1BelnpbNWl1g6iTalvgiCU2ma1g5RYsT8f5q8CZfLFFKOVR/zoBUrMbKIJ7cjtsz
	 GrvpSe8JRBLAfkvN97xokihLSinxBJEjLPPg4lLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1573/2077] KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152629.881179315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

commit e2cb1f4578625e71f461d5c1ce70984193389cbb upstream.

kvm_inject_el2_exception() writes ESR_EL2 for synchronous exceptions
but not for SError. enter_exception64() does not write ESR_ELx for any
exception type, so the constructed syndrome is dropped. A guest L2
hypervisor taking a nested SError observes stale ESR_EL2.

This affects both kvm_inject_nested_serror() and the EASE path in
kvm_inject_nested_sea().

Write ESR_EL2 for except_type_serror, matching except_type_sync.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260615131116.390977-1-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/emulate-nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2818,6 +2818,7 @@ static void kvm_inject_el2_exception(str
 		break;
 	case except_type_serror:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
+		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
 		break;
 	default:
 		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);


