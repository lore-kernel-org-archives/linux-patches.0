Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3028213B295;
	Tue, 27 Feb 2024 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041000; cv=none; b=lesbG5EeE1B59ZnVGrlMruRd2bb/7K5ZeoqE+0kb7pEUEWLZpABTlBfpHdvCpXc3oWUkKM1HjGrWmLiVk4X9u/RG5Cq1gea1eK++ySnmrw5rBECFLOio7vf8Yy7PgqlFyQBuAIgMJDZxmq/EtMdeVrymGSWeOGQyXEmJErv7O24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041000; c=relaxed/simple;
	bh=4u2BGRFNgXQHTh3O7FiATlBYyE42X8RQcAcKJgdwY0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+jljfaf7ez0AwpP7MTTM9GuJxCLYY2dq3wnwkLwVEqMbugfxSdOkaFzWCh1xIQ5hW+ugIrs9CNl8B0s2tNcXFrGIaGWdmGxn+2PlHxeNWmyUtZZ2adNKqVMqCD91qVFzdRGoZtw2hZ5w4jWswIavw+NCR59mKxxkGlYig84bCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7mmwGlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7mmwGlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEA7C433F1;
	Tue, 27 Feb 2024 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040999;
	bh=4u2BGRFNgXQHTh3O7FiATlBYyE42X8RQcAcKJgdwY0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7mmwGlx63Kt3bbHkaQyOAJLp5uCdGZWaNAPrRZerD/b9xBbXHR62wHqpNH1CJ5Z8
	 vD90As7sBgzzvMNEKtNuoNI9ZXehdP0Z1iFkLmIbdf53I1IVglmXezdVAQBmBSQEKh
	 R3JX0RGMs8k1rr65TNgUITTKBS3lGjeWXoc+WGuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.7 155/334] ata: libata-core: Do not try to set sleeping devices to standby
Date: Tue, 27 Feb 2024 14:20:13 +0100
Message-ID: <20240227131635.457581337@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 4b085736e44dbbe69b5eea1a8a294f404678a1f4 upstream.

In ata ata_dev_power_set_standby(), check that the target device is not
sleeping. If it is, there is no need to do anything.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2017,6 +2017,10 @@ void ata_dev_power_set_standby(struct at
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* If the device is already sleeping, do nothing. */
+	if (dev->flags & ATA_DFLAG_SLEEPING)
+		return;
+
 	/*
 	 * Some odd clown BIOSes issue spindown on power off (ACPI S4 or S5)
 	 * causing some drives to spin up and down again. For these, do nothing


