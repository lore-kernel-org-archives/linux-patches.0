Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEF324DCE8;
	Mon, 23 Jun 2025 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684661; cv=none; b=GH6AcPj/38wedr39UUxB4tSB4Uf9aIrHiKvQgmznRp7NcDti939x0lqsho4ANd2jw78bfd2U1yPM+kCWfyb1sQi51Ayrd/CLTidED8dBfnUoDr79r5NEVE/+hDfstj3zXAuVHyKqggJ8v4wMy2vyG87Du9fQhTvZgwO1OTiboaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684661; c=relaxed/simple;
	bh=Fa9ib11ZviEsTVUUTlW8wPnB0f4NSTVIqNeIrhK5DDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPmwLfP5XGNnD2EM7MrMnnwhVPGF26Bhaze0rMhelsGUPEfHzueUXFFMQ2bZFE8rYsg11JiQgrfMY1fZ99ZEdyZbArCOOVdrxcIHfTVz6EczzNXVA1EB3ThuNj8uKbEKJ5dzY/XtFmWQeggluJKs7nDJDC9RQJWguENV1L04MAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIhRe0m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIhRe0m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CBCC4CEEA;
	Mon, 23 Jun 2025 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684660;
	bh=Fa9ib11ZviEsTVUUTlW8wPnB0f4NSTVIqNeIrhK5DDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIhRe0m/BgqoFEOkHX9Hk61c7vO8nZRBc+vg2fx4DQI09AGZOQhhv5hDZxVAIlkpv
	 mGzF6R3qwxZxoqWCEzAXS14Lu0YppbB/rRIOyfmOTCuhjgeVQYEPXBrPaReKi2yzQz
	 EKxaXPXMa6KDXytcBn/q8mOflD8SI3TLHsI1/2rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 149/592] KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs
Date: Mon, 23 Jun 2025 15:01:47 +0200
Message-ID: <20250623130703.826719365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1488,7 +1488,7 @@ static void svm_clear_current_vmcb(struc
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_possible_cpu(i)
 		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 


