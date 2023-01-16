Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B0133EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BC8C433D2;
	Mon, 16 Jan 2023 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885097;
	bh=3JE+lGIHJMbFp2GpN6XNUHq9++Qe4jwBlyjDM3/MC5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHi0TQOaa8cUWW+ocStjt+8e+GZQ1N+4T3dTc/Y5gSOvrLhx8yCrlBjRKJbsONf43
	 Hrga6hM+EfJMXrq+/rjdyzlOcGshQsHc3nMPkLAi2sftOsv7LVGSqVGF43Rfj9Sx3d
	 hW2DDG1WlOdSp0brrMeZCjwws2yVjsx48rFvYz7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/86] Documentation: KVM: add API issues section
Date: Mon, 16 Jan 2023 16:51:48 +0100
Message-Id: <20230116154750.138263482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit cde363ab7ca7aea7a853851cd6a6745a9e1aaf5e ]

Add a section to document all the different ways in which the KVM API sucks.

I am sure there are way more, give people a place to vent so that userspace
authors are aware.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220322110712.222449-4-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..8826f8023f06 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7265,3 +7265,49 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+9. Known KVM API problems
+=========================
+
+In some cases, KVM's API has some inconsistencies or common pitfalls
+that userspace need to be aware of.  This section details some of
+these issues.
+
+Most of them are architecture specific, so the section is split by
+architecture.
+
+9.1. x86
+--------
+
+``KVM_GET_SUPPORTED_CPUID`` issues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+In general, ``KVM_GET_SUPPORTED_CPUID`` is designed so that it is possible
+to take its result and pass it directly to ``KVM_SET_CPUID2``.  This section
+documents some cases in which that requires some care.
+
+Local APIC features
+~~~~~~~~~~~~~~~~~~~
+
+CPU[EAX=1]:ECX[21] (X2APIC) is reported by ``KVM_GET_SUPPORTED_CPUID``,
+but it can only be enabled if ``KVM_CREATE_IRQCHIP`` or
+``KVM_ENABLE_CAP(KVM_CAP_IRQCHIP_SPLIT)`` are used to enable in-kernel emulation of
+the local APIC.
+
+The same is true for the ``KVM_FEATURE_PV_UNHALT`` paravirtualized feature.
+
+CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``.
+It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
+has enabled in-kernel emulation of the local APIC.
+
+Obsolete ioctls and capabilities
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+KVM_CAP_DISABLE_QUIRKS does not let userspace know which quirks are actually
+available.  Use ``KVM_CHECK_EXTENSION(KVM_CAP_DISABLE_QUIRKS2)`` instead if
+available.
+
+Ordering of KVM_GET_*/KVM_SET_* ioctls
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+TBD
-- 
2.35.1



