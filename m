Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1404C348C68;
	Thu,  2 Jul 2026 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009882; cv=none; b=rKi3dltegOvxvlcHRPZ5Vwsww0spSrMfyoTNwcOnGd6lcBRpcYoDgt6+wHbpggGeKLWbhM7GdUglQd4Fqd+2D1DvP5hoy95EN7O738pBQ2+QUOlRBJNIF+5GUMkKCrOrQaxa/6Y3+IVLDx+nX0e6tWU8dKSeTUB/joevjW6LBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009882; c=relaxed/simple;
	bh=+MqYkGZ79g3iRAynyUgevGvGCBsAlAbx6D2MwqGys6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auAceOXpLXSjv9Z9G5MzFIdr5LJJK4o4588c412mM3/M/MdzGHvYwrMu1fItkZ82Bl/2v/kO0sZ7PLsISiz8JMxd/fOjjeoyRz80tGDJ3/pgLT0EfgOEDD2dP+i5vX9iIk3YCwIMColIN84PZD3anWurl5N0lKozy+Gm6VzTJwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2VsLwdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2VsLwdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4F11F000E9;
	Thu,  2 Jul 2026 16:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009881;
	bh=tNn5KlHmcY/H2rCpmVqIwiEZPdqXh+XSk03gpi09POc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2VsLwdfC9byEAJcfBrrt7nRHoajMZHrNogU5Yh5Ox/27AxG8vWqQzpzsYmBLbdnN
	 tPnFrw8zJieTCT0qV/V+nZY8kQdqVE+1cTWgxPmXsH/XKGKwo892iXbeW6mCi2Adzb
	 uP8ePb+FJMuEe9xf1Hx7EMS1gvvYlHQ08KV7101w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/129] ARM: allow __do_kernel_fault() to report execution of memory faults
Date: Thu,  2 Jul 2026 18:19:07 +0200
Message-ID: <20260702155112.741239648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2315d40760a787..c94633eb64a1bb 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -172,6 +172,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
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



