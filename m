Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7264FDE56;
	Wed, 30 Sep 2026 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786908; cv=none; b=FvDOIICI4Cf5aIaFcKWTeNx3j6QQ/clm9ix7OiQfZcBKI/jq1DoXrRemIOAetp2SI0zs/2sE2RxMBV4jswfcLy1TW/WV+C334PjMZXfP2Y2uRpe3+hxVSvnV1JOKSDIb5EakeK3g4FuWGzH6VC6XFJxoRrzPO3wK9noHdbjkW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786908; c=relaxed/simple;
	bh=CSUN/2A3WXr1Ez8LwRBvtcnNXvKwbBiRbdkLfbITlyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW2GJVxUiuPCSu55ACuEfNobrlsN40S5q8+v58qT1MNB3xrs13I2UMoKcdAMA5qYUNqY3EQmevUPDu5YTIoI2Nd9tai2mlnX1vz/3KFZ5bmWnAN9wRYzyGMBruiLC0nSj8jHihjcMohzmSefhVth+J6optBKme8H0USwq4dgmkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZWSH6U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZWSH6U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E334F1F0089A;
	Wed, 30 Sep 2026 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786907;
	bh=DVNtHOkUVYaNTShjwDQe6nD1OoD7tD2KFZMqxVUwDZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZWSH6U40+9n6gADezZCC2OG/4QNyT6Pp5/BZ6jkot+otiiEADy/1nJICzeS/hDD1
	 /oJNZlcRTNYM7bwkeKlqGhjnzYnkXUggP4MfV/tJH/tcaRSrnKOqN54h3PmFT7T2X/
	 4fqVTPgd8/NOM/1U4QIUFKKC8pSqoUQfme7WeYr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 043/457] KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
Date: Wed, 30 Sep 2026 17:22:28 +0200
Message-ID: <20260930152346.966818084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 2a2eb10795a1e495aebc7f829ccecb72c05b4fd9 ]

pkvm_vcpu_init_sve() clamps only the upper bound of the host-provided
sve_max_vl, so an invalid vector length reaches sve_state_size_from_vl()
and the WARN_ON() there, which is fatal at EL2. The existing
!sve_state_size test rejects such a length, but only after the macro has
run.

Check sve_vl_valid() before deriving the state size. A valid length
cannot yield a zero size, so the !sve_state_size test goes with it.

Fixes: 5db1bef93342 ("KVM: arm64: Track SVE state in the hypervisor vcpu structure")
Reported-by: Stefan Teodorescu <fane@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260825085948.1674721-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..095ebfce91b08 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -460,14 +460,15 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 
 	/* Limit guest vector length to the maximum supported by the host. */
 	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
-	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
-	if (!sve_state || !sve_state_size) {
+	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
 		ret = -EINVAL;
 		goto err;
 	}
 
+	sve_state_size = sve_state_size_from_vl(sve_max_vl);
+
 	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
 	if (ret)
 		goto err;
-- 
2.53.0



