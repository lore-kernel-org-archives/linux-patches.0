Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E964C149E06;
	Tue, 25 Jun 2024 09:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308586; cv=none; b=SiueQy6OxbqKJSNnkZBIqJ5rH96sGEfgwY9JMW9zZzdQMis5ykXNd/3smqqVybTjXDGqm9A7VecBu3bkZswYhL5nd6sgwb7fSzT/5MLknipvgsx7l+zwmAfIcGsqPzOfICIRQ7yuIfOhoya2d3ohaD/85sfouwOGWrYDPWvNBao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308586; c=relaxed/simple;
	bh=NKMvFAAxNw6jm/cDiqaeADEDXRucdM4pzBf2Xy70b7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6rDPvdmYm/hRburX95MJ1nUk7wxRkHepN/Cg+SjLzPEcX4e3FKs4VQcrqtknK9vBCus5fEdvjymE2L9ECi1QsSZiGY1Ojp5Tvn4dcqeyGIx/HPrWNOK5Ui8tQcct+Qz0zLVTM7CrgDMvHuzr3KERdiCTlKRyGZt2AojC5bCSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikbZjn+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikbZjn+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC23C32781;
	Tue, 25 Jun 2024 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308585;
	bh=NKMvFAAxNw6jm/cDiqaeADEDXRucdM4pzBf2Xy70b7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikbZjn+QAhkuVFkLY6OGNrFURgXa+H/8M0ZSJedjWFqJDgz6jhD4V+wja/WBuwMwk
	 e9T8yypNvoV3Mq9+oGWS7DywrJ7tM8fiKt/YbP8jlg9cbjMYw5yXNysH+EgnqROceD
	 pt0fzDQFIGCP5NO0s/HNvBKXRWS9lzxcJGmlxxeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 172/250] firmware: psci: Fix return value from psci_system_suspend()
Date: Tue, 25 Jun 2024 11:32:10 +0200
Message-ID: <20240625085554.654586704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



