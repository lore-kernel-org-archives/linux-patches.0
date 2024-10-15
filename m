Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7177E1D8DEA;
	Tue, 15 Oct 2024 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993537; cv=none; b=hHrY8daxwN5oYeOOt3XbxM2I+lHiNKhyMJvGXVkrPQvrfLWEjhMYyXnlGMUUbgl+mVcSVIz4CH95IpljHMQcNPp8NFGcyCARFE4nMK0NgCy291Bgp5eAa4u522onA9kF5/aQwDVThSDDtYDGRezu5/O+U65us8HZthtMbaxhmB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993537; c=relaxed/simple;
	bh=fqpUuNSeIIv/fkQHOdiCLRS5Sm73KKsclOvEck3gY+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6VJr2wafIGOnNj+50O9W2gLetC5ZpQBwQ0RuXO0N7IUPigoJH0fk7CNo6IwUiQMCbQNHChJ1RTlXjlKOoXf3+Uas2BbVm1sUrCt08RFmZNjossJGzokJ1tA+uRHmpIWhxleYbXs50EsGgaW/ldLdVpcs+5XTdfR+0KMzq0j4PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9hnASzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9hnASzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C62C4CECF;
	Tue, 15 Oct 2024 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993537;
	bh=fqpUuNSeIIv/fkQHOdiCLRS5Sm73KKsclOvEck3gY+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9hnASzxG7TdKVIAqJCH5Qr92JhVs3XyGEWpw0Oj8VJJR8lVezedzDh4YTrhBp2XH
	 nEp5gNX8yfXmboDiKohYnWpG4ai2zJ7zDx4PEchkAxmpKV83QjxlJ9Os5B7G1umR+3
	 iGpQdnk4BgY1aButN6iT/o6v4lqgnj/NwsArOrBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/691] ALSA: asihpi: Fix potential OOB array access
Date: Tue, 15 Oct 2024 13:26:29 +0200
Message-ID: <20241015112457.852754120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f7427f8eb6303..761fc62f68f16 100644
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



