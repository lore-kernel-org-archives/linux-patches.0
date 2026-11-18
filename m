Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051985;
	b=VwSBafnIL2hlkxK8b7+vnFtHTHVebhq0XiLOn83+0Fo6N4ivxU3SRmPziqJghyTlqei3
	 kZLH8dPso+T8Zw4+vTa+x8X9AE7+JVYCg4oB/nbvJhciSDghrCf30fRbuf87xC/N61g93
	 Yb19RsWip6SNnm/iII5a1hlLP/G2TYYynOkyYFOBkggg1WMOi3eF6xXHrpAtx66Bij0Ci
	 Ev9oEdKmi18zE3BsKAO7lRdxZLk57dgGkMJhyVzW47zYkTmHBlgpW2F2I+xD+tbcKkglV
	 LgPheCx98cJ0VOwyf/ieT9MqAoRiWEK1ZhhWAV+4O37JosWlYgQST3jjQF2gLffU9oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qpPM4gZvm7h8mTb6MZMOHMGDeQE2a0Z5Kx78Px/q/fM=;
	b=CuOBM7o6KfqCRNJEywBVuzECB2Ohlw+6/9zGAuwQuVY4QUvzI1RTXneVZX4DZaI22WtH
	 03sjxVN7ClYDOnBDLFkfFqd4BkqGjW/R/m57NRwHisW6gMUpWqiHmNnpR14ldPDCRGG6W
	 vCdEP4xrvD3AspxIBAB177smE+uWD/g9jJkAsd56R1lcr06Pahzp8UC8aDeOGQvKXn1qE
	 0QD1s7JchF3stFbfF4EpGc0dzRp9gmy187QvJouOi4Y66Tib9P69lI+v1T2zmPpbKBwxV
	 sCCAYwoppcCvzOV9FaSHgU3eAkkoINq8sfPfMviOF8cjbu0xu29ISuJTQTYvDh7ZRPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZ7onHqu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9F9606A333;
	Thu, 19 Nov 2026 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZ7onHqu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FDB1F000C4;
	Thu, 19 Nov 2026 01:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051985;
	bh=qpPM4gZvm7h8mTb6MZMOHMGDeQE2a0Z5Kx78Px/q/fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZ7onHquA15CL5zo0+/xOTZScgKfh5rn6ysdHe+HhuVrGb2ymYMpz9wEtLaMeYHXv
	 gKKtGXeAasIqZJf3OMTx1CfZ4Xy2Xyt8t8vtVjrt4N4jfiH0IpJ+nRLCk2XfFmIj6n
	 nihV9xwRJKY+UKuVR6cY05CScoe70l2N7KO/haDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 0366/2214] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed, 18 Nov 2026 15:34:02 +0100
Message-ID: <20261118150025.303708371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2616f497506a772db53e7bb1024cde50b4c165e0 upstream.

Ensure all reserved flags are zeroed when setting the msg_pending flag as
part of SynIC message delivery, as setting only msg_pending can leak seven
bits of kernel stack data to the guest.  E.g. gcc typically uses a
bitwise-OR to set the msg_pending flag, without initializing the on-stack
variable.

Precisely zero the flags, e.g. as opposed to zeroing the entire structure,
to make it somewhat more obvious that the flags *need* to be zeroed.  E.g.
it would be quite easy to misread the initial read of guest memory and
think that zeroing the entire structure is completely superfluous.

Fixes: 3a0e7731724f ("x86: kvm: hyperv: simplify SynIC message delivery")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/20260826184449.814130-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -768,7 +768,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


