Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77847168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803ADC433D2;
	Mon,  8 May 2023 10:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543349;
	bh=lE0iVr6vFooUwwIpPU3OVgO1WvMteKCsrak9kTdvJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3X7ftkYbXBhcGBQXtgnKew8hQesEgfc3RWQfo7aqKvsBGdn9Nz1sZ3MBUYdrEpKR
	 EBbm/tx2JFyq9TxrXSxq8kZP5UnJ9OHhZ3qtG/hypJkLioU6VIOUn2BVEUjywp0MyK
	 1xG6QLK4uU4YZzOfQ7gKhLqbt2AWD+CW5NKXgLtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 062/694] KVM: arm64: vgic: Dont acquire its_lock before config_lock
Date: Mon,  8 May 2023 11:38:17 +0200
Message-Id: <20230508094434.583756279@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

commit 49e5d16b6fc003407a33a9961b4bcbb970bd1c76 upstream.

commit f00327731131 ("KVM: arm64: Use config_lock to protect vgic
state") was meant to rectify a longstanding lock ordering issue in KVM
where the kvm->lock is taken while holding vcpu->mutex. As it so
happens, the aforementioned commit introduced yet another locking issue
by acquiring the its_lock before acquiring the config lock.

This is obviously wrong, especially considering that the lock ordering
is well documented in vgic.c. Reshuffle the locks once more to take the
config_lock before the its_lock. While at it, sprinkle in the lockdep
hinting that has become popular as of late to keep lockdep apprised of
our ordering.

Cc: stable@vger.kernel.org
Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230412062733.988229-1-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1958,6 +1958,16 @@ static int vgic_its_create(struct kvm_de
 	mutex_init(&its->its_lock);
 	mutex_init(&its->cmd_lock);
 
+	/* Yep, even more trickery for lock ordering... */
+#ifdef CONFIG_LOCKDEP
+	mutex_lock(&dev->kvm->arch.config_lock);
+	mutex_lock(&its->cmd_lock);
+	mutex_lock(&its->its_lock);
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&its->cmd_lock);
+	mutex_unlock(&dev->kvm->arch.config_lock);
+#endif
+
 	its->vgic_its_base = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&its->device_list);
@@ -2752,15 +2762,14 @@ static int vgic_its_ctrl(struct kvm *kvm
 		return 0;
 
 	mutex_lock(&kvm->lock);
-	mutex_lock(&its->its_lock);
 
 	if (!lock_all_vcpus(kvm)) {
-		mutex_unlock(&its->its_lock);
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
 	}
 
 	mutex_lock(&kvm->arch.config_lock);
+	mutex_lock(&its->its_lock);
 
 	switch (attr) {
 	case KVM_DEV_ARM_ITS_CTRL_RESET:
@@ -2774,9 +2783,9 @@ static int vgic_its_ctrl(struct kvm *kvm
 		break;
 	}
 
+	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->arch.config_lock);
 	unlock_all_vcpus(kvm);
-	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
 	return ret;
 }


