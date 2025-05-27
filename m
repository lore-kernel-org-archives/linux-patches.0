Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559251E89C;
	Tue, 27 May 2025 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366717; cv=none; b=KI78qws/9F/1UXjZj+jwomd61luztYH/vgIBKeqxxTQwlRGlz6BVfrwqLKGj24m22UjFyyQ4irlkxY6mw26zORLcRSh7hrzjPLNVHlI9/xvDCgbzD3nFsDJFV9o/0HIzDs6T3L9nqyy3s0XiDeWhFtbraPdhaHDwF2QlI5qpIt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366717; c=relaxed/simple;
	bh=udkipFbp4wMi3iTsF/+TvNTvt6FKCPuZX+ATCVD9WFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2+IRCY8OewJ3iAvCYWoG4ZiedVOudheSZPe+d/TDsLkysztLfHcKwajno1uxMfM5CQGuIHje+2TmESljnUN4G2TT8b3YCN11zbfroLONlESIf6IRk7jBj5X/RSa3uiTALyK7vSad7MmllLQyj4tDeURhpBakUPX+eOaZVsK5UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBEc3Ji8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBEc3Ji8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F81C4CEE9;
	Tue, 27 May 2025 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366717;
	bh=udkipFbp4wMi3iTsF/+TvNTvt6FKCPuZX+ATCVD9WFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBEc3Ji8scc4fpb9ctGRBIIRjQuOHa/JYfSKk7qKhRl4F0JScEuShqodZMF/1koO5
	 h7l1hgpbDRFx2ff9ECyglGfrnEKSShJn8mCfyBG1jnI9ygn0NvCVhyrzPrehLVvV8J
	 GUXJx0y9w7k997Jb59jDxJbGVg3cnj+z7lafvD5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 159/783] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Tue, 27 May 2025 18:19:16 +0200
Message-ID: <20250527162519.645671364@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 344e4da336bb5..2a18ba51427ac 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3084,7 +3084,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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



