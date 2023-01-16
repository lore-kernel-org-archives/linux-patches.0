Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B5433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5124C433EF;
	Mon, 16 Jan 2023 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884987;
	bh=A8e5zLPLqxa7YcOIHon/d4PfntYS2PPjo1gGHQprKYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0XvuAvcweGh85G0JdHpmSXb2PdCLC4e0D7Nvr1ESVRyj6hCQX6z3oLNrHFxLl99S
	 XY20+L3/1kV/Y9C2qRrBFFQnxLFYv/u79b9t+/NT1vkFw2w5TSK8j78Lu0d6Zlj1EA
	 AGStHYzQqNDXzWgwRgPcrGaDYHckdnwBB6cie3hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Nikitin <denik@chromium.org>,
	Marc Zyngier <maz@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.15 06/86] KVM: arm64: nvhe: Fix build with profile optimization
Date: Mon, 16 Jan 2023 16:50:40 +0100
Message-Id: <20230116154747.331758988@linuxfoundation.org>
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

From: Denis Nikitin <denik@chromium.org>

commit bde971a83bbff78561458ded236605a365411b87 upstream.

Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Filter out profile use flags to fix the build with profile optimization.

Signed-off-by: Denis Nikitin <denik@chromium.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221014184532.3153551-1-denik@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -83,6 +83,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may


