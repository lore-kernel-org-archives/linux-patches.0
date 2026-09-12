Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08226343893;
	Sat, 12 Sep 2026 07:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198337; cv=none; b=cwj9heIWJTpJ9i/lN8l5SP/jZ5MrYcFUNICJ++tV8LCMJlWY/rGnBXGTtNUn5dJRDveXBEfwlz3/uNcIluzVOMbbvYCsyjis53nlXcgP94ecU9OCKtYh0lYlMBKTmHzvzahG7y3pPTYSeQrq9dodBH+o9K3sdeojkUoP+ePpB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198337; c=relaxed/simple;
	bh=P6Ln/iAyXAGZW4X2NGGJn7rcJuZq6gjEvP5MDaKQ5Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMJZu9o6M+/+7j9pdzoqr+uvYgTe6CFUipHmiY0X2Vsva8Iqm/SsJRfof/2z7S6ZpGHRgkTiEn9AF5mV1eV4hhrTnKsEI+44Ky2XCiCr5gJqbtESqQFnigeaFbuJUX4KLojw3ITAKW+0zt/gnTtW8lRIrLbksb5P/nXTaLTnxCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uUqi2fE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uUqi2fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06401F000FF;
	Sat, 12 Sep 2026 07:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198335;
	bh=AcUJtdFL8vf32YdwNELiTu/47vAv3Qxys60dcyg7J7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uUqi2fEBCYnrD/dIPavgqDjKe0FP1XbqvFrCDPVledli6Qq3fWO5PAJBMTbCPp5I
	 Chlw3w/VT2IcclgtRR1GlX5yahRV3RzbHJGw2znv/vcvTWx8b5P7MEnO8tW6jUpYi5
	 4A5Lzehwn2t754clJTmPXErijKZC9f0gJEw4ll+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0357/1815] ALSA: hpi: Check transport errors during HPI6000 adapter initialization
Date: Sat, 12 Sep 2026 08:35:07 +0200
Message-ID: <20260912065657.288822452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c8d1518ee3e74..fd7fe9dba0b80 100644
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



