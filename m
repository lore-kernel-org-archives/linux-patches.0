Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3C2E6D26;
	Tue,  8 Jul 2025 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994112; cv=none; b=C6hCnsO062631ncMNPXIKkPgpktMZMCBErLRyolBNCbGBIYw/lm02FkrzQ6cwy9ylYqRbPSaXTBE1Gnvl4s9S9nQ5da5epEeMgWIwJbtlpuvkXwdcg9T7ygl/0O41ip0qjKftdts7QpoIoiYzrHmDrzqgeUHNWsYMyVKh+YqyrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994112; c=relaxed/simple;
	bh=k24SWQRlYMxrIoK7TFkIg+CQ/MQheAszvPTB59hQxgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuB4MqYbrtMZz9Rh33uXXCfE+X8Nq7myisDcwCBqNVOrD9FDE6LExUcp99FPGK8YONSrOBkzlwgWnH2QmQPDj+Dbmu7vyJyd1A4CGCKdqBtpUpWGa6Z1c1w/EYw6aPNvws5CSw4+BxSFQXk+Pzn2BiBJRQt0FlgiGK9Ipdfd0ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E13wUXfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E13wUXfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEA5C4CEF5;
	Tue,  8 Jul 2025 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994112;
	bh=k24SWQRlYMxrIoK7TFkIg+CQ/MQheAszvPTB59hQxgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E13wUXfEENhGRJmR/WpzySOS9DdHFjybI/Hw6fRTbx3Ukxk6IeQ4zOeHXU5JW3vKo
	 h8yU1gxjyuKhqpJ12hjMaZpP7Nd2dfZsViUD/effJiUU+zQ9IvLf8T1qBdt9mRUns7
	 Puk2BNMweTIDSfjxeNw5Dooa4CC0omu+T/VEKKSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/160] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue,  8 Jul 2025 18:22:46 +0200
Message-ID: <20250708162234.982717111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 760ac6e65216f..3737d1bf1539d 100644
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



