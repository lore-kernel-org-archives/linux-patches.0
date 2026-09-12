Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDAB41A503;
	Sat, 12 Sep 2026 09:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207137; cv=none; b=KSz6KW+bRT7IPS9Q4tiMO1439/SvG5yIJ1Zq1NsRUJxl8hhYGN7rpFTHGN0fGcOu4WUfYSNm4xuvHeo1FctfYQ3z/0zMyBC9VOm608vml/QYkFC1shytkLBXBdkNfjZrwtQY5E3T51Bd/lGDj6/+dUAhxWrofH61jq0/7QrcoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207137; c=relaxed/simple;
	bh=P1NiagmljIVcFmN31Ia9Kj1cnlOrYP0afvo6ttg2Y1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONH1eZaEf7kHTHDS1fyFah98ayKOgY4BoHv5tC4IFG5BzXv0LVa3U3q/1WDPTIVS7tfFacmPevz/7DLOJOuyH3mzxV5g+vVHd/4t5EefLX5ALNX0XYplgxgcFYjdRxury7G88L0jP0qXOh/OWeoOpOxT5aEeMJVJbOsNllnbwVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5iN0rSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5iN0rSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897781F00893;
	Sat, 12 Sep 2026 09:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207136;
	bh=wgrv8P7QDdN2CN/BFH9rR+diOaLQrXBKTyHngv6WJUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5iN0rSFiixtk2PvmN/nuGf8bUxII+VYJ2CExmxy9AMLGK3ghPIEhJgG2TLUyQa9I
	 XRX1GMPjZNRgCHASqNic5d9CYJsXRWdddFLCT3FO7dzHVKdxxbIcgs6R4BeCz2eP/o
	 sUfvdQ04k9OVMb0o0466JQ11ezgxAkkOHnAzANLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0350/1518] ALSA: hpi: Check transport errors during HPI6000 adapter initialization
Date: Sat, 12 Sep 2026 08:41:59 +0200
Message-ID: <20260912065631.391470331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b08578c93c6a2..57a730be26745 100644
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



