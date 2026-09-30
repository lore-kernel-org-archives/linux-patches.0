Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B1051DDF3;
	Wed, 30 Sep 2026 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792827; cv=none; b=DTindIH9A0OxUycogjxJbjFHKzqc0AupKCv2Xdsc9bQD4wIrIApPaNiQvxTpdmPE0+QAYXSUX6LjYQik7UcER5nD/qOi5qRcolKODcxSVwfZIudbAkWAaa/nsheHzTpMLJTWwnOQ+yUjuz4pST404pXwMdbxhzhMeGviVr8zS+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792827; c=relaxed/simple;
	bh=UeHgNtTP8xC4oR/brHlV2FnPA6tOG66OuLazH28itFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsX1XKjRj3vHwEKpTi+ci54tP5XCI+JGt7cKSl0iyxc6oiDHgNNn/nd7zB802uyihwRPyXEhmV279EUVcwgnW8CjO8BxNqGzFP64hcoHLnbxvgCSugALEl5GzazZDnUIF6A7MMQEsbGSSArf4BksCmuc+vXIMMIrxQfDhvdzYx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylk1oEru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylk1oEru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE69A1F000FF;
	Wed, 30 Sep 2026 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792826;
	bh=Ze8djU0sXop8JOb76jRz6TmfZSzctUtiRgKLugMTDqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylk1oEruCkRCdVE8FcPNM1E4FPm5sgWIimKn3sa2/976issVYlGOBTvWthD4HiG5h
	 xav3vuJ/cNyVQh+Q6DfkC73JsFzEMBCBL8qjE5zT3ne2rLDQteaUSfTZELDd7aJST6
	 4+1GkStBTN3rpOhb5DolDIFGNG/OE3Rqlvt0xY6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/395] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152341.497286506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 64dc6f1db7e620f2e9337bb181f305fb0561da79 ]

kvm_smccc_set_filter() only rejects a range if its inclusive end,
base + nr_functions - 1, is below base. That catches an empty range
(nr_functions == 0) at every nonzero base, but at base 0 the end wraps
to U32_MAX and KVM tries to insert [0, U32_MAX], which overlaps the
reserved Arm Architecture Calls ranges. KVM_ARM_VM_SMCCC_FILTER then
returns -EEXIST instead of the -EINVAL that the smccc_filter selftest
expects for an empty range.

Reject a zero function count explicitly.

Tested with a userspace reproducer on an arm64 VHE host under QEMU TCG:
EEXIST before, EINVAL after.

Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260829054856.70549-2-kmehltretter@gmail.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hypercalls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d75727..ccbfe847f78b9 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -185,7 +185,8 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	start = filter.base;
 	end = start + filter.nr_functions - 1;
 
-	if (end < start || filter.action >= NR_SMCCC_FILTER_ACTIONS)
+	if (!filter.nr_functions || end < start ||
+	    filter.action >= NR_SMCCC_FILTER_ACTIONS)
 		return -EINVAL;
 
 	mutex_lock(&kvm->arch.config_lock);
-- 
2.53.0



