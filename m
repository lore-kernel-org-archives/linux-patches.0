Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31853D75C7;
	Wed, 20 May 2026 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300241; cv=none; b=cAqky3BoxHr24o982VCf7AOBSBNTP/qCymaeHB9sSGXSg2gGaloTJVMp6DxXYrykpkgkIQEEqn5uyqVRGrAbq5jwjzoLFjXUgCTwMCoRYc1yIdLdAgneN+kBOSi1IW+bMFprcjeJ7eSRWkPchseoHP1140FDclt1AXcSXPN3urs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300241; c=relaxed/simple;
	bh=anttVukNa+544Ybdte9Ys/T2egl14roGaQTUpIIXkAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDBxtNcCZVjkYkd32CWrpqG1Fk0Q7nYGW+VzTOaSQwOxXu6KaVhCcDXeuOPjNaSfMfveRV3LiKtXLZRgpTcr2DufJRSRs9yur3aGmR+7RN/0RoJb/Sl/YFY222HTSWXkYX9GDa1biHCgf5baLBZgydIi4ctrKkZtkylSi5avEOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miy0PZRM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miy0PZRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A9F1F000E9;
	Wed, 20 May 2026 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300240;
	bh=9KcNDWgMAOXjewK2vjgpD+GZ96Rp822LFbr3ouLw6hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miy0PZRM0PgofU5/1BbamRptW9ZWODLUiaTxFTaidZuZbEzyokFsFk8OUpnJIB2uN
	 AmHjf71bw9W0Mt/bL9U3SrJvXF3VxKI+h5LJLwtYavuQchmY8p2QdEyYlufp+pEMJ/
	 ce2J2jRxEKP/+QsYq0qew8OOQ4owjsUfEoj5vL2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/666] net: ipa: Fix decoding EV_PER_EE for IPA v5.0+
Date: Wed, 20 May 2026 18:15:11 +0200
Message-ID: <20260520162113.390892034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 1335b903cf2e8aeaca87fd665683384c731ec941 ]

Initially 'reg' and 'val' are assigned from HW_PARAM_2.

But since IPA v5.0+ takes EV_PER_EE from HW_PARAM_4 (instead of
NUM_EV_PER_EE from HW_PARAM_2), we not only need to re-assign 'reg' but
also read the register value of that register into 'val' so that
reg_decode() works on the correct value.

Fixes: f651334e1ef5 ("net: ipa: add HW_PARAM_4 GSI register")
Link: https://sashiko.dev/#/patchset/20260403-milos-ipa-v1-0-01e9e4e03d3e%40fairphone.com?part=2
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-ipa-fixes-v1-2-a817c30678ac@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4c3227e77898c..624649484d627 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -2044,6 +2044,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 		count = reg_decode(reg, NUM_EV_PER_EE, val);
 	} else {
 		reg = gsi_reg(gsi, HW_PARAM_4);
+		val = ioread32(gsi->virt + reg_offset(reg));
 		count = reg_decode(reg, EV_PER_EE, val);
 	}
 	if (!count) {
-- 
2.53.0



