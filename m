Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1612343B6;
	Mon,  2 Jun 2025 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876755; cv=none; b=JzHvj2OE1bTvOSK9n7Fp4ilBJ0DEFPM8IKrjBj2ILJogJ2xlPwOFFjzlBW/N7IRwu/aWSPPZx/lotgwGhqShkhu+EWVaIi52ln4RtDwXxCRYdu7dAS8rm+cS+EZpeZ16aXz9l14gsAkWblkY7wiRGSmwqLX55gegRr3T9Bh5NPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876755; c=relaxed/simple;
	bh=w+EfHVuSwC7xXKyBs9DzUX1Nhr6C6e3APzIpbNTpLK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ir1VGBGD94BuWVlQIJMt7twJehOykyXWhN5w4INx7UrhLEcmnk1lonKvWwwFPxcXhN7W+R+YqYactzfFfLzbRhNHjVUdgFkFtOJ8L4UNjY0O+/PEcGbeSDSufw4uLrAPe+Gy2ZtPspltw0gdnuF3Xa+bfbRvEm1Po7ZXRsEzAHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hipvXpBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hipvXpBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D86C4CEEE;
	Mon,  2 Jun 2025 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876755;
	bh=w+EfHVuSwC7xXKyBs9DzUX1Nhr6C6e3APzIpbNTpLK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hipvXpBKQ7wbZf9Qj4oOUDoXLlDTZMP2Dg6KtXdN1gN5CHMm3pu8HzEHnP4w6wFH5
	 btWzO7Qa3TTmm2Y2VIpNe+gdXKZJ7W7uIyotdMawic/ILTG4BYyj3hRQVaFUruhiYS
	 i9S20nVEkVzcnLtfEjxqgSQaLeyIOdEIOV8Iz29A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/325] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  2 Jun 2025 15:45:39 +0200
Message-ID: <20250602134322.334398830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f107be344236..284c2cf1ae662 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3074,7 +3074,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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



