Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47574471261;
	Tue, 21 Jul 2026 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658427; cv=none; b=uO1QHDD3FAeznT/697BKjBEUfm3+0MwZvhpwx5H7OitF8hjqblWRmt4FRnyDdG2L+8EfBggohPcuDRQvFW749LrN3E10+J+Nodgd7wOfO54L9BeYzMLXgRYyJHXDqIOOF6X7P7aqluhsihJFmDesF5jlUGbhB7ECyWmdSsSo9cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658427; c=relaxed/simple;
	bh=pVlOm7Kc8QWnv8XpT5NcX8ENbobmwvpfesAcCElQa9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkP7/YTVNKrQGT5RcjRqQn0inRfcWVS9wNAsPkvDFEK8cA8d5EOlHmt+1psNVyrD6ZiKZLWVUOoQbjijw2ADYKGUmwW/8GmnAAaG0iEJDUGhFFASO5JMcGxB01SyULZweG/9dCBhTGTuysghK5GvEJ5z/aT/Z5RqZ0AsrvM77Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPdZ892e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPdZ892e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB5F1F000E9;
	Tue, 21 Jul 2026 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658425;
	bh=RcxuI9UVqVXi83xB0gcivNMbj2zhPh0lIWqurmNO3GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPdZ892eL6JoZgFvrG74E7uby3k+dxdnqPN0PBAHBvqbh1ehyf473UDEcIj7HD28G
	 kTKZ9u2LyC8CHdP7Ll734A6+0VjTVL57VviQxvrp7Yf0FWHt7NC9sOfn/7YSw0Eq3n
	 rY28pA45a6SvZbK825KFlCWdwT3ThP52D+Gp93EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1139/1611] KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
Date: Tue, 21 Jul 2026 17:20:55 +0200
Message-ID: <20260721152541.042826422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2729,6 +2729,7 @@ static void kvm_inject_el2_exception(str
 		break;
 	case except_type_serror:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
+		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
 		break;
 	default:
 		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);


