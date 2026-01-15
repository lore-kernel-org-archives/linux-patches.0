Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BED3DA7CB;
	Thu, 15 Jan 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499411; cv=none; b=POADjZh5BXW7uGZdgdW8xR9+5qejpbhqjeIZe2W78Kyf11SNiL7U+Mdt+8d87aenlxPbye5TUzckLUTrOjeYL+hdQkMnODFaTq4YTWA2HzlxNvD5iZLeRo+enokdj08evA+5I72ApCUZwWH701hk5NDJL7k74RbzZu/9D6rwip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499411; c=relaxed/simple;
	bh=JKw6HIQ7vhNfp4oxtzxsdfHJGeuCqauurcpL4jp5D1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niAQ48m5Zl1F1+tbbGF7oVS1aMHAscZ0oJsSFSfXV9j++L5ZX12vWM1pcAeAIZzuPoewXdmVc9bvDH8b/fbnvM0t3voSpGFwr4RdzH6W6UMACJX1IeGDT1J3ZMcN9janQAwObsFqncjm26sUKFjOrQ9gEY5abNvTQaMI2dm46GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgetPDB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgetPDB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A168C16AAE;
	Thu, 15 Jan 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499410;
	bh=JKw6HIQ7vhNfp4oxtzxsdfHJGeuCqauurcpL4jp5D1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgetPDB2Tq43GkUuojeaSkzZt8NaQVygB27SEL4tARreRr/qXzn/oMSC4a5RSH42+
	 6/g4/D/oo8u1L6uOOmVoTzLSRJjOifcYXFdaXkQ6Rv6FMXj0RL3Fh6rXfbpxOvwnlP
	 j6nbmZBtFQGnCBLZNYf/aoBz4WR+at6G3WdsDiF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/451] usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.
Date: Thu, 15 Jan 2026 17:46:58 +0100
Message-ID: <20260115164238.749718096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 955a48a5353f4fe009704a9a4272a3adf627cd35 ]

The optical drive of EL-R12 has the same vid and pid as INIC-3069,
as follows:
T:  Bus=02 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=13fd ProdID=3940 Rev= 3.10
S:  Manufacturer=HL-DT-ST
S:  Product= DVD+-RW GT80N
S:  SerialNumber=423349524E4E38303338323439202020
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=144mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=02 Prot=50 Driver=usb-storage
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

This will result in the optical drive device also adding
the quirks of US_FL_NO_ATA_1X. When performing an erase operation,
it will fail, and the reason for the failure is as follows:
[  388.967742] sr 5:0:0:0: [sr0] tag#0 Send: scmd 0x00000000d20c33a7
[  388.967742] sr 5:0:0:0: [sr0] tag#0 CDB: ATA command pass through(12)/Blank a1 11 00 00 00 00 00 00 00 00 00 00
[  388.967773] sr 5:0:0:0: [sr0] tag#0 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
[  388.967773] sr 5:0:0:0: [sr0] tag#0 CDB: ATA command pass through(12)/Blank a1 11 00 00 00 00 00 00 00 00 00 00
[  388.967803] sr 5:0:0:0: [sr0] tag#0 Sense Key : Illegal Request [current]
[  388.967803] sr 5:0:0:0: [sr0] tag#0 Add. Sense: Invalid field in cdb
[  388.967803] sr 5:0:0:0: [sr0] tag#0 scsi host busy 1 failed 0
[  388.967803] sr 5:0:0:0: Notifying upper driver of completion (result 8100002)
[  388.967834] sr 5:0:0:0: [sr0] tag#0 0 sectors total, 0 bytes done.

For the EL-R12 standard optical drive, all operational commands
and usage scenarios were tested without adding the IGNORE_RESIDUE quirks,
and no issues were encountered. It can be reasonably concluded
that removing the IGNORE_RESIDUE quirks has no impact.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251121064020.29332-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/unusual_uas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 1477e31d7763..b695f5ba9a40 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x0160,
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-- 
2.51.0



