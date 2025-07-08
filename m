Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456711DF74F;
	Tue,  8 Jul 2025 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992423; cv=none; b=D52n4DM8AP2wo1UZcd6CqZYhoaxZ/Tq3MO63HbZjDgMGhWUA7mmLMY+65dfcosJYXmUmH1RjisZYA9vtvpoCslz3LQntQNK0x5/6Wk1yvWy5BYDrJSuKx5WuvNSp1GyCeuueOW28uJpc4VT0k6D+bzdr0bjp1sOby10QpghKVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992423; c=relaxed/simple;
	bh=pZBetigXLXLVasklMJV/ppcHT4fnp70lv5/z7zNEimk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwJJjOPpgQDZMNzlp4MYcnSDps8tq5Jc+X38Qc7+pbeO9PJ+644hzfTRu2ilyU91FtZOhiSeKdIdMZXzc9i3zOStPm3oJFW1SW8v63cGR7qF2IU7YUt8f8sfdYVBE7kEm7vox6WKsgEUQjfhuz7yTHi/iou8uKwzLfCPCSD5p6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbLh0o9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbLh0o9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1586C4CEED;
	Tue,  8 Jul 2025 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992423;
	bh=pZBetigXLXLVasklMJV/ppcHT4fnp70lv5/z7zNEimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbLh0o9mpKX0TZfZ6QjuOna8c32UdVkh/ZJkNxV8QcqUiNKRqNPfGZnzkUwPaj6Vs
	 So27Pl7V0NC2jL66WrQHWuOUmE9xbLSetiSMV+nCIis1aB4xpkrKnAWtjHaCz5wKuv
	 ylw1b/zI6d3XYmyJTqvfNKu0HTK+9gz9cUbyPJhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/132] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue,  8 Jul 2025 18:23:18 +0200
Message-ID: <20250708162233.174664669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



