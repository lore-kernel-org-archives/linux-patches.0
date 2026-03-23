Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5F3B19CC;
	Mon, 23 Mar 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276937; cv=none; b=Bt6egixxky4PmpHgM2oFWG+XYPX5qa4zHOru2FnYnHEjttG04oUIhdPxPOm4Xm+RL2+H6Yh43jaX1q6CR6izH8hHxhW3UA8+G9+pkj+YxGqN5/n1Kwx6AdBYLEj+AkmJ1/6rcnk9MNsLIWEHeAgQLELbIqYfggW0eYVVwRusUEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276937; c=relaxed/simple;
	bh=vYV/C0ku2aqyNOms7T1eqt1RcJo5dh0I0hOq49+nOH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3MD519j1E40UBKV8Mo6hsjuAJGsgX0JrDO7RcLXD+igVhi0vZAzCK1qp4SI81XhQG5KBeou/tekMb6zhX69RWZrSJxJdE11/kckTBe6+nLVJwv7FUjPuq7lNYRVNvu7T9iok0NSoFJmlo+SZ3sfahVqvR+ida1/9hZvweT0r0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTkSLhLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTkSLhLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3616C4CEF7;
	Mon, 23 Mar 2026 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276937;
	bh=vYV/C0ku2aqyNOms7T1eqt1RcJo5dh0I0hOq49+nOH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTkSLhLJimX8rGwhUnuoSd3X8MZVVpKBffJVvBEdh6s8/62TkAfEtgHIJbGOnt5uX
	 /VtNY6mrkqHyGBSUVRuEs7dtiGLn8sOrYFkcyUFagLWB+UDjZMod+SfVePmLSblHdv
	 GDGxjR/wvVx8IXiR3rra5cpgUwbIdrrceTN+Szb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/460] KVM: x86: do not allow re-enabling quirks
Date: Mon, 23 Mar 2026 14:44:17 +0100
Message-ID: <20260323134532.899186797@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 9966b7822b3f49b3aea5d926ece4bc92f1f0a700 ]

Allowing arbitrary re-enabling of quirks puts a limit on what the
quirks themselves can do, since you cannot assume that the quirk
prevents a particular state.  More important, it also prevents
KVM from disabling a quirk at VM creation time, because userspace
can always go back and re-enable that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6538,7 +6538,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
-		kvm->arch.disabled_quirks = cap->args[0];
+		kvm->arch.disabled_quirks |= cap->args[0];
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {


