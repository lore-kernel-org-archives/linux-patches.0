Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740953DA5C7;
	Mon,  4 May 2026 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903408; cv=none; b=hM2xHmitag7EScz4FLj02khidminWU3PABqkKMhBoU1KGT3Zxll6nAxksXw2kK34lqUUOvd8sCHr15W6lfdtpz0ngvT8if/3MctYPJ8BhofjIdNsZmdl2YJ+AdlP65oWU5EjkwsxPCZcVrzMQ+pJcztshpH6ffDYekh7h8t0x9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903408; c=relaxed/simple;
	bh=EeAz4B5Zyj9jO0XYMg0ecpzovrBM0sCmbtsnkkJ4nns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMarVj89B0H1tYKGcm0BcGRZuF18sMWQ7aWRiQDYe+akxaolQ+Hp7qfikFirtzX7CskijFv0QIcYJ0ILQV/h8eAwwCWQhygLR5Xkahxd4HupdKChjU/Y1JZM+DW83aS5UgEJr18HqUP2EVO4PiksvNkVhUtZTW9rL4Q+0JsUjTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRRQ0VCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRRQ0VCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C786C2BCB8;
	Mon,  4 May 2026 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903408;
	bh=EeAz4B5Zyj9jO0XYMg0ecpzovrBM0sCmbtsnkkJ4nns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRRQ0VCFdi7xZssld/4C82KwL7WHP6d4D0nBTJ5nmcYBtVXAxdOe6+RW2jTgSwTyX
	 0Pe3evKi0sKburIPoc7rH2P6Ba3IwNAyEuQUHS11ERgBdexDXqqq5FcSSRtzZkJPwq
	 UeayrEM5nFjipb47jfuGg+b0bmSQF16vHfHUBrdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 205/307] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Date: Mon,  4 May 2026 15:51:30 +0200
Message-ID: <20260504135150.590992482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cheng <chengkev@google.com>

commit d99df02ff427f461102230f9c5b90a6c64ee8e23 upstream.

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Fixes: ff092385e828 ("KVM: SVM: Implement INVLPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260228033328.2285047-3-chengkev@google.com
[sean: tag for stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2366,6 +2366,9 @@ static int invlpga_interception(struct k
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;


