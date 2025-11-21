Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A794264612;
	Fri, 21 Nov 2025 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731279; cv=none; b=i8OC375cQ9ng5zAdmKZXlu0aa03GOxwXcdAakMhAlIRCzD6sSEZOd/k+CTQ7QuI3oeDxSWQlZnw4+tymQyjeLMzaCrcrP0pHiMJ8zjpJTnVdhjWMApV1qXr2OyeEhLpadr8dhCdiOt/zw/XObK+s2qdzrDlN2h0RFwfgj3rOtwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731279; c=relaxed/simple;
	bh=yR6SZE6LY1o5bc8UGa7NIaYNe4hpcUnPk1ahiQoRYLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKY/QTO93+su/Hh36TgoUc1b8XUMUBUIZftViuSOwgVRYoY4xCBfclMjEhSOgtgv3mcZGdbYwi9GAdgSrpn0Ez4cHahLntgc0Tuk2y2y+oHvxLpIg8qIreNKntQqET1jt0LgVs20b/uaRvTgn9tMA+Y52LuETsgCnTjD0flL+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttV3aHMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttV3aHMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5369DC4CEF1;
	Fri, 21 Nov 2025 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731278;
	bh=yR6SZE6LY1o5bc8UGa7NIaYNe4hpcUnPk1ahiQoRYLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttV3aHMlx2bCdl8bogMqkLVTex10+6ytDhIWsDNwM5EuDv9p3+1DAAPxj8KR9tjI0
	 VFufQQDQSj+7W6ZHCmmE/BTE/bSLYq7QU8fOTCb8A5GT9Vnrcrmfurlhe1E2R0mxzl
	 Qu7f/CqpfcyWF4W+h49sIJLhu0BUSXbpHTZvftRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 151/247] LoongArch: KVM: Fix max supported vCPUs set with EIOINTC
Date: Fri, 21 Nov 2025 14:11:38 +0100
Message-ID: <20251121130200.144839852@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 237e74bfa261fb0cf75bd08c9be0c5094018ee20 upstream.

VM fails to boot with 256 vCPUs, the detailed command is

  qemu-system-loongarch64 -smp 256

and there is an error reported as follows:

  KVM_LOONGARCH_EXTIOI_INIT_NUM_CPU failed: Invalid argument

There is typo issue in function kvm_eiointc_ctrl_access() when set
max supported vCPUs.

Cc: stable@vger.kernel.org
Fixes: 47256c4c8b1b ("LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_ctrl_access()")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -439,7 +439,7 @@ static int kvm_eiointc_ctrl_access(struc
 	spin_lock_irqsave(&s->lock, flags);
 	switch (type) {
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
-		if (val >= EIOINTC_ROUTE_MAX_VCPUS)
+		if (val > EIOINTC_ROUTE_MAX_VCPUS)
 			ret = -EINVAL;
 		else
 			s->num_cpu = val;


