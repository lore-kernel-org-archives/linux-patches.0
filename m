Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E32A24B34;
	Tue, 25 Jun 2024 09:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309183; cv=none; b=PfZ0pyCFg+A47aNRabJn9xwSHAn4Sr95y6K+lU8q+ZRZ+ZFvrTryPxvklRFwJDCAfGQzJMgckeilaknBrbvkJdW6sAae8tgb0JZj5XOCHYIJ5ke2kzLcctG6A5Qu4eMyA1wag0JGxIyJsJ0r/c2bDGuwGn+SVCAwhdT797RkK6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309183; c=relaxed/simple;
	bh=5Sax9t4hcK+KLob21gcw0I4OISzKzg6Uk2DRaCWtMgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3bscXLDLGt17cR9GI7EUndu/bCDWcGJH2nODR0ELi2V2VGZTb6Z5W/HxpkJonG6fL2PFhQ2DbVUc0PTKd6UZyERA3FWbZGpB8BZOeC5/MoyCzT6B6dlsEOvmlt8zGbLc4aa4gOY091aLaBa2qSSRAwBRgKao4yb7NCWDY3PQSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW1hsLNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW1hsLNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB2C32781;
	Tue, 25 Jun 2024 09:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309183;
	bh=5Sax9t4hcK+KLob21gcw0I4OISzKzg6Uk2DRaCWtMgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW1hsLNEVrVVWEqVhqZencrcjEzcbIqm8VXvpnHneMjbmyFpJh/U1RErqJJOd74hS
	 rQRo5YElzpwQpcrBYQMmrcYwFjrOKjt41GPnGR2L5BcoczcKw/Mj+LIFHQVQ1WSM5o
	 ag7wPWawWvLkCLG+0wJVRujviYj3G3f83mZ8gC4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/192] firmware: psci: Fix return value from psci_system_suspend()
Date: Tue, 25 Jun 2024 11:33:16 +0200
Message-ID: <20240625085541.927510467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit e7c3696d4692e8046d25f6e63f983e934e12f2c5 ]

Currently we return the value from invoke_psci_fn() directly as return
value from psci_system_suspend(). It is wrong to send the PSCI interface
return value directly. psci_to_linux_errno() provide the mapping from
PSCI return value to the one that can be returned to the callers within
the kernel.

Use psci_to_linux_errno() to convert and return the correct value from
psci_system_suspend().

Fixes: faf7ec4a92c0 ("drivers: firmware: psci: add system suspend support")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20240515095528.1949992-1-sudeep.holla@arm.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci/psci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index d9629ff878619..2328ca58bba61 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -497,10 +497,12 @@ int psci_cpu_suspend_enter(u32 state)
 
 static int psci_system_suspend(unsigned long unused)
 {
+	int err;
 	phys_addr_t pa_cpu_resume = __pa_symbol(cpu_resume);
 
-	return invoke_psci_fn(PSCI_FN_NATIVE(1_0, SYSTEM_SUSPEND),
+	err = invoke_psci_fn(PSCI_FN_NATIVE(1_0, SYSTEM_SUSPEND),
 			      pa_cpu_resume, 0, 0);
+	return psci_to_linux_errno(err);
 }
 
 static int psci_system_suspend_enter(suspend_state_t state)
-- 
2.43.0



