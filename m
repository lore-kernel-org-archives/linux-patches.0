Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01B62F617C;
	Sat, 12 Sep 2026 18:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238639; cv=none; b=LCIDnJxxCGqHB/80W9x1VnyLtrDezPv+nJQrvL+t5zISmVw44Xf5Vr736DC+7YQZwDZRtf2/bTbE+22f9OFY9oZ5NdAg6kuCqLT7tcF88znYc5JXN/0muSEvZVAFq7UHib8fsdJTf3PfaeR6F7DYfRaRrrWwGRQAAnQxk4sKriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238639; c=relaxed/simple;
	bh=0ItSzfPAoGJBRJIO3GPZT/xLhVrU75PoA4lrBt82Ze8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVbVn6JGrvzaJB/WSs+GlsbjVas2rQxdDr0yob1eWIcEnxs6ASGEFydwafOwRsK/MiRiy/lFpq2baxI9jvISpHpR2sSqOGta4SlH+JjPjfzZ1bS0O+2chTsvZJQXXtRpbVFsh75cEORHMCWP1i8jPiwCtefRHEeEhUGtP1gy13Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMFsBNDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMFsBNDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF6D1F000FF;
	Sat, 12 Sep 2026 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238638;
	bh=yYgKm9fMRZ/1CecpEUxcS1cz/qc5ki/wIAbReeRLLnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMFsBNDXhL5bqh9k2PcDAPBVVusmG7RcohW6LecABFJdN8Dzo7n5cwhS2aVVM8reQ
	 OfVMgKQkcQpcdngudV0HuVDQWtG4E8klSyuOWkGQSzh59KLeWezuapJT4ra/eKxdYr
	 Q4VEfAMmxMORWWF5oTjVvPmjnW4/2vCoAFSMySVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/935] ALSA: hpi: Check transport errors during HPI6000 adapter initialization
Date: Sat, 12 Sep 2026 08:58:54 +0200
Message-ID: <20260912065538.375124179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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



