Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E31DEFF0;
	Tue,  8 Oct 2024 12:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390117; cv=none; b=Dd8qAFCl84SA8qHvG+Fm5emQMDLpul2EuYrYzAmFQwPAvjA8G1AY6acEOgLF6UE9OaQFwKb4JzztYaZTl+8UyLTRo5DdekDKlsAbYxDvWDriSvush3JVLv4qMYePR45J+pfMZ1+zeUN/EB1a3GwXgj7RHyTERHQ+Rfd5knjZ85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390117; c=relaxed/simple;
	bh=kVjBTWGm67UYeAwR4Yy1N5XDHIG2cJxtsab77tDx7YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBG6AlMoTRM5ZPeVpVuorecjPjknmkNDhqGh7MtHCIYbkxQK1CVIKqR1Q+c2VuBhgw12cKzUXcm2l5Os9BBsQ0iaNOwx36eMsEyCEbmxDWpxHAe+Zek35bnsB36gwJaEgRdfK+mBvwh7HKjmP0CLV22jgFfHTmrBiV5SQ4B8nrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePLBGMP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePLBGMP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58103C4CEC7;
	Tue,  8 Oct 2024 12:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390116;
	bh=kVjBTWGm67UYeAwR4Yy1N5XDHIG2cJxtsab77tDx7YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePLBGMP3QM1xb0NmCw3+vdjiQufqCTLdnzQZFZsp07qLR/DvIfYPbafXuqIJuZv0p
	 SLHecD3WLZ82/eCKcgmusnhExYAuvGTXnfG1YeTwZEEJW5g5PQzuCVZlKPIXfSlTmx
	 bptBHPFbk3UbDmVAb5c7dIoqZORVIIi2W49e5EYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 154/482] ALSA: asihpi: Fix potential OOB array access
Date: Tue,  8 Oct 2024 14:03:37 +0200
Message-ID: <20241008115654.366670093@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b986c7430a6bb68d523dac7bfc74cbd5b44ef96 ]

ASIHPI driver stores some values in the static array upon a response
from the driver, and its index depends on the firmware.  We shouldn't
trust it blindly.

This patch adds a sanity check of the array index to fit in the array
size.

Link: https://patch.msgid.link/20240808091454.30846-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpimsgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index d0caef2994818..b68e6bfbbfbab 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -708,7 +708,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
 		phr->error = HPI_ERROR_PROCESSING_MESSAGE;
 		return phr->error;
 	}
-	if (hr.error == 0) {
+	if (hr.error == 0 && hr.u.s.adapter_index < HPI_MAX_ADAPTERS) {
 		/* the adapter was created successfully
 		   save the mapping for future use */
 		hpi_entry_points[hr.u.s.adapter_index] = entry_point_func;
-- 
2.43.0



