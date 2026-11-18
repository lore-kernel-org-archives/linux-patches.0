Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044738;
	b=ZZQsfady+X10JOqmKrsHAWFIknfIYTNpBu6N3mcpaz7ioF1CR28sXkzPb8cAS0MhE3Er
	 koV0zUMakfgre16OUnprnGy9on/uaa9emCBK3R6HIupy0zv6FG0y/wqPNHT9ftrto0qs+
	 e02vvdrv6Jj4ikInoG7Y1IZX94F1o/QGe06oBHhbCEDVhalzrat1Ld7sXIfivRle9bD3W
	 xD2wORSBzTXoraPwi5ItY0PHfsnNSb+UvSgyJ8k6EJ7tOSHWQkMefTgY6cUhONCTYu6iq
	 3APTEtauoCBHeMN0dgd2p115JpjQI1NGMI//fEmiqy/Q9kstgObWtjN7HcR6wB6qOig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6vadb7PO25hmz7gZCi7Vag+z/RcLWPOkEcqShRI7iGs=;
	b=PBSHlkF9ea78+hFs2YSMqdDT1BkIWC1V5Z9W1/UBGcOGftpm83Sr2tjOizBikEiNW3SY
	 ID/3rq1akXV1rb2yPuykqzXGtwEp/hsU1quay/Vs5mh9cVSeSOV5DimxpRKAUI+Lv8u+z
	 TEB9KgGupIVMxBCA8IVPUxyEYWJtjhVMJul9lmFxOjClC/d5GSmXT4MDUh3hpI7P9whX5
	 W+uxw+lQh6hg0PjCXTYz3MuslrMPv05UJw55FkL1YdFfRtPHhvW/GRBE34kbv9aMISSA0
	 OXIkpKJDxqSDak6lBNdCLp4d3MvASKb8IUENifb/Yf74IEfrDIozmvRDANTXxar8GCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IstYBFRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2789606A320;
	Wed, 18 Nov 2026 23:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IstYBFRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3991F000C4;
	Wed, 18 Nov 2026 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044737;
	bh=6vadb7PO25hmz7gZCi7Vag+z/RcLWPOkEcqShRI7iGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IstYBFRZp3w2Tc4PZoeaS5cumJ6Z//qCFc4IYw5icM7RtFWq4w1/w5GK8DnWzUS1q
	 skoIr6l2pxNpou/k0l0Glbb7n1saHbLylXJ8yB1YYyo686CpNooPMs27WzLLkx4g6E
	 L/KTsjNfMkkzGeQH9huo1cJzTgWHnO8Iqig4Fyi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0627/2857] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed, 18 Nov 2026 15:27:41 +0100
Message-ID: <20261118150224.073940354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -772,7 +772,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


