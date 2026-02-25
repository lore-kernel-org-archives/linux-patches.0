Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17C0306B21;
	Wed, 25 Feb 2026 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002771; cv=none; b=Uiwferv9rcAf2+itK06RLhaFFvscMCoRWaGe5CTzwS5h259YZvPTvyuUm55h+7/oArjPv2ZcgMPmmZxdeY/LSKH8n379XstGg1x28t8Wc0t+5EDHc6omHmXjFpnIcqOBJH9VzcobiPskIsID9stmLbdE09BUYNlj16owEkg1tC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002771; c=relaxed/simple;
	bh=83hmzWWaXbgb7kPpbzMZwCI+pbPYCz9sjLuvv8L9hSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSRZc62mEhn/s9xqTHxiGT7TohN5YzYVzy7kHkhDSClfMNe9LWbrmlsMO2w8kSfBkzmnEAXhu6YB0zTUhmZGHNoAEQ8Y6bn1/zdhaX0de18VRlSZgqArGJEylCgEf7y5Hd9Te+G0mAhl+Hxf/dyOiOE/9r4rGFj1cyJIjDt8524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0detEsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0detEsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB9BC116D0;
	Wed, 25 Feb 2026 06:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002771;
	bh=83hmzWWaXbgb7kPpbzMZwCI+pbPYCz9sjLuvv8L9hSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0detEsU2nCLeamm5BJCMegX2TDdIOADGsGTB/PpKC30xTY4nCMPZIgsTRg++xs20
	 SACDl4qZ5z5B1dNW7AEv6rjHbl0TkmejWva4s1jCQgMdtt083zDk7IuoK/8XGTeZHx
	 Ah25jssipj/mK8ui5USXRMflPygU0tdpfDWtM0JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 607/641] x86/hyperv: Fix error pointer dereference
Date: Tue, 24 Feb 2026 17:25:33 -0800
Message-ID: <20260225012403.222665864@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 705d01c8d78121ee1634bfc602ac4b0ad1438fab ]

The function idle_thread_get() can return an error pointer and is not
checked for it. Add check for error pointer.

Detected by Smatch:
arch/x86/hyperv/hv_vtl.c:126 hv_vtl_bringup_vcpu() error:
'idle' dereferencing possible ERR_PTR()

Fixes: 2b4b90e053a29 ("x86/hyperv: Use per cpu initial stack for vtl context")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_vtl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 042e8712d8dea..8aafccf7a52c7 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -105,7 +105,7 @@ static void hv_vtl_ap_entry(void)
 
 static int hv_vtl_bringup_vcpu(u32 target_vp_index, int cpu, u64 eip_ignored)
 {
-	u64 status;
+	u64 status, rsp, rip;
 	int ret = 0;
 	struct hv_enable_vp_vtl *input;
 	unsigned long irq_flags;
@@ -118,9 +118,11 @@ static int hv_vtl_bringup_vcpu(u32 target_vp_index, int cpu, u64 eip_ignored)
 	struct desc_struct *gdt;
 
 	struct task_struct *idle = idle_thread_get(cpu);
-	u64 rsp = (unsigned long)idle->thread.sp;
+	if (IS_ERR(idle))
+		return PTR_ERR(idle);
 
-	u64 rip = (u64)&hv_vtl_ap_entry;
+	rsp = (unsigned long)idle->thread.sp;
+	rip = (u64)&hv_vtl_ap_entry;
 
 	native_store_gdt(&gdt_ptr);
 	store_idt(&idt_ptr);
-- 
2.51.0



