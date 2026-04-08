Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D053D6694;
	Wed,  8 Apr 2026 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674598; cv=none; b=ZrNBgpXMdVTE6TBJdErX1gDEEdONVVYKgBzxyz4JH99CSHf3YL06NQOXhhvIzceBK6v2fVkdYW+YlTTtZe5GdmzTjZdR2eVVZ7YAYAtS1/GEeBCAHJ5GGN0cGP7YqRbIN7EPDBLhliB+8mPmXOG+UkUNb324xk4osWNdFDuMoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674598; c=relaxed/simple;
	bh=icTIirFZkhQrJqHvJyRVffJPyO1tf+1iIXw+W4dDS6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH+A+Bz/4us/9cq4H/FRoBsZNzXXH58qV0SZbs3ha1d0WhjCe+cWk+fYvZInwsuK/phzMTxCOdyFAvhohgfydZQkMgKj1WKCjMS+A6hL8HikfZ+cwR47SPUqOmmHcAvbQ6xsFDp9UzybPDgfAR4jO4LGRx/pKwM36SNPAOhK2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/b2ci0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/b2ci0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD9CC19421;
	Wed,  8 Apr 2026 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674597;
	bh=icTIirFZkhQrJqHvJyRVffJPyO1tf+1iIXw+W4dDS6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/b2ci0ACUscnIH8qaKdFWeFE9mY6BlYp9G9+sGnT11zqRxNR4O4ZB7ea+OJIcKHw
	 NS+AiN+oSaxkO2ogQa/tCjmzNHKL6y6K/Olk2WZ1vXWEdIUcF4ASn0zbZOFpgaKEwD
	 TT8IrHvKvpQULi0cHZGs90BkLFg0zkRqr+WK2ChY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 159/311] riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set
Date: Wed,  8 Apr 2026 20:02:39 +0200
Message-ID: <20260408175945.342096487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Zishun Yi <vulab@iscas.ac.cn>

[ Upstream commit 3033b2b1e3949274f33a140e2a97571b5a307298 ]

In set_tagged_addr_ctrl(), when PR_TAGGED_ADDR_ENABLE is not set, pmlen
is correctly set to 0, but it forgets to reset pmm. This results in the
CPU pmm state not corresponding to the software pmlen state.

Fix this by resetting pmm along with pmlen.

Fixes: 2e1743085887 ("riscv: Add support for the tagged address ABI")
Signed-off-by: Zishun Yi <vulab@iscas.ac.cn>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260322160022.21908-1-vulab@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/process.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 31a392993cb45..b5188dc74727d 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -324,8 +324,10 @@ long set_tagged_addr_ctrl(struct task_struct *task, unsigned long arg)
 	if (arg & PR_TAGGED_ADDR_ENABLE && (tagged_addr_disabled || !pmlen))
 		return -EINVAL;
 
-	if (!(arg & PR_TAGGED_ADDR_ENABLE))
+	if (!(arg & PR_TAGGED_ADDR_ENABLE)) {
 		pmlen = PMLEN_0;
+		pmm = ENVCFG_PMM_PMLEN_0;
+	}
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
-- 
2.53.0



