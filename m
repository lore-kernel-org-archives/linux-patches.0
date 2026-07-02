Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC23AC0FF;
	Thu,  2 Jul 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010723; cv=none; b=o+7PxNHJ17JsGPk583/ZTdJ1MVxp5y0BvJ4UJmTEJZv2NYHHjis8tiessrNO6Fy2tVSmEnMyShRt9ZAm5fhmh/6jm+h0E+WghkOkdR2nKDKDs4S4LTS/Io7FFuwPCsMvnaso4r7ezL8VM9+d3w8x2EyL9qJQpD5dZbJ5DO+vYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010723; c=relaxed/simple;
	bh=YE21Sm2C1XwYBvSTXHLgC0kq/0Do/ZsQZb49ViU4csM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAMv/maLhb6YVA2f91cwPLGlrBa6aI/k65K6qjJMaeTcvTkrP+b8eE/ELnJ0rXwOqQyPC6FBE85slGgA3cDjvH9pnd3swpfPAD5Xyh0Bmt7307BxVPfzArhOdNXW+V1dG5m29lmWYAkNAOhirzSMnUB0/opaL4n1147AaJCfrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oa2TgM0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oa2TgM0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6329D1F000E9;
	Thu,  2 Jul 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010721;
	bh=5+WvdvSH1toIpsi1mFtcZo4MFY1bxCNXLmHO+5wWUbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oa2TgM0JQnhWbejJ/Zr1b0XVk2l3JaPRqpuiHOMJhTi0+bJP0RQMGuvCw5hIOS3Ny
	 vrJ1txPwD2T3AW3K5z/0LIuDoZS7eW+bjDXV9n6eKiF7OUcYIsHwza7AAvBWEFVe9E
	 vo/p8hMz1la/bHBJOhUnJ+uWdQr7Li526AlrgRwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/175] ARM: allow __do_kernel_fault() to report execution of memory faults
Date: Thu,  2 Jul 2026 18:18:34 +0200
Message-ID: <20260702155116.052853824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 40b466db1dffb41f0529035c59c5739636d0e5b8 upstream

Allow __do_kernel_fault() to detect the execution of memory, so we can
provide the same fault message as do_page_fault() would do. This is
required when we split the kernel address fault handling from the
main do_page_fault() code path.

Reviewed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Tested-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 879730a47c4a20..4c0ee81befb1ed 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -176,6 +176,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	 */
 	if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
+	} else if (is_permission_fault(fsr) && fsr & FSR_LNX_PF) {
+		msg = "execution of memory";
 	} else {
 		if (is_translation_fault(fsr) &&
 		    kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
-- 
2.53.0



