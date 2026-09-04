Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FE1424654;
	Fri,  4 Sep 2026 06:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502911; cv=none; b=r+e50hhM48YLcyJU8geAcEUfEXS5FOgRmwU4FGXDDxrNOsOGAOzLAdPKyjI29n0BovE/1fT58oOudlrJBxTyfR5JsKrQt2oxAAyL/SeAzV66X1M5nbDaAAdb96KSdaDWJKqA++N5/jNwXqzSsFztOk7VH2OEPdL/ic5WrrnINAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502911; c=relaxed/simple;
	bh=B8Zw56xx3YeawfaoizBUygCP214MYWk5Q/w8GuHPiEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1pvk7v5eZZWsecUcGrZS7nv6h90sopJ96IimH5asnQEbjfiGW135+IX4ZJfcScLDuHGa1nK1Bd63wpsiqSPH2tEKPYfGDC5eBBIxRxz+H0qvdh578Tl1XDE94FpetlCrFmWzqXQDdm1DiIgcyNgrMI7H5tWt8WZqzIerjUpgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3O5uDYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3O5uDYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D541F00A3D;
	Fri,  4 Sep 2026 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502910;
	bh=Jq4HU4erQu6TybB4lbkbxdDHv9cmG8LQvpV8O/zisLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3O5uDYFekQTxvEtGxRtxF3mIgpJFxPme9lUdNyDseL43ueOlsxhS0KN57zpdQ6aI
	 pD7SBm07g9sGCmr6Ar77tZwnv3DxUbonam30nYbKLxQYJIVHW45XwcPBSPortlicZg
	 c1X5c9B5aQuJogMomnK6VhF/zq5skPaMiZ6HkZzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/403] KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test
Date: Fri,  4 Sep 2026 07:02:57 +0200
Message-ID: <20260904045743.300333912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

[ Upstream commit 25a642b6abc98bbbabbf2baef9fc498bbea6aee6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 0a6dfba3905b6..6b0928e69051d 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -36,8 +36,6 @@ static struct kvm_vm *sev_vm_create(bool es)
 
 	sev_vm_launch(vm, es ? SEV_POLICY_ES : 0);
 
-	if (es)
-		vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 	return vm;
 }
 
-- 
2.53.0



