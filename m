Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040261ACEDA;
	Mon, 23 Jun 2025 21:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713739; cv=none; b=nH21kp3KxfyVndEkwRPLTyaquzVsLW7bjgue2MUpJAx/0y94u7qJsYHqPrW2ZDPCLq35Jb2UIY5hMg2QWcLMvWkHxT3v9G+jJ2Hd/FmpiREJnOnfgQ74p442IdMBdKWeHLdiatx4Gu4bLgEoebHTtVqIS0j5H0MGR13e/8LDtn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713739; c=relaxed/simple;
	bh=1w5TCGJmUVZmHU9cvlpxmyNUAfW+IKe/lQ+Yf6N43Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abVDs7H+srH0xHz6SsykRSTcca+1BT0lFmQCB0jYOftqavXVQW9ZPEOZkjKwDkCUUjhe0DVD0aXxFse8hvpWzJlIY7aNXMob4EoNPRE9fat1ivXX3/tJj3C5XHVA2fAF19usAQIP87zvodyelEqG32vWjR1Lhe/Jnby/2pg8ahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUEsP02B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUEsP02B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA9DC4CEEA;
	Mon, 23 Jun 2025 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713738;
	bh=1w5TCGJmUVZmHU9cvlpxmyNUAfW+IKe/lQ+Yf6N43Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUEsP02BTg6yXijqo7Th4/KaTjGFGplBo1Azr9bU4IalqgIZB1en+kvZvXnidw+ta
	 x01Qo1GvBqXcKFs94E9FyeQ/rqBLL7mGP3hAVCMraWEwk/nqs+zZQzsSXN2mqV/Oha
	 BOGCgyTYWjLsqinGYn7InDN6/cMgsuXL1GuXcZ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 087/290] KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs
Date: Mon, 23 Jun 2025 15:05:48 +0200
Message-ID: <20250623130629.598102000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 1bee4838eb3a2c689f23c7170ea66ae87ea7d93a upstream.

When freeing a vCPU and thus its VMCB, clear current_vmcb for all possible
CPUs, not just online CPUs, as it's theoretically possible a CPU could go
offline and come back online in conjunction with KVM reusing the page for
a new VMCB.

Link: https://lore.kernel.org/all/20250320013759.3965869-1-yosry.ahmed@linux.dev
Fixes: fd65d3142f73 ("kvm: svm: Ensure an IBPB on all affected CPUs when freeing a vmcb")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1503,7 +1503,7 @@ static void svm_clear_current_vmcb(struc
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_possible_cpu(i)
 		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 


