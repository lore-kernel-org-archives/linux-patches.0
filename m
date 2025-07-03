Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB302EF285;
	Thu,  3 Jul 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554867; cv=none; b=DJvX2oqbvZeTv0qllcgMgUo0xtBFAqRuzRyZW+QcvRsaEqwyP2BvB9cWaDlOHNmNEYK2Y5IC7rH6HSLldRTdnp/UKhnZu2FlRNruYdP8sb8XTL40mBPPRP5F7+ZGcYKTTvPz2CPsn8GWLl/EiFMaNzV1m4SSU5QiEn6YHqBoOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554867; c=relaxed/simple;
	bh=8gl78tKLL85QIgHYNMbOe2yK8hCSQ3ChwyRxoVvgjzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgYL2DKd41Zb8NkBFRxSnowOqkE4xjshWizg6kpukFlWTa9lovDYnMmbysnSW5/1yukk9l6q0zYJhiiCZzSlOvlQ2taQNeV9gRBZMXQy979QIt5ZYk1k50DdWLhctcH7/j6EjFragLAjwZPl6DImz8/cy0NphWBGMGBZv7oePfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueUOo0qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueUOo0qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB0C4CEF4;
	Thu,  3 Jul 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554867;
	bh=8gl78tKLL85QIgHYNMbOe2yK8hCSQ3ChwyRxoVvgjzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueUOo0qiX7xWAhiUTIFo9DAp0rjEteVTArW5mr0omoNA5JytXJ8VmK8MIg+blDi/m
	 pLugpM7NmcpuNm/mD4Iag5h+w6bUJCw04R3pgLX3IpDt8Q2UQcDQTmdua6iWYrZ7Yv
	 s3sOV8ULUDUeTCI/3OreWmn91pToIxQAovs1d4cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 104/263] LoongArch: KVM: Add address alignment check for IOCSR emulation
Date: Thu,  3 Jul 2025 16:40:24 +0200
Message-ID: <20250703144008.480666456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 9159c5e733cfa35ec863fa81960a3e7435f831fb upstream.

IOCSR instruction supports 1/2/4/8 bytes access, the address should be
naturally aligned with its access size. Here address alignment check is
added in the EIOINTC kernel emulation.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 9c47456b805c..236cbf979167 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -305,6 +305,11 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	vcpu->kvm->stat.eiointc_read_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
@@ -676,6 +681,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	vcpu->kvm->stat.eiointc_write_exits++;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
-- 
2.50.0



