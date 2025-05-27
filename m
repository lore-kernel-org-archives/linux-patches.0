Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120A019E7F9;
	Tue, 27 May 2025 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364689; cv=none; b=sJEeJqM3eK9xwzBBg8upI5LhfLij7DA3QQ6LINBqfSCf0SB88E6zjpEpPA76yaOkU+E1L4mORj8Q8sBwyDutmg+laaY7Wf9k/OviyXov4y4L6CBKJ1jqT2JWl47X+84pVJBeNDjgojxNp+6qd9IndxHD2Rx5mHU8sxco+AxxKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364689; c=relaxed/simple;
	bh=pzwzRQGlFw4wOpFHJVG208V8c7yGCoJrwvAHUd2M0Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aaqCyTVYz3aZXDdP2DXLl/Cin+Moxa2zzXGjZt66PbCA8oVaamFUz3vgOc/Y40T8ZLI9WchV96DimvnNaG33eGP8zR6uhFx0fx4b+SeQ2wvp4hk3PZQhzayoIRSeZKiSNv5qHC7fjp3Kg26ZrBKCauMWrU/KDWN+sUDx5cDJ0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTM5877q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTM5877q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77269C4CEE9;
	Tue, 27 May 2025 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364688;
	bh=pzwzRQGlFw4wOpFHJVG208V8c7yGCoJrwvAHUd2M0Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTM5877qCxsOKbk9D0njoVRmvbGLBZTeMSXfh7exfV19SOoWB55LwqSHge2YDiT50
	 17Y4whF8sR87dPmS6oArLE17lIvH1Ce3G137UGlb+Uf6fO0Xe09oGaFsmK+nQcFnc7
	 DKeTIC4le/0mtzm+tXPZcbk890LE1WYbWzHWW08M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/626] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Tue, 27 May 2025 18:20:28 +0200
Message-ID: <20250527162450.513410412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a17441635ff3a..1c0951168f646 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3081,7 +3081,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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



