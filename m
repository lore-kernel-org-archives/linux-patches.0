Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DDC34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4437AC433EF;
	Wed,  7 Jun 2023 20:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170760;
	bh=US4ranrBZyjrZe4QjZJdpJOSEUmZgg1M+chw8EStXtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfIFPKwQmKlazm9xA9GXWz9zJLo7X75GGy9jDv8Rb0jkgaxYN80Q3EekjELfjJlKI
	 +eiNicxLmgrJ3opQfvx7vqViNmDjCq5Mx7lIGcFpZEc4KZ7QJgsDZWQhjK62Y8zIs4
	 a2bT8qe+zV09SA3RkfyAkYcvKF8IDxA30usATYck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 207/225] KVM: x86: Account fastpath-only VM-Exits in vCPU stats
Date: Wed,  7 Jun 2023 22:16:40 +0200
Message-ID: <20230607200921.135048263@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 8b703a49c9df5e74870381ad7ba9c85d8a74ed2c upstream.

Increment vcpu->stat.exits when handling a fastpath VM-Exit without
going through any part of the "slow" path.  Not bumping the exits stat
can result in wildly misleading exit counts, e.g. if the primary reason
the guest is exiting is to program the TSC deadline timer.

Fixes: 404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum values")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230602011920.787844-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10829,6 +10829,9 @@ static int vcpu_enter_guest(struct kvm_v
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
 			break;
 		}
+
+		/* Note, VM-Exits that go down the "slow" path are accounted below. */
+		++vcpu->stat.exits;
 	}
 
 	/*


