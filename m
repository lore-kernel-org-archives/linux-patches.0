Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981433E377;
	Mon, 20 Apr 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699921; cv=none; b=kel3pHlqeRLP4dOifhgBhhsow2geReCzyxbXuQW5EQsB3p8RqW87x54xTvjs2XI8kbHpM1ShjDNQY1XCjVdo61ovmYbqHlxprKS9oEpboJc8Me5759BRiz3yKLAICh1U8GtsRaIkCMG5vXD9SIyWAX2j249EBwLwuSoP6kFH+k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699921; c=relaxed/simple;
	bh=0G4r1MF7zTNm7U9Dc4eq/3NKxZ++4FPgFiEJUpmULF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrV7W4D2zKPNLeAWA8d3FL+jetlzWwWF5kTlu26CIu1qiQCgXXHuuoDRJdbfqq12SvR1XyQx63ypLYfPsN15Ckp7kjqW7e4UZ3OwbFd2mSoArPhzswNoSnshGnZ66IMuMRmyeNBichOkQhM5WzfeutEhVWPhZDHjQeWbGnb2hbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLezl7Bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLezl7Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620A8C19425;
	Mon, 20 Apr 2026 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699921;
	bh=0G4r1MF7zTNm7U9Dc4eq/3NKxZ++4FPgFiEJUpmULF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLezl7BjWykIlhxJuL4oNSnL1ApHQm4UEuPAjcbwEWcjggJLc9djZoSlrBXcypf3o
	 Wp9qVhyrxVGjaBdv/PQarxn2KitmJNdqO+erjieGC8Y3gFtf9BNTS9FjOMBGSK70CM
	 6pqf8afwBYQ3b+yovJh9urWsPP9T+UFinLNBLvBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 50/76] KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test
Date: Mon, 20 Apr 2026 17:42:01 +0200
Message-ID: <20260420153912.645787558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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
 


