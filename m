Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9D02F25EF;
	Wed, 28 Jan 2026 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615448; cv=none; b=FVa5gdQSmrDQVs3s578G1Ui0hepVJHq6vJtBkJmtBxiBM7Ncqjm8c/DGjeidbLB6xP1gsJE9R4h0C2to5/XMGUnujHnGVu2NNauG/BopdgfKwQ9+BvqViG7NJs3Vu0SY0CY7myIgMu4kI0ahhWghR5gV/mdt7hBHcMAvM4ra2B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615448; c=relaxed/simple;
	bh=NPOB0+UHxq2JTEip4Zya0iNl3UrxwL70h6z2RScXxhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0rqZkGnjUCgjkOGuQe0gOUvmPeV8jzA8sPBPVBxxM3CeKMYb/eGJkPRxRIPbrAtQAZSYXCe2ce5ljsWRmBqFuYEUqXXo44cNt+/2D67aOtJXvQDQptUOrOMHhn2e0RQYVo9bb2i6QFfTwTDi0/EPC58mTekvTboFZjCqswy/a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEZvw6pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEZvw6pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48D7C4CEF7;
	Wed, 28 Jan 2026 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615448;
	bh=NPOB0+UHxq2JTEip4Zya0iNl3UrxwL70h6z2RScXxhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEZvw6pYRExNCGXKOU4liEWFSnZ1U2UVNAnOj7okbPpuiQwaBddNDJFZOw4Fn0yqL
	 uKanW4X48AqAsjXO/NHH/fQc8lCfSw0diVZJgtcc/Qb4j7wM1GHF/l8Gg6g3aPM4X2
	 Rm5mtrTqXiJ8bvEOlbgD6Txc8kewXYPD264Bip4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/227] ata: libata-sata: Improve link_power_management_supported sysfs attribute
Date: Wed, 28 Jan 2026 16:20:58 +0100
Message-ID: <20260128145344.819260909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit ce83767ea323baf8509a75eb0c783cd203e14789 ]

The link_power_management_supported sysfs attribute is currently set as
true even for ata ports that lack a .set_lpm() callback, e.g. dummy ports.

This is a bit silly, because while writing to the
link_power_management_policy sysfs attribute will make ata_scsi_lpm_store()
update ap->target_lpm_policy (thus sysfs will reflect the new value) and
call ata_port_schedule_eh() for the port, it is essentially a no-op.

This is because for a port without a .set_lpm() callback, once EH gets to
run, the ata_eh_link_set_lpm() will simply return, since the port does not
provide a .set_lpm() callback.

Thus, make sure that the link_power_management_supported sysfs attribute
is set to false for ports that lack a .set_lpm() callback. This way the
link_power_management_policy sysfs attribute will no longer be writable,
so we will no longer be misleading users to think that their sysfs write
actually does something.

Fixes: 0060beec0bfa ("ata: libata-sata: Add link_power_management_supported sysfs attribute")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b2817a2995d6b..04e1e774645e2 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -909,7 +909,7 @@ static bool ata_scsi_lpm_supported(struct ata_port *ap)
 	struct ata_link *link;
 	struct ata_device *dev;
 
-	if (ap->flags & ATA_FLAG_NO_LPM)
+	if ((ap->flags & ATA_FLAG_NO_LPM) || !ap->ops->set_lpm)
 		return false;
 
 	ata_for_each_link(link, ap, EDGE) {
-- 
2.51.0



