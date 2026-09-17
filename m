Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D23B776A;
	Thu, 17 Sep 2026 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671082; cv=none; b=G2DF6W9xUuCaOb1/RfE22qauJYSr0yedYbSakCpoOhD3jClZKLU9pP+zcobfUDRJZYphk5Qcl7GPHStpCXQcXGnLaDvifU5aN0nIARXlkQqR9LHlHT+fsIQnNLxXcYatcD4TZtihFRNHJdlxpbI7zStewyxqDqHtdIw7vwfa9JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671082; c=relaxed/simple;
	bh=xu/wYXPqO/AlX5STAu/8sRUwlBFD5opx1o2wkJa1+BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVw6ywy/oNDiEFql9CZHWDAd5AnsNoMme5h/DcMtJAGoM7KSvSt9trv10vRKcOzY0rGN2rxbqt7vAEqoY6Wopd7MBORr0nuB7uXeQIbKWaFM8cbutFiif54L//iGRgYbIUzhJKyBhEOzNhLcjIx5VXj5X5/5BSuZctWI++hXvkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVJTVl+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVJTVl+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7821F000FF;
	Thu, 17 Sep 2026 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671081;
	bh=MAFOISiLRTF1fzlQoUmX4MSQ8upUn2rzWMzJnLBNxw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVJTVl+GawLrug7kMe4h95ElQV6Cl1nmBLC+OIysqF+OaYavd6/rZ74WBoV2BlKp9
	 e6fm9g3jiGIJNuHGvHYVIBvhbPs1kzXdlTmMGjrgBOM+XGjDO+hGKpDyYCLB1D3201
	 bvyxp8jlKIMXdpO513qnwGWsfaaUmxydSR27HWUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	leixiang <leixiang@kylinos.cn>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0861/1102] KVM: PPC: Book3S HV: Set irqfd->producer only on success
Date: Thu, 17 Sep 2026 16:13:24 +0100
Message-ID: <20260917151602.165057218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6069,12 +6069,12 @@ static int kvmppc_irq_bypass_add_produce
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


