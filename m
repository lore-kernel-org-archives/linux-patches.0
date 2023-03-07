Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97424BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D7CC433EF;
	Tue,  7 Mar 2023 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209610;
	bh=P5HzVKcEUCVyb5REcopqsBZna/jJTH8Ems7YQtTQ/AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrO0lgv51HKeJ8ZOimLwtVSys4rXlLo7zNg0FIA3uYgfUP1y5jDUfo4YRX/ynXvhu
	 CmxDJ2fbP9Zyp1KXDjbpNqhat5lSCV5E5Zk2YCwQgKudn+gf03sF2jEkINI3k25vhi
	 zjO5cyBjPV8W851sMD4AI9e95lEyBy+RrbmaSIWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Pierre Morel <pmorel@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0274/1001] s390: vfio-ap: tighten the NIB validity check
Date: Tue,  7 Mar 2023 17:50:46 +0100
Message-Id: <20230307170033.568930511@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit a64a6d23874c574d30a9816124b2dc37467f3811 ]

The NIB is architecturally invalid if the address designates a
storage location that is not installed or if it is zero.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b0b25bc95985b..2bba5ed83dfcf 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -349,6 +349,8 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 {
 	*nib = vcpu->run->s.regs.gprs[2];
 
+	if (!*nib)
+		return -EINVAL;
 	if (kvm_is_error_hva(gfn_to_hva(vcpu->kvm, *nib >> PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.39.2



