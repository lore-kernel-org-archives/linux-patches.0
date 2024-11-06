Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B701E22E2;
	Wed,  6 Nov 2024 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898373; cv=none; b=WHtcEufpt3rcq8mXb+7tORQjFjhTTbznpBe65rS4hCOX/iaRnoiDtFXkRYFUwjDYgX5VmQ5KEE4Gs88oi8/y4D9VG/W7QALLcKH51R2UwpaFFmPb5XLoodDUxsV3VjNSyw+MBHfD7rRa8kbTfx2ARgk5hvdJG8psoSSjPrNpdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898373; c=relaxed/simple;
	bh=MGVlwsvwN+iDOxqcCJzWTeuv5YcfeNamuV6Fk4vFPQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d65YRcovHQqGpEvHL6KnmFpDLW4/ngF6WRdZHqR2aFUgg8bQrpa6ze5TNM5ZbDeTUUR2L/IkyeqTrAeKkfVADjzJUDs8LazgR1Hkvte/6Dyc0LHVsBUBwJTy7rkKRTiSN6ETqlKsBwRmUPAKgNFAUdT1gxF/5CYC4Qza+ZpYZ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXLO7p2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXLO7p2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45B6C4CECD;
	Wed,  6 Nov 2024 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898373;
	bh=MGVlwsvwN+iDOxqcCJzWTeuv5YcfeNamuV6Fk4vFPQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXLO7p2lEG4qEMLA8N3fvyLW4E3tWK1djy2mW4LqPm4mPRtfnOnUbkCNxylIgKR0S
	 /ytg5qJfC1IstL/Jy0MEylE+Pa1KIiV1TlN1xDhsJc0CIz7eDzbbPuppjIRisvPpBn
	 wysFd1cHtRuCEiJx34otl09n9EjnafbOgPZJ290M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/462] ALSA: asihpi: Fix potential OOB array access
Date: Wed,  6 Nov 2024 13:01:49 +0100
Message-ID: <20241106120336.857375392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5fb0b98bec304..b9eb597b0278a 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -713,7 +713,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
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



