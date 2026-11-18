Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057933;
	b=A5pKbRfu2/goKbbZDq1mQuTTzy93HWrAlFFtzjjBe7IvBt/McuhFNWyjkNmyhjhFeRtQ
	 4oF4XxowVIEn9ZpWUNvsgCW2Fm9fDWi8IidYBY6MVHzALn5mmdTb5OH6bRanBgQFtNGMG
	 0eKWm26c2YV0Z1zR4cFXXNQD6nSfEndiniXLMjcng6rLME2TK/zDf1ij7UsFAzV1/CMUz
	 3M1nvNekB7TeNl+UvpDEa3FToEv5li9xCafnKtTQlyexnd6vlssDkLmEYyYj43iJ6SydZ
	 lij2lpv6cncQepoXyYgY0opOTlik2V4BPetLoWdgBuOQY+6/mngA+34znby1V8IlBdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCxSgEAkItOJSWFANqWpss1CQIe29VMjny6bMrgvlQg=;
	b=vEtKej4zKbkIQfXe8SYHktXkqxLB7pQkIAaesztNt3jhYzjOiFwQoLNzhd6di71BHEY6
	 3AB+hQO8PBE3o4wxe7CdccBpujB85U3bhYE/pfi/5m7HYBhMlRjzSJ9Il2lkSGw4vNalp
	 oNKD/AU4M4xgaxQZ9sqRNEi3t2BLzioCO+TRXSnLq19pXFc95/m3338qWl13YZwR4R/If
	 V7C9lbncqb4Bb/pIuGsmmBGGPaGjHCKjPDebb40DN+4N+D9hN8odfVNcSXynVQy9e37kF
	 1NilzJe1xD2DnQVyd7yp9ytujIiztvEC8cuoZl4JgKIB5Npj2IzoD2fLsiu73+FaIhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYWQp6n1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6393C606A320;
	Thu, 19 Nov 2026 03:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYWQp6n1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB341F000C4;
	Thu, 19 Nov 2026 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057933;
	bh=tCxSgEAkItOJSWFANqWpss1CQIe29VMjny6bMrgvlQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYWQp6n1MpmoOImlyh8++naG6qINn9uCNe2J39rAMhkxLomw7FnR9ChxpSCadmoD3
	 yaI3Etfa56NMG5LJQlJ9d0Qtgw6R+t1OW2zCj6z0iPDvIlR+02S3EDC77VgJoHNWy9
	 MHyyYGWmZBOmmpxXVxnpcOo4gEoWjy/6lAo3r+h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 0304/1848] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118145924.906115999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,7 +741,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


