Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739431FBEA6;
	Sat, 12 Sep 2026 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242627; cv=none; b=uhMsbE4mHuj73XuALzTOyu0WNGlWDO1UV0EBSwMyUIGX7MQm2CMTiJabrt4IlOCEFFGvHwy/4rtaXMCvTzkUi0ZwvL8gV+Ijoiutw02cBWjairACJ0vs/oBS+JSd+dcWqfbEsBrQFHnEkMl091ZqyMMeZLk/JGRlsVln22h6l3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242627; c=relaxed/simple;
	bh=xv1TscRW+n+ZRCQ5WPb0fm0KVfnAAK4k2URj/8VEsV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUc1yFjWt4ZwOmPQ8XH30itsD0r/1Me9Q97rbXwaZWT0qcsNM/phxXCsGQXbl3uXss48l7pxBXxRxKLlo8rfIsizbtHEZnhBFt57KPT1LR9ueKeka9PpYFQKffNHaOyKahU55zN+nwNcKUTYO3SNUm2jyyk1/18HwQwdZR9/TfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cF2QnWNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cF2QnWNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA33B1F000FF;
	Sat, 12 Sep 2026 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242626;
	bh=s3CnJ2CpAAjyn7iM64O87cIRxIEGGS7CPHOxgMKJ+pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cF2QnWNzuh5mTCkMYUTT8MiXz8n4NOLMm/XsmBJj/a7UiRsQpZxjsfJvz/ZElpcn4
	 o3QWhnzmXIDxwbFa/1GrLbuXgVHk/0A8xUWp2E06HAeQdXrKDnm7hMaNlzZ0IPW2SH
	 NCXT3HUF1zbIBORkkIorsECzmkc2LUs+pTPLw5lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/798] ALSA: hpi: Check transport errors during HPI6000 adapter initialization
Date: Sat, 12 Sep 2026 09:00:55 +0200
Message-ID: <20260912065526.932538685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit cc15c329663e3ef1aeed0b68e49a5d5ce4ae0d5c ]

create_adapter_obj() retrieves adapter information by calling
hpi6000_message_response_sequence(). This function reports transport-level
errors through its return value and DSP-reported errors via hr0.error.

The current code only checks hr0.error, causing transport-level errors to
be ignored. As a result, adapter initialization may continue with an
invalid response.

Check the return value of hpi6000_message_response_sequence() before
examining hr0.error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 719f82d3987a ("ALSA: Add support of AudioScience ASI boards")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Link: https://patch.msgid.link/20260708141147.18253-1-evg28bur@yandex.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpi6000.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/asihpi/hpi6000.c b/sound/pci/asihpi/hpi6000.c
index aa4d063531260..0d43c06b3a3c2 100644
--- a/sound/pci/asihpi/hpi6000.c
+++ b/sound/pci/asihpi/hpi6000.c
@@ -537,6 +537,11 @@ static short create_adapter_obj(struct hpi_adapter_obj *pao,
 		hr1.size = sizeof(hr1);
 
 		error = hpi6000_message_response_sequence(pao, 0, &hm, &hr0);
+		if (error) {
+			HPI_DEBUG_LOG(ERROR, "message transport error %d\n",
+						  error);
+			return error;
+		}
 		if (hr0.error) {
 			HPI_DEBUG_LOG(DEBUG, "message error %d\n", hr0.error);
 			return hr0.error;
-- 
2.53.0



