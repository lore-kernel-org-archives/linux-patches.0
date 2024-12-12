Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE87217F34;
	Thu, 12 Dec 2024 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016101; cv=none; b=uijZR7Q1fzImn9LSGYBdlOps3Lfa4ft+yUqFu9+j35bLk5Y8pxysDygUtaOgBfrL/tROkoPeNCeDXjDLEgEbzT8tM86RkRkHYY3F/jwkMyImgZ4lDJG8Wrw8QdKJL6KI4hyQsDdm/H3cVYYOS4+cMFiCECyh3eWWZ5uvXjvrxYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016101; c=relaxed/simple;
	bh=1IBtwzBzVnwFhlDQeUeJ1aGp6ad88gC6AoUKSIrkn/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ9bCfFJEu35dOB5OikF3oPBMn5BGArJ2ca5/U8JY4mSKZtlGKoIHboI7QsJd9kf0HrIeQgYGobt7Z3RF/qDvRzc/htPxdp/kQ+Hc2nmuzsSztfzumRY9bgGKo12Bb/AitopVj0u4ELfu6yjxcOHmasJsLOVgtf4x1Kln2MOsgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbjcV18X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbjcV18X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A947C4CEDD;
	Thu, 12 Dec 2024 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016101;
	bh=1IBtwzBzVnwFhlDQeUeJ1aGp6ad88gC6AoUKSIrkn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbjcV18XUfBDfBa73NjY8VTCdG6UIJm16d90Y9jzhDUl5adf9nkkDVDev9qrYbCfy
	 BydWN6Cqqt6svAOYQTvt79Lohiko6mPGBOaSlL5bcr6eiwKPRW0VvV6HpCkuj6G/vQ
	 VouQxV2uo29daiekD6RWT5zM5EliXqonaqM69KtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 125/466] LoongArch: KVM: Protect kvm_check_requests() with SRCU
Date: Thu, 12 Dec 2024 15:54:54 +0100
Message-ID: <20241212144311.744179045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 589e6cc7597655bed7b8543b8286925f631f597c upstream.

When we enable lockdep we get such a warning:

 =============================
 WARNING: suspicious RCU usage
 6.12.0-rc7+ #1891 Tainted: G        W
 -----------------------------
 include/linux/kvm_host.h:1043 suspicious rcu_dereference_check() usage!
 other info that might help us debug this:
 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-system-loo/948:
  #0: 90000001184a00a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0xf4/0xe20 [kvm]
 stack backtrace:
 CPU: 0 UID: 0 PID: 948 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc7+ #1891
 Tainted: [W]=WARN
 Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
 Stack : 0000000000000089 9000000005a0db9c 90000000071519c8 900000012c578000
         900000012c57b920 0000000000000000 900000012c57b928 9000000007e53788
         900000000815bcc8 900000000815bcc0 900000012c57b790 0000000000000001
         0000000000000001 4b031894b9d6b725 0000000004dec000 90000001003299c0
         0000000000000414 0000000000000001 000000000000002d 0000000000000003
         0000000000000030 00000000000003b4 0000000004dec000 90000001184a0000
         900000000806d000 9000000007e53788 00000000000000b4 0000000000000004
         0000000000000004 0000000000000000 0000000000000000 9000000107baf600
         9000000008916000 9000000007e53788 9000000005924778 0000000010000044
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<9000000005924778>] show_stack+0x38/0x180
 [<90000000071519c4>] dump_stack_lvl+0x94/0xe4
 [<90000000059eb754>] lockdep_rcu_suspicious+0x194/0x240
 [<ffff8000022143bc>] kvm_gfn_to_hva_cache_init+0xfc/0x120 [kvm]
 [<ffff80000222ade4>] kvm_pre_enter_guest+0x3a4/0x520 [kvm]
 [<ffff80000222b3dc>] kvm_handle_exit+0x23c/0x480 [kvm]

Fix it by protecting kvm_check_requests() with SRCU.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -240,7 +240,7 @@ static void kvm_late_check_requests(stru
  */
 static int kvm_enter_guest_check(struct kvm_vcpu *vcpu)
 {
-	int ret;
+	int idx, ret;
 
 	/*
 	 * Check conditions before entering the guest
@@ -249,7 +249,9 @@ static int kvm_enter_guest_check(struct
 	if (ret < 0)
 		return ret;
 
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	ret = kvm_check_requests(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	return ret;
 }


