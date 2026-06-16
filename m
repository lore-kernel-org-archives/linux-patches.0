Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD663D75A4;
	Tue, 16 Jun 2026 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634462; cv=none; b=XDlbX6h0GMxMW7D/wo8JI0zSAr6bULKK0Qjgh3L/eHzBCe1eCUQ39N0+PV4fZUN8QSwlEPuYg++JJ7XWB+4G6o2TyUgFm3Z/K2hE5HaeHXLtyfUOLm1/b9Cm96w9NItp/G6mj7ZODpjE80o7GcstmCPWIgOuzvAABQVEgiuIQOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634462; c=relaxed/simple;
	bh=rW6ZsEbObG08MnFjTMlfZQkyYw+4juj1iGLre0RBNxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq7fmNnXF95TzhMaQ+4KnWGR7hSi8oOXbBxo9pyxeLHpbsT9kIBjns6wDUR0juZXb7PRr2VaRb6otDzaFMOoVzQjdk5XsO7nss2RzfjixI2kdn48Q6xiEYPQ8ESsjUsAAuZdw655ycgUkl1sGj2dtjr+bGv/1LfXFElYCEmpC7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLetqoX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLetqoX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3A51F000E9;
	Tue, 16 Jun 2026 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634461;
	bh=3q8CiZoAiZdEK0q9ZTkqOyGe0bcJ5/DX/ynLi3pxawc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLetqoX9DVDTcNMb92Ej1TNmccid1m2GSQznGvCu7peO6KfprBULV4vjnzunnoBaB
	 XeGnuu8K3daZEonlzDuj3BgOPOK8Dvks+bRX8sjER7KsWheaKpA1Mpbk9HgJ6X57Di
	 oXcu1TBA2XdcTyKvYoiT9J/brlJRbepZYEX6LWb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/411] nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set
Date: Tue, 16 Jun 2026 20:28:28 +0530
Message-ID: <20260616145115.447433458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Beckett <bob.beckett@collabora.com>

[ Upstream commit 40f0496b617b431f8d2dd94d7f785c1121f8a68a ]

The NVM Command Set Identify Controller data may report a non-zero
Write Zeroes Size Limit (wzsl). When present, nvme_init_non_mdts_limits()
unconditionally overrides max_zeroes_sectors from wzsl, even if
NVME_QUIRK_DISABLE_WRITE_ZEROES previously set it to zero.

This effectively re-enables write zeroes for devices that need it
disabled, defeating the quirk. Several Kingston OM* drives rely on
this quirk to avoid firmware issues with write zeroes commands.

Check for the quirk before applying the wzsl override.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Cc: stable@vger.kernel.org
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Assisted-by: claude-opus-4-6-v1
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2952,7 +2952,7 @@ static int nvme_init_non_mdts_limits(str
 	if (id->dmrl)
 		ctrl->max_discard_segments = id->dmrl;
 	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
-	if (id->wzsl)
+	if (id->wzsl && !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
 free_data:


