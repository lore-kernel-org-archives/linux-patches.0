Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F221D5BB;
	Tue,  8 Jul 2025 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993593; cv=none; b=bVPmMQx0Sk9FSX2BH0mfQlyjuXNphpopDiiznLWDCA+rUoBgbkagUqxXoFO6zFX/dXOpPHeufA7NJXdibHqJEWnrayU4rN0OJ7uaR1NM1IGa8MC2z+O89SE2L29nuWJ9qLBR1MfMlTrKZKqZCtgxzkLtIER5P0kVPGYrnTdIlcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993593; c=relaxed/simple;
	bh=Qmk5TkGcJNQdmdFxnUzrEtgJuMlAGTT4kLyYsn2vu0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh9ObSyVxz8Y5vameBz6jQxDlc+uTL8AO+f1E7aw0K+Ev/iGLtl5NerUufCG6+BZADTsjYhwTnJKPo7oiWJ80nsHCRJcrWdR1jsCWvebcKsYkkLOYL+TOW96xHN8b65gq6hszXLvCgWhK3MqC8ICF/LWthdIYK/ED2/IHRB77rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTcTV324; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTcTV324"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392BAC4CEED;
	Tue,  8 Jul 2025 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993592;
	bh=Qmk5TkGcJNQdmdFxnUzrEtgJuMlAGTT4kLyYsn2vu0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTcTV324j6FOlRiLYll2yIYZ1mo8iiJzgTyfxHZReSYoXIzKsnxpPIrp4v47/AoiU
	 B7XWr8d3kIMqDIujXz6ISvckAwTAACE/XGW9aNk/T63/HYCiYb4BL9smwUYxIYuwca
	 tYncsQDCSdJ56TwK7CZ6kYinfIHfutNXSgifHIiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/178] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue,  8 Jul 2025 18:22:44 +0200
Message-ID: <20250708162239.898316811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fe5b391fc56f77cf3c22a9dd4f0ce20db0e3533f ]

On 32-bit ARCH=um, CONFIG_X86_32 is still defined, so it
doesn't indicate building on real X86 machines. There's
no MSR on UML though, so add a check for CONFIG_X86.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20250606090110.15784-2-johannes@sipsolutions.net
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_cs5536.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index b811efd2cc346..73e81e160c91f 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/dmi.h>
 
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86) && defined(CONFIG_X86_32)
 #include <asm/msr.h>
 static int use_msr;
 module_param_named(msr, use_msr, int, 0644);
-- 
2.39.5



