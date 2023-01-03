Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677D138E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BF5C433D2;
	Tue,  3 Jan 2023 08:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733800;
	bh=AOiE+SRsXqpWJtEiNQApmCYC5Itndr4Vq5tqV3XRN64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSainjekIhSAqirC2ksup7xWT++OqV5r28wy+Ss6qofyWDXtTFXnPExvVP+XqlE+K
	 fE9+iFC4RPyfO3SJiiw2B1r4tjXEr29CFBQHSegI23eLLdhKzWbU0yo4G/jmrjEEuM
	 orhMh3bZblJ4HjkPxZmpCH7qefsDjNQWNkFpVwV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Petr Mladek <pmladek@suse.com>,
	Seth Forshee <sforshee@digitalocean.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 48/63] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set
Date: Tue,  3 Jan 2023 09:14:18 +0100
Message-Id: <20230103081311.470552007@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seth Forshee <sforshee@digitalocean.com>

[ Upstream commit 3e684903a8574ffc9475fdf13c4780a7adb506ad ]

A livepatch transition may stall indefinitely when a kvm vCPU is heavily
loaded. To the host, the vCPU task is a user thread which is spending a
very long time in the ioctl(KVM_RUN) syscall. During livepatch
transition, set_notify_signal() will be called on such tasks to
interrupt the syscall so that the task can be transitioned. This
interrupts guest execution, but when xfer_to_guest_mode_work() sees that
TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
exit to user mode is unnecessary, and guest execution is resumed without
transitioning the task for the livepatch.

This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
is expected to break tasks out of interruptible kernel loops and cause
them to return to userspace. Change xfer_to_guest_mode_work() to handle
TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
loop that an exit to userpsace is needed. Any pending task_work will be
run when get_signal() is called from exit_to_user_mode_loop(), so there
is no longer any need to run task work from xfer_to_guest_mode_work().

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
Message-Id: <20220504180840.2907296-1-sforshee@digitalocean.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/entry/kvm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -8,10 +8,7 @@ static int xfer_to_guest_mode_work(struc
 	do {
 		int ret;
 
-		if (ti_work & _TIF_NOTIFY_SIGNAL)
-			tracehook_notify_signal();
-
-		if (ti_work & _TIF_SIGPENDING) {
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}


