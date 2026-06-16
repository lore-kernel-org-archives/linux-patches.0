Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E33A9D94;
	Tue, 16 Jun 2026 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622483; cv=none; b=GvtwytYRgldLDILsiECaAwmRr+v8kICctiF7Jcc+OpiMBsPcktWzkSPL3+dV32weFSVsSMNXV53pr+YOhBQ+EsWXYRaoB33fNxtpoRKOdp1Aj2J8gbqDxFhpA1K5Q+BhL/lZuHiC3IfYWA/PfSgP8RnUDUC7j1zhvy32uEaJ9FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622483; c=relaxed/simple;
	bh=yDsx3JZc3i02xfbo9DhJ3ZExdYH0UGvymhdVzrmMvqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKE6nfaN8zdiGs0vHwdp4jaJE9had7e6Cktx/j1XzIE0aTr+o1QU4deE+4iKJg/ao8Q3CVu6JheSnLPtx6n8y4JA53TT24W3qizvyvZEX13ZZc9vnrKnHVRKVl+l0SbWg5WURzPH7umRqj2aD3us/wQxhZT9Yf/Q4uErYh2uUWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZXqJA9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZXqJA9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691431F00A3A;
	Tue, 16 Jun 2026 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622481;
	bh=mXlz9S7p9uwscF8yr4oShGlNwQJgB0TyAB2PJ5n85Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZXqJA9Rxe2PW5vQYdNg2V1NOLSUPtY9GfGrnERCnxBBv7uTSMwQr6hHfpTh4P2wo
	 ks1q0gtWsEBceO3JAF5XXEBLLj7mB6Uf6Ln8i/jYKBG0LwEQ3fgskUczWFULYRcPu0
	 265EhOpfpC3+dZ8BhSg8ZQsqOc9ZSZt8DJjNBm+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/261] ARM: allow __do_kernel_fault() to report execution of memory faults
Date: Tue, 16 Jun 2026 20:27:22 +0530
Message-ID: <20260616145045.204183202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 40b466db1dffb41f0529035c59c5739636d0e5b8 upstream.

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
index 4dca7b75ae5e43..1d052d3c767d96 100644
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



