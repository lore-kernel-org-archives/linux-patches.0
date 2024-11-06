Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EA1DF757;
	Wed,  6 Nov 2024 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895281; cv=none; b=cava/4yKCXmCR3cN28tEXme4qhPPSERBqIVdytwL/uHpHMcWl72bDB+8/Zw48YxJWu7vRpscmMFDcMwfsEUKVVcJZusI8qlI4em2IRgr3DUVY3F1v8BvTiVO6eQohgW+YFpLve4ErbGBA7KIV8P2NUOyfSdBA/Zw+0kUnPypr6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895281; c=relaxed/simple;
	bh=h6rYI6GmxTtGFklTyCpb85lJAo7lorm6tSDUjisCeyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V57zsKelC0VoHMjyg/qV/kzeyXz4kkENKATDQk/vNqstzhx8TiYx4oRNL02ERleBb3ZEosvdeDyqzxhQGepel5o+nGDOcSGDynWTTgSvmpy0Qvv5522lszPDrjAm20QX37Fux5btV3dhSXwaB27A4s8EwsmazoFwmzG+f9ePSoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j351SSJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j351SSJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CEFC4CED2;
	Wed,  6 Nov 2024 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895279;
	bh=h6rYI6GmxTtGFklTyCpb85lJAo7lorm6tSDUjisCeyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j351SSJa139GnfmL37YHZTxvA3BFY0+P0Dd+/My695omSItfbyqre0XLp3V9jdeDi
	 b1rCGRVXQgshaVibRrhYgcEOcjEcj1jSH+VXSV/+7akFya8tsRGCXt3Z812GhV7q2p
	 GNFDd7Cads27qbCkEfvLTFZtwedys8WcTBQSILKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/350] ALSA: asihpi: Fix potential OOB array access
Date: Wed,  6 Nov 2024 13:01:31 +0100
Message-ID: <20241106120324.948202297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 736f45337fc70..5be1d910a5d57 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -724,7 +724,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
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



