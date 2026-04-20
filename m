Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C828342CBD;
	Mon, 20 Apr 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701059; cv=none; b=WTSp1VrAYXdTHI5/kcWJgQuWV0vUI3d3kJX35RuWtgIm2mYlf5u0Vamo+5+T97smo3h4DfBCE7vowfE+DCruJYUMSJnxKkou8XqJzMyank3BYsyg6nsmsBu72Ksbz8tTvLHc44Blyv8/6IwKV7WxAjw3lkPSFnws4kPlX2kihsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701059; c=relaxed/simple;
	bh=GD8kmLMk4Ts5C/1pz1/7gEe4lrUroV5mTn7YbCE3jsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU/cVozPVsQLCrBYDmdCuvG4H7OOGtxinYO+xCQXT/1GZliXiznpNCTmR3UR6Z4vXuJyOSBSJ4AZu3RQ1b7XTMlnXf+DiIdjoVk0Xq9rmSDOnRzw04ijohk+cyQNXdiAoNDjT3isOTsR8i1j433B1dN+xoWHzS4/ZTcQuDZEdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMEYkZdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMEYkZdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05617C2BCB6;
	Mon, 20 Apr 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701059;
	bh=GD8kmLMk4Ts5C/1pz1/7gEe4lrUroV5mTn7YbCE3jsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMEYkZduWgUqbCbz/6ewc78Um5dGRvPSNVWOXMazTp609JrxTfxQQyp1S/ky8p1LF
	 mcyjUjMNl16W5oFGFh1Ix7Yv7LZJkn7TdZqhHUwxyrfrCrAYFuSJhGBvPWxw/7MVNr
	 Qh+VoWaIJ3JTR1y4/cZatO1kNPaQB4oXiDfbsCKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 165/198] KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test
Date: Mon, 20 Apr 2026 17:42:24 +0200
Message-ID: <20260420153941.553250239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
 


