Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108894409;
	Mon, 23 Jun 2025 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714677; cv=none; b=c01V1I5Vt3gUZiEYk3940QoLbk27GGL3Cv5ZxE+B129k9Q28oXWZhQ1/gbheoFyJiNIDUEioWY6iXSGCpDhEeHFJGLtG0wxxKkyDp7WDK1w5gZUmd17cv8q1TxcEd4qloEkZQODYqhcOCqsjhGC19pJkr02I8vTrSsZ0S3bVFA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714677; c=relaxed/simple;
	bh=ITfdNYwdwQqYWa6wz0KbKHUFbkXkMAqhC/TiFOwC+Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqc/VBsyuBnN3qn5D84XQ0fhSG/Mn3aA5Cbd1avEJtAoWv9CmpvJ+4+vudxPA5JoIwAHDv+nDiOQ128zQQ16grd6q16nEsfAudvc306usTZxNNtRprt5GoHWTzUskt8ot2jasrzwDqD3N1Qu0ZqdiFKlH8KlsPEcdunT4Ckntiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJEMnLxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJEMnLxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0CBC4CEEA;
	Mon, 23 Jun 2025 21:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714676;
	bh=ITfdNYwdwQqYWa6wz0KbKHUFbkXkMAqhC/TiFOwC+Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJEMnLxc8lpJrtkFpPwIsLKPcpUwd+Won9j6uzHKHO5fCQyRbkLTOewIStyHan+M+
	 x7L6+eGE4E3Dy3VwuMUpQ/EgUN2rFiIyO+1Ka9vA6UeKB7rOKbaF9SokB4i/gaiDHU
	 AYfdmwFGa/uhnt0OR0fqETUnb1YDjUYHAy1wNn84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 123/414] KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs
Date: Mon, 23 Jun 2025 15:04:20 +0200
Message-ID: <20250623130645.143695748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1483,7 +1483,7 @@ static void svm_clear_current_vmcb(struc
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_possible_cpu(i)
 		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 


