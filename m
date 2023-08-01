Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34921F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B8C433C7;
	Tue,  1 Aug 2023 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882807;
	bh=JsutQyQYYvaNaN24RytUNgnTDSMBdmWfuAHv/Nkvs8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fPq8MH3cdKaFd/BFuWYAG4moNbBCyCU0K1Zg9/pIsZ8bu1sj6us2Twy/dnQ1ZHJz
	 +RGJnwZE9Vqgk2OyRhMoeYhDBwVviAbMKvtnvgc5MQsdzKJD6vTrzUpuv2XTP/jv0F
	 GHdQxgSRAUr5IarhwPzlLBh2ngO/PGVB1SzKF5Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 010/239] KVM: s390: pv: simplify shutdown and fix race
Date: Tue,  1 Aug 2023 11:17:54 +0200
Message-ID: <20230801091926.031512391@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 5ff92181577a89ed12ad4e0e5813751faf16a139 ]

Simplify the shutdown of non-protected VMs. There is no need to do
complex manipulations of the counter if it was zero.

This also fixes a very rare race which caused pages to be torn down
from the address space with a non-zero counter even on older machines
that don't support the UVC instruction, causing a crash.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20230705111937.33472-2-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3ce5f4351156a..899f3b8ac0110 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -411,8 +411,12 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 	u16 _rc, _rrc;
 	int cc = 0;
 
-	/* Make sure the counter does not reach 0 before calling s390_uv_destroy_range */
-	atomic_inc(&kvm->mm->context.protected_count);
+	/*
+	 * Nothing to do if the counter was already 0. Otherwise make sure
+	 * the counter does not reach 0 before calling s390_uv_destroy_range.
+	 */
+	if (!atomic_inc_not_zero(&kvm->mm->context.protected_count))
+		return 0;
 
 	*rc = 1;
 	/* If the current VM is protected, destroy it */
-- 
2.39.2



