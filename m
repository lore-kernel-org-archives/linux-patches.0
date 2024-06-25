Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500BB146592;
	Tue, 25 Jun 2024 10:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309659; cv=none; b=LXdXKIeMnNLgAPwTyq6Jgaau2PKmgLAg370X2j9vFhXC0t8j0W518tVSQazc9REwqlBLobatwyU2WYaSg6H9dYGbgpdE5Bo/p9/kl68tsUUM+hfgoGBfOzOS6VnT+Ru0+tn/rytYmICYePJEL+du/+AjIqvIE+tlYzHrWhEqAPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309659; c=relaxed/simple;
	bh=uaMRtqSqJkIfWcQ9URM55wRy+DCZaPrlELE1qP40cvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1hZUGrhhYw2vV+kFUeaG0W1gaO6DAuB6DI0LypMtloEQhDwEUt+qb2qRjVD+rXw8nq2YuE5+5CnnigdasdFaLNNDmLPhbyzqTEt6xTtsWUEGCB/kj/tuHeY1liUFPiEqXhQdPMYCL+HC5ETRAxF+LMubujZUFP8ir74lxy6EAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iysNxlx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iysNxlx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C947FC32781;
	Tue, 25 Jun 2024 10:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309659;
	bh=uaMRtqSqJkIfWcQ9URM55wRy+DCZaPrlELE1qP40cvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iysNxlx2iv5z1Lj3pJm8meI7AnWF+A7p1qK2MVLJ5kpvIV3n4wPY4Mu9XZ+GaeFGD
	 6KjIh649qegoUZPuzup5kYD0KAiZ4AIpvjVYwJ1jZo3jRz2SV1CVdEXAzyRCuPNmxT
	 kBXVK7JWb8skEdKNzs8wVlOYqiTRsIy9NLLmTA1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/131] firmware: psci: Fix return value from psci_system_suspend()
Date: Tue, 25 Jun 2024 11:34:05 +0200
Message-ID: <20240625085529.358822055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f78249fe2512a..a44ba09e49d9c 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -485,10 +485,12 @@ int psci_cpu_suspend_enter(u32 state)
 
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



