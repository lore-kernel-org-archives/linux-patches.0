Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4822576E;
	Mon,  2 Jun 2025 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875460; cv=none; b=IpFpJVpI++ltpuUzxjun0oEfhNdWCszSFiOlFoyQuCxqL14i7xp4rF227XeyBdyP4Qicdc3SYqYjpNk+75h+tmCG3Ue1C+8O5vzMP/zWK98p5tdw1l/HQzkkmv/XmZL0ic45vIXZHROSF+ZmysxGDS5m8Y22FWfGxIMk86bM6bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875460; c=relaxed/simple;
	bh=71NVS0avkHOPcs41uTh6Xex65OwG/noOnhgQ2gSh5ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZ4zxp16pCPGQ7XkWMKhcw+49DXESNZiudnu1xOjlgo15O4l9JMlX2lGb1k1+IupsCEUUZMsG/Qlns3paBD2CNK3cwMomYgmWq1xq/hwID2VcT3qhUjG0W0xDMizTpfvTirX+F2bQ4ZEYqIKKBGStZ1vZYtYS8e8+6AvupOqa9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FswmgaH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FswmgaH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4880C4CEEB;
	Mon,  2 Jun 2025 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875460;
	bh=71NVS0avkHOPcs41uTh6Xex65OwG/noOnhgQ2gSh5ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FswmgaH6IHAFUFaso2ughe4tUa3brNZV6tNmU6yl/jmhCOaSJr6x0utbxd4hdXagz
	 Mv8qAVtNSihB3l0RLumSxM/x5GRdVQguJNm06jO+OthsC9sHh3UnpJCSi3Drk2jqL8
	 0v/4dNs+XSkRHRWFE2K8GSoqF1uGr+d0Pz/ntX4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/270] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  2 Jun 2025 15:47:07 +0200
Message-ID: <20250602134313.039477567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 8db816c6f176321e42254badd5c1a8df8bfcfdb4 ]

In the days when SCSI-2 was emerging, some drives did claim SCSI-2 but did
not correctly implement it. The st driver first tries MODE SELECT with the
page format bit set to set the block descriptor.  If not successful, the
non-page format is tried.

The test only tests the sense code and this triggers also from illegal
parameter in the parameter list. The test is limited to "old" devices and
made more strict to remove false alarms.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-4-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 465fe83b49e98..47e59b74c09d2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3076,7 +3076,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
 			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
-			    !(STp->use_pf & PF_TESTED)) {
+				cmdstatp->sense_hdr.asc == 0x24 &&
+				(STp->device)->scsi_level <= SCSI_2 &&
+				!(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
-- 
2.39.5



