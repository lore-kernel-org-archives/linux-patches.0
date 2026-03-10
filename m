Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CBC3803CD;
	Tue, 10 Mar 2026 11:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141968; cv=none; b=cNQTTYdWQ3UDiGllMdE7IAAVz3ndYOQoCJ7OlQWp4YE8dK9kwjFI99S31CaMqP7Ly8zORHv0FE2HjcUPSzGGVXZrj8wLvSs9BVQgu/G5umwAsn4SBJjv0eXc6wo/+Ht0QXGtPZssrYs8OVGjrsA5agE1W4BL6z5swX//3Rt60jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141968; c=relaxed/simple;
	bh=zwtFhZSOzF4Pd8RJ8fcX2SXxKDLmzq0A7Thh6bMYxBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omAJDE4uhHvuP4jvpLz2yaGJMoZyMo0c49Nb3d88te8IAkLvTP4PZRrH5Ksw95NOufr9hP1ccjswUOqjiFG0CxTSKIwBrgizdLwgGiZaxLSODX2sibWMVC3SleGnsT17Mt+IMktKkF8a9AkNAGaY2WrVUK5MEmGs+HGDow2fGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqxo6UMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqxo6UMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7736BC2BCB0;
	Tue, 10 Mar 2026 11:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141968;
	bh=zwtFhZSOzF4Pd8RJ8fcX2SXxKDLmzq0A7Thh6bMYxBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqxo6UMjZJmMOVfJbCLqn8cAmKdUSWzSQUdr1k14PeQSQP6WrFkQr6sJo8wiuU4wX
	 m5nUJATzQL3bX8bacAAP0L9kjfhtb5FCsApYsthkPGq9Dm6fmgDoHONosHwPr7Dp6U
	 AF0OuzssVUmR9VuuH8vo2pYtaUh+IhOiGaxweiawFInsBmwxS1EGqsRj5YeJj5NIKX
	 WfYIlHUsWOCe4n01EHo1Qf0Tg3E/FpaVgAETLMu2eZYNkymOP0ejiq+DNE5qF0TeSB
	 oyMz44pDu9eW6ZRAq9Vi6T8wtSWjCiaTpBQx1MDfDSXZtlqCLtjDXpdoqVu96FMFE1
	 f9ByuegWUqGYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Alessandro Ratti <alessandro@0x65c.net>,
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/314] KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
Date: Tue, 10 Mar 2026 07:15:51 -0400
Message-ID: <90e5986f5e84d659a83679cff08d3a8ea4420890.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ead63640d4e72e6f6d464f4e31f7fecb79af8869 ]

Ignore -EBUSY when checking nested events after exiting a blocking state
while L2 is active, as exiting to userspace will generate a spurious
userspace exit, usually with KVM_EXIT_UNKNOWN, and likely lead to the VM's
demise.  Continuing with the wakeup isn't perfect either, as *something*
has gone sideways if a vCPU is awakened in L2 with an injected event (or
worse, a nested run pending), but continuing on gives the VM a decent
chance of surviving without any major side effects.

As explained in the Fixes commits, it _should_ be impossible for a vCPU to
be put into a blocking state with an already-injected event (exception,
IRQ, or NMI).  Unfortunately, userspace can stuff MP_STATE and/or injected
events, and thus put the vCPU into what should be an impossible state.

Don't bother trying to preserve the WARN, e.g. with an anti-syzkaller
Kconfig, as WARNs can (hopefully) be added in paths where _KVM_ would be
violating x86 architecture, e.g. by WARNing if KVM attempts to inject an
exception or interrupt while the vCPU isn't running.

Cc: Alessandro Ratti <alessandro@0x65c.net>
Cc: stable@vger.kernel.org
Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
Link: https://syzkaller.appspot.com/text?tag=ReproC&x=10d4261a580000
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671bc7a7.050a0220.455e8.022a.GAE@google.com
Link: https://patch.msgid.link/20260109030657.994759-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aeb7f902b3c7f..2ab445c0126b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11598,8 +11598,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		int r = kvm_check_nested_events(vcpu);
 
-		WARN_ON_ONCE(r == -EBUSY);
-		if (r < 0)
+		if (r < 0 && r != -EBUSY)
 			return 0;
 	}
 
-- 
2.51.0

