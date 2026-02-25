Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3846F1E2834;
	Wed, 25 Feb 2026 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983709; cv=none; b=b/jDBvR2UdDROqFhRUoQTH+95q+4M0leNolLCiZo76MkBZhoprdgO8XFLyAvI2uLhMBV9gpZxtWNH7kegPM01RmxTnUGfGJ+o5GCHpm9SrFOmRJvQQedN56Nb49SgfpdYDrcFmNgiLYBdhBiZb1/1C9uvQq2bBYvixB1gFwZhRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983709; c=relaxed/simple;
	bh=ydrpjouAYetoeQG8NVdTde5je2MftaQYDGMrTnzXuuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB6GtfvF/Cj/OIpy5jWbCM0hK5I3gInVS4UTHOXk9cAZVJNBgJovCPtmTCHyiCrQ9gpcJpJurJ4Mqkw4skjBrJaptUH3UrWe6VGDA6XAmLI2gY7Gtp/oD3K6zVFOTTvLbC0tuaYeiGGtqSdk2FLszBWfWWr6rv6al3guS00uFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dl4tPejB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dl4tPejB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B69C116D0;
	Wed, 25 Feb 2026 01:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983709;
	bh=ydrpjouAYetoeQG8NVdTde5je2MftaQYDGMrTnzXuuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl4tPejBrPW8Fk8/FSrstw/5P3KOjvdhWcbcNUHq8J+clXcLcjUd/6CzMtJWa41m3
	 wkddNUcE6Hy2izegdZxiaEGXMHsw1qtWhHHRYIxK3xL6MrqDFzG5NveIMv4vuPdTUC
	 hl4gzjKy1MTmgvbgRX5E9qroglZ4hRCV6Wq1D4KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 742/781] x86/hyperv: Fix error pointer dereference
Date: Tue, 24 Feb 2026 17:24:11 -0800
Message-ID: <20260225012417.925448582@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c0edaed0efb30..9b6a9bc4ab760 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -110,7 +110,7 @@ static void hv_vtl_ap_entry(void)
 
 static int hv_vtl_bringup_vcpu(u32 target_vp_index, int cpu, u64 eip_ignored)
 {
-	u64 status;
+	u64 status, rsp, rip;
 	int ret = 0;
 	struct hv_enable_vp_vtl *input;
 	unsigned long irq_flags;
@@ -123,9 +123,11 @@ static int hv_vtl_bringup_vcpu(u32 target_vp_index, int cpu, u64 eip_ignored)
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



