Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02A41B3927;
	Mon, 10 Mar 2025 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627385; cv=none; b=clqs+liwqk/He9mcb84oREwyiPqQoQ9E1TdykJrpANFCG6n+QWaIDtq7WvZBS12ViAoZ+fbtctSB4HezIqPVEr5/gho+y3BieW9ii1WJN4XcUzzUjXCdW+aScocwyIgi4oycnX2qndtIJt2KaYvT04FUEuccfFhYPMr+Tq1lKd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627385; c=relaxed/simple;
	bh=D7tB8EvONLaYhmOJAJo4hzBaGkCofz4Ypy204H5qb04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz4gputshIDrz8gz1DpSdn/ukiTp9hwiiIx7dGKukUlf7Ys7Kyy/qgQ5PRmAd7SA+yEsK76z6hMCvCWBZmSr0W82BdHqf+aJq6xy0gyeUfJ5r+yTdpTkgIHCOaGCT8ZZiFk2ikJ7YI1xMpmYjD3L+m4numzx9MfjF65NxUr07BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1FykEMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1FykEMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4D6C4CEE5;
	Mon, 10 Mar 2025 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627384;
	bh=D7tB8EvONLaYhmOJAJo4hzBaGkCofz4Ypy204H5qb04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1FykEMzHDaUB9guheGb4WvDeUCBwbMo2gcG4i8uGwKCpoEf9Bp7dM6Qv/y+2z888
	 8njtQwwpt/FRx6FsfsQoq+BqNSDpEgQtIFtwycZDHgSfjiDc0DWW50kLmQR6JGdBnR
	 xdnF44Xjj26wPEM2cRR81p0iIkYYVTRYRL1ERrHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 080/269] LoongArch: KVM: Reload guest CSR registers after sleep
Date: Mon, 10 Mar 2025 18:03:53 +0100
Message-ID: <20250310170500.913983411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 78d7bc5a02e1468df53896df354fa80727f35b7d upstream.

On host, the HW guest CSR registers are lost after suspend and resume
operation. Since last_vcpu of boot CPU still records latest vCPU pointer
so that the guest CSR register skips to reload when boot CPU resumes and
vCPU is scheduled.

Here last_vcpu is cleared so that guest CSR registers will reload from
scheduled vCPU context after suspend and resume.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -297,6 +297,13 @@ int kvm_arch_enable_virtualization_cpu(v
 	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
 		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
 
+	/*
+	 * HW Guest CSR registers are lost after CPU suspend and resume.
+	 * Clear last_vcpu so that Guest CSR registers forced to reload
+	 * from vCPU SW state.
+	 */
+	this_cpu_ptr(vmcs)->last_vcpu = NULL;
+
 	return 0;
 }
 


