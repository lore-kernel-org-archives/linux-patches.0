Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2408355031;
	Tue,  6 Jan 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721725; cv=none; b=cBvmfJ7COcyhYaUKbeEWo8pojIN7Hc4v79TB/JzOmwric1rhjncll1P4y3b+CYQxmeCbPVfrzJPEFw3lg/3mPR0g5qZeu9EkgJ8rB8/ajFf874OvtC0KM41tfV9Jh0+x5hgg4VFoyf3CkbyiU2ZQDZBq4ra06+lPkvQZ/q+SP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721725; c=relaxed/simple;
	bh=Q4FB2rKKdgfd9JXTp3QKNK1YaPqRgQdPgPKbpZrRpzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVafXpufUZvNm5baD3uzSVc1OWK1YWOG15PF9sfY+qY0aZr1wirShQ7CmFoG/PlNBiEBlGJgwpo0LOWw4+uTidWsv7FRg4m5lbL1AWw6IHYoVUOtvqqTwT72So/evhRH4unfR6x+y11CQ8Lhb7iTGEFb9TAaWOSWl8rh5wci2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIOaMX+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIOaMX+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB1DC116C6;
	Tue,  6 Jan 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721724;
	bh=Q4FB2rKKdgfd9JXTp3QKNK1YaPqRgQdPgPKbpZrRpzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIOaMX+heojKAeKTcjWeMUOoIP9I3zOvUUo2Bfsrvgq39ha42W6crkTQvaebcWr6J
	 NEBB92XoJihq/FKH66uj/RF54U7865v3oBBa7McowDr6eqj16QrkgbWZJJ4nmKBTvW
	 dCTHfxepr5uoScuwTYugpiDS2dN5Z2oxNRox5Vp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Vazquez <brianvv@google.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/312] idpf: reduce mbx_task schedule delay to 300us
Date: Tue,  6 Jan 2026 18:01:35 +0100
Message-ID: <20260106170548.621982886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit b3d6bbae1d6d5638a4ab702ab195476787cde857 ]

During the IDPF init phase, the mailbox runs in poll mode until it is
configured to properly handle interrupts. The previous delay of 300ms is
excessively long for the mailbox polling mechanism, which causes a slow
initialization of ~2s:

echo 0000:06:12.4 > /sys/bus/pci/drivers/idpf/bind

[   52.444239] idpf 0000:06:12.4: enabling device (0000 -> 0002)
[   52.485005] idpf 0000:06:12.4: Device HW Reset initiated
[   54.177181] idpf 0000:06:12.4: PTP init failed, err=-EOPNOTSUPP
[   54.206177] idpf 0000:06:12.4: Minimum RX descriptor support not provided, using the default
[   54.206182] idpf 0000:06:12.4: Minimum TX descriptor support not provided, using the default

Changing the delay to 300us avoids the delays during the initial mailbox
transactions, making the init phase much faster:

[   83.342590] idpf 0000:06:12.4: enabling device (0000 -> 0002)
[   83.384402] idpf 0000:06:12.4: Device HW Reset initiated
[   83.518323] idpf 0000:06:12.4: PTP init failed, err=-EOPNOTSUPP
[   83.547430] idpf 0000:06:12.4: Minimum RX descriptor support not provided, using the default
[   83.547435] idpf 0000:06:12.4: Minimum TX descriptor support not provided, using the default

Fixes: 4930fbf419a7 ("idpf: add core init and interrupt request")
Signed-off-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 8a941f0fb048..aaafe40f5eaf 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1271,7 +1271,7 @@ void idpf_mbx_task(struct work_struct *work)
 		idpf_mb_irq_enable(adapter);
 	else
 		queue_delayed_work(adapter->mbx_wq, &adapter->mbx_task,
-				   msecs_to_jiffies(300));
+				   usecs_to_jiffies(300));
 
 	idpf_recv_mb_msg(adapter);
 }
-- 
2.51.0



