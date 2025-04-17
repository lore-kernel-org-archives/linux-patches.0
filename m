Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116F5264A8E;
	Thu, 17 Apr 2025 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914894; cv=none; b=TGJUgDTjPewwEe5NrkRWfYmxfSjKoFHlqWcyl7PynYIn9ox/DLXQrgIiC/YGpS4sgx1xe8U9Lhnze7NBV7XOsbK09zpCdPUGWpQVJPgkZTidL/Fsp31gvTJbPEv4QB9ixNdP0s06He2v/vmfIXnigiCuL13Z3euUtlZmfCsrJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914894; c=relaxed/simple;
	bh=dYYXHyW2+EVyIRZF9cD911HPyYVSFMtHIQkkdEz3UIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scoUhROgXzb+CPGJhM4arQvy4WXKJGZvxlpAn8WzLth4f+it+roR9PBmMliR4UzfRdxBl9rGNFB9jNKAKKHtZ3iu2/4h/if60EDkteNnictMYK4wo5zNqKTv8x1flhdYyRVF47iXAOJ/ZkN1ADHfpp779N4pchPK2tes3B3pmv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twj2BUW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twj2BUW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81770C4CEE4;
	Thu, 17 Apr 2025 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914893;
	bh=dYYXHyW2+EVyIRZF9cD911HPyYVSFMtHIQkkdEz3UIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twj2BUW7toPhHgsJVGCIJUKIssqA2SSr94Sr1VKEpoxZ13POairekHY2ikm6SV8Dn
	 bCjoOCuYST+z4dNMbV0zRhg4kEMcWanGB3kOZ4RpLn4wPWgYKU4vBsT5CZA/AtIqjp
	 n0e4d/ZUQCtXx5/hgcI1sQ/015/oEkS4NodsB6BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.13 365/414] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
Date: Thu, 17 Apr 2025 19:52:03 +0200
Message-ID: <20250417175126.146408371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit b4392813bbc3b05fc01a33c64d8b8c6c62c32cfa upstream.

Currently on book3s-hv, the capability KVM_CAP_SPAPR_TCE_VFIO is only
available for KVM Guests running on PowerNV and not for the KVM guests
running on pSeries hypervisors. This prevents a pSeries L2 guest from
leveraging the in-kernel acceleration for H_PUT_TCE_INDIRECT and
H_STUFF_TCE hcalls that results in slow startup times for large memory
guests.

Support for VFIO on pSeries was restored in commit f431a8cde7f1
("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries"),
making it possible to re-enable this capability on pSeries hosts.

This change enables KVM_CAP_SPAPR_TCE_VFIO for nested PAPR guests on
pSeries, while maintaining the existing behavior on PowerNV. Booting an
L2 guest with 128GB of memory shows an average 11% improvement in
startup time.

Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
Cc: stable@vger.kernel.org
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250220070002.1478849-1-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/powerpc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -550,12 +550,9 @@ int kvm_vm_ioctl_check_extension(struct
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_SPAPR_TCE:
+		fallthrough;
 	case KVM_CAP_SPAPR_TCE_64:
-		r = 1;
-		break;
 	case KVM_CAP_SPAPR_TCE_VFIO:
-		r = !!cpu_has_feature(CPU_FTR_HVMODE);
-		break;
 	case KVM_CAP_PPC_RTAS:
 	case KVM_CAP_PPC_FIXUP_HCALL:
 	case KVM_CAP_PPC_ENABLE_HCALL:


