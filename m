Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2B30CD95;
	Wed, 30 Sep 2026 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791705; cv=none; b=N8qpVpaxRL+ANYHQE/Du7413mpHtDoo1gr1NcPQ2rzpgk0ng8L+qwd01W22aNljwSk1cXzS2P7/4LlDmf0FCOx4YwS6slssQxaQ/fiHm5ixALu4zCb6NG4nmhg7Z8q7dCQPGN42Yeb5oY0pEnM7/m+2zC5HAVNT8uddzHou0SZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791705; c=relaxed/simple;
	bh=ooaRZoVH4UD0HFuz2dAycXLZK8QGlSr+kFrchyptW14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkJYwkX0vJ9qOCKA+gzYdoyJ0h9SGTIHn00hehdPyAIS2gc1tqah5MpgFrbUz3ot9glUvSOixmPGlDUyfOOiKFD6eJU0zwFQYd7YQ21iWbLyNC5Q8L5BfadVpC3ucyZpVPFkJmeb2zJBfvsWi/pzAoUwCnEkfK9vWSULPOZwpQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZMybba7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZMybba7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5BF1F000FF;
	Wed, 30 Sep 2026 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791704;
	bh=a0fwu3I0hkexGfooU1UIB9bEcmU3aOC0v4Ko2WCuuQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZMybba72g94a4jGaDzwSH4gPPSyJj5i+9cSFfVbj1qNZ/fQN2wmt5jk6FSzjiBAk
	 h/3AGYSxjWJZGoP/D5E4OJY0XciLAkMMH4Fb4UV9uRmPHNsS+9662pERAWxXunSSQg
	 dV584mgJpxHN33IIhUkHXGc+RXwob2wIi7dDPz58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	leixiang <leixiang@kylinos.cn>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 395/752] KVM: PPC: Book3S HV: Set irqfd->producer only on success
Date: Wed, 30 Sep 2026 17:24:25 +0200
Message-ID: <20260930152406.824689383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: leixiang <leixiang@kylinos.cn>

commit 1144454ea22290d7c6998a2af6239e5995476afc upstream.

Set irqfd->producer only after kvmppc_set_passthru_irq() succeeds to
avoid leaving a dangling pointer on failure. The bypass manager does
not register a failed producer, so the pointer is never cleared.

Fixes: c57875f5f9be ("KVM: PPC: Book3S HV: Enable IRQ bypass")
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: leixiang <leixiang@kylinos.cn>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260709055755.31297-1-leixiang@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5571,12 +5571,12 @@ static int kvmppc_irq_bypass_add_produce
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	irqfd->producer = prod;
-
 	ret = kvmppc_set_passthru_irq(irqfd->kvm, prod->irq, irqfd->gsi);
 	if (ret)
 		pr_info("kvmppc_set_passthru_irq (irq %d, gsi %d) fails: %d\n",
 			prod->irq, irqfd->gsi, ret);
+	else
+		irqfd->producer = prod;
 
 	return ret;
 }


