Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EBB352067;
	Tue, 26 Aug 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217638; cv=none; b=KW5xWirvFCXMAFOlCQVobSV74n9zgbh48pAhWa/EI+y2lb8wu2M31KmnOrwAA8GVQjfaXl4JOJymeiK07iOIK1UvT5hX7XVkMBY3aXmmFgmfiXVMcHvJ1yN/r4PW2CAN1oWN46CzhX8MJ5rTOJta/aOr+I6zRobWrp8f5IMgxow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217638; c=relaxed/simple;
	bh=64ODnQjZBbRtoG8DlDXUpFJsIvwVLkRH7eI1Aza1r/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4dU8Mqzl8ZROvVCw+vQ0hd3FDI/O80uNi/rdCgvW6C5aJAR5ItlWpMDLtrvmItxlQudV44Bq0kkL1nDrW6wLAPPPyey7xIBfNoMeReXrqk79owX+YYA3RhDHqVhrRQima+daz2eshWW2Unb0Jz98tDb5avuKgYwtNS6hyc58HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj7KNJo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj7KNJo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A05C113CF;
	Tue, 26 Aug 2025 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217637;
	bh=64ODnQjZBbRtoG8DlDXUpFJsIvwVLkRH7eI1Aza1r/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kj7KNJo85eUH/Eug8UdDqIHJHcxsg5w9UaDzBJf/nu8/n4vROSgBKC6TUlZGLix2c
	 VXsAQ0qNcujSm4bWbs40Dc5n3hRwJIjuq9knxb0kKU2KgDKP/yBAVjFJdb26qZluqE
	 QGA7LfvCmAWZ2UhTLhCOePrdvOyA6RzqtH2K3VLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/523] ata: libata-sata: Disallow changing LPM state if not supported
Date: Tue, 26 Aug 2025 13:07:09 +0200
Message-ID: <20250826110929.862581334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 413e800cadbf67550d76c77c230b2ecd96bce83a ]

Modify ata_scsi_lpm_store() to return an error if a user attempts to set
a link power management policy for a port that does not support LPM,
that is, ports flagged with ATA_FLAG_NO_LPM.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250701125321.69496-6-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 45656067c547..d5c97dba2dd4 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -815,6 +815,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (ap->flags & ATA_FLAG_NO_LPM) {
+		count = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, &ap->link, ENABLED) {
 			if (dev->horkage & ATA_HORKAGE_NOLPM) {
-- 
2.39.5



