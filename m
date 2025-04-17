Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F61B3934;
	Thu, 17 Apr 2025 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916102; cv=none; b=XWqtHoYw+ROGM5aaTa19udoZFq1m8weF+2EsAZeb2v5x7ctorDKVDya/vfJOjrBPfTUZK/xiwJTSiQuNqOVxoFIDPbT0C2p3/QvVcesHYUDiIcA8qQSk4TeCs4YoNqZUbLjYB/S9lz8aCtLCPG5GCnsWBbDMdIrqsYRzcZA1xu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916102; c=relaxed/simple;
	bh=B0ksyNnILsJsR9k568QpaOgnACgTkFFCQf6Y/UoTmao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO+qw/CS2vi+WOmfCcDJoctM9TQZUkKsb/nppGyZ7VPCbv5tlEMfmiCFIWkLpVwGp4v0Fn8WyGG1yeYUP+COWML4i2IzbbJGBb3V7BcvLo5bH8KRyjeQC6ynTEXfyi+6jH+B51YrkCQ/RQVdfUcbyRxsCnBYnsRBE+vmoRoT51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VW5slLBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VW5slLBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED6EC4CEE4;
	Thu, 17 Apr 2025 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916102;
	bh=B0ksyNnILsJsR9k568QpaOgnACgTkFFCQf6Y/UoTmao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VW5slLBLlRyXXYCUbQ0NUdRMeChd9vMJKKfjtXZHJnkfDKw3ywzJrVjxvhzLIfQeu
	 zFLmI63atvHrbOiQkkUKQcsHKOH2dCAzNee51RmedX9Q1aBiqokqJaVHaaZHVSaaoI
	 /PXcXbG0hLpXAXlMYU0zlaQCk4ODt6YuEegVbKr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 343/393] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
Date: Thu, 17 Apr 2025 19:52:32 +0200
Message-ID: <20250417175121.395486884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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


