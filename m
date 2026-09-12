Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA822594BD;
	Sat, 12 Sep 2026 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221691; cv=none; b=iZ1n4p6aQ7z3tp4qrlBj1ShKGYYZmTGOSbr9H7WI0QnzvjCevTD0bJMHZ77g3K1W1m8OWDJ9VdrI3IDtrSRa5k8pX7goZuf5FTr5H4HxAdyR1fFlPGdvLMU+kv9OQpvZu827Ocv+h2l5XpwE6tXDK2GavYbXngVusXfyHKxeWDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221691; c=relaxed/simple;
	bh=BsMhMNP0eZabs17+GjbfjfdMLn1v8+nXGOPN/fpwvkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCjwEDErO4hffBkxyTJCFzBWBTnJFNyxIy5nyAziEYVE7oCZ+LU6uO2tpQDuYAVl7TDPLtynqQAP37Wr257xBd0QEnKkU0s7c92i6XGmQhyURD9LzEls/ye864d2LuTdyLIMwD/ah16LYyVx1CEdqJBU2X9PYARhCx1JtLeQP3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFRP7YZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFRP7YZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A34E1F00898;
	Sat, 12 Sep 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221689;
	bh=noNtOUTtzifc2aQQITzLdanpDYO0R4AaxoLMsbDSnyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFRP7YZcHDQ8NCu8T3GBkgTNyUH3tsJ1ApEGUIZN/6SFUwbpkjTyrBcVYx2XMNLZL
	 3Sk7VsZTUGAqkwQxUvBALBSrwLtgGKLi5+mCSPKpAm4b04GuWvb/hqRgkOpSiWg25A
	 aA/hhG/0H4AFfkS3mOvOrbdHj5madZpKY/0DQFiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.6 0432/1424] KVM: s390: Fix memory leak in guest debug handling
Date: Sat, 12 Sep 2026 08:47:44 +0200
Message-ID: <20260912065616.958193199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 121ea1de927c8b9bfdf53c31cad27b86d5de0293 upstream.

bp_data is freed only for the error case by kfree(bp_data).
Every successful KVM_SET_GUEST_DEBUG will leak bp_data.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-5-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -271,6 +271,7 @@ int kvm_s390_import_bp_data(struct kvm_v
 	vcpu->arch.guestdbg.hw_bp_info = bp_info;
 	vcpu->arch.guestdbg.nr_hw_wp = nr_wp;
 	vcpu->arch.guestdbg.hw_wp_info = wp_info;
+	kfree(bp_data);
 	return 0;
 error:
 	kfree(bp_data);


