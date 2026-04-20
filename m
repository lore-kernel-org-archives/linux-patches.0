Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09A82E11C7;
	Mon, 20 Apr 2026 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700473; cv=none; b=o3EFMPOxi91hvUW7aOc3q66vzNi3Yd3EXVvjbu0l0dKlFPAk2cBpWREZ4MSb5yllXma26ox7vS3URjv3hwt3zGspE3kCv4GoVqAZMWBllhzRZ7wkrC/Q8uKnCpEXSmX1shEVZS8gmeQyTNE2F1K934zEcWzV51KKqn1lyPsaU/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700473; c=relaxed/simple;
	bh=gnikGA4+gfHsCFw7wjE4ZJ9GGhgR1Lj1bpE0Tk0L19Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ei5mpZkFbR92Ntgp5lUNZPqng19vW7tGWqSJ3Ibvmx3c+97eR1j2X5uDNeFA8zs2QKB4nDeiqJ6yXM03l6nW1hSg5YeK8ERpt1v5h4eh0ranRpidIHFWba3lGTuMinCV5mGW9D/ggqHymLzibP2gSOOCE6RpJm++DhMGPG+3egk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogmh4s3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogmh4s3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683B7C19425;
	Mon, 20 Apr 2026 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700473;
	bh=gnikGA4+gfHsCFw7wjE4ZJ9GGhgR1Lj1bpE0Tk0L19Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogmh4s3VGqgpOx8gzLUX+fjN46A/KdMff1EJYY1XLyBNBXYNAvdU49Glj55Z+O9iN
	 kUCO1ppnVyhP2SgT8jPVFXDFAw4+a/mGczfGxd/DylFzCFuHr8914OPla1zj4vFEmC
	 3vKHg2sE1yVUjnxEf9tF7uTZsDaWiiocwvSxMTRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.19 187/220] KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test
Date: Mon, 20 Apr 2026 17:42:08 +0200
Message-ID: <20260420153940.759252706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 25a642b6abc98bbbabbf2baef9fc498bbea6aee6 upstream.

Drop the explicit KVM_SEV_LAUNCH_UPDATE_VMSA call when creating an SEV-ES
VM in the SEV migration test, as sev_vm_create() automatically updates the
VMSA pages for SEV-ES guests.  The only reason the duplicate call doesn't
cause visible problems is because the test doesn't actually try to run the
vCPUs.  That will change when KVM adds a check to prevent userspace from
re-launching a VMSA (which corrupts the VMSA page due to KVM writing
encrypted private memory).

Fixes: 69f8e15ab61f ("KVM: selftests: Use the SEV library APIs in the intra-host migration test")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260310234829.2608037-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/x86/sev_migrate_tests.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -36,8 +36,6 @@ static struct kvm_vm *sev_vm_create(bool
 
 	sev_vm_launch(vm, es ? SEV_POLICY_ES : 0);
 
-	if (es)
-		vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 	return vm;
 }
 


