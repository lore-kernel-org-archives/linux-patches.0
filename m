Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831840;
	b=SQvJIypSCEP2hlx0COALHeM1KWhPA8etwopu6v2icrOeOn/DNTJnrJmiZDHdC9B1AHGU
	 bf5hvV8Ds12HFv0NWhtOO1xmWStVWcLY7dvlnayfwV4VSXHpMWNM/mjype79aogFwsYKO
	 m5zHN8NbmPtR67fz9HVC+wEYlfJhJNMWKjJS309toCxFw2Jo5fljuKQ6st0bM0BxRQR6A
	 yp9r/L+RbdNwqtg6kEZ/0PnbFKOvUPrucKA6LflHEOEg7xIS0AVWGOKHTV6AFpM1gsyZz
	 IFZFxzFxSqP2+fm/9qpEnWIjWhtuSolZRDveaRsZe5/UtU16QNoH3vBiWd1WKZ1me3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQGN4ew2iBiEadAcC0VRjaiUR1Yf+73V4fon/rTu5T0=;
	b=fmTNanZQ4NOO0poSxz3UBmx3p3mAxwJZpTGmKU8Q8cEYyRL08iVx0es4WZA82keeR13k
	 XQm+wr6uzfNDXLMrgjZQRqSCOHkh6pMrNYq6nRWIZ7InUWSNzu1nFZzpgwn3UGIZcOe7i
	 wpvA8rHGIQ7Kw1bZh2WfHfi4trv/GooWBh7z1H4gYZFMQ4MxHWXJJRyQNVvjprhX2QzLo
	 beVp0N4Y7WEIiALVOX9OkkCgbLMO0rYkpcQKUigLJPil/g4+wGrOP1sFLm7ew26IgNut4
	 kziAvr7sm3YntjtfwF7HcdzmuGTM51hAkkU5nxZodFDgXDVuEt0STcQ/MP1s/JmizJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2k1w458m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263A6606A842;
	Wed,  4 Nov 2026 22:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2k1w458m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49B41F000C1;
	Wed,  4 Nov 2026 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831840;
	bh=lQGN4ew2iBiEadAcC0VRjaiUR1Yf+73V4fon/rTu5T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2k1w458mYsSQjZnTgiWtcHENxkHzTntDvhLgZuC1mKGkvIVSeIef4SGM0jmQr43zy
	 LQsaNhbZZZRYyTReAudPHoI639mW0vX8MAJ8RpDMs+24eCr+GVBjyQVqypNubvb4ea
	 W8oEFgwnVYiM7E2Oae+muQBOlwgWHkJqFmbMxMnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0939/1005] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed,  4 Nov 2026 16:11:12 -0500
Message-ID: <20261104211109.428241450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -798,7 +798,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


