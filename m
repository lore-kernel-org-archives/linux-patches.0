Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675612BE05F;
	Sat, 30 May 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157615; cv=none; b=BHhaoAnS9Q18lnww6veOlaHk2x7GKX3ziBQzNE1n3holU1Qth/SsDpVeItdYsDFbyH0FXs++3unEG/Yn4CabJ118WMxRUbIRUmW2FPAoJKOSr0Q7UYqGoSjwgmaju+AsP7eZv6kQnREZX5gmd/iYR+Y8Mqus4UmMcbT4gdpXNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157615; c=relaxed/simple;
	bh=eA5/1cv4KeMeYkFS/qq15ARibY1HAR31UIfxfRKgKyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJEBX1UDiddxT5q71ozeFL2az/rdwpeD8wMWg6hjDtUXfznhmwspXv6FAA3FGbi2eYsmplInkmTbtFNYKeFinDhd022fy3iM9bVIsZqpV+jBX7lEhYRW7KimMvh5W8qrBTjPChTD53BJRMv8ujew9Oharzem9HvU1osd+q9olZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIsf7UPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIsf7UPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4471F00893;
	Sat, 30 May 2026 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157614;
	bh=1vzBJtZEupgcPriJbzJYoIPLGtJHrEz3pO8RzG8Ftxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIsf7UPZrFFCHWq8vQQaV2H0U4pO2r2GykLOMmM6NNb01IszCbbNO0kXFuiI2ZAQx
	 r+GlXYkdoOaiJt/7cGaNwoHpcCZVwu4rmdH2ePoNq9xw2ed6KsE1dm10XSv5hQbM31
	 GXWmEuHSAU2qDvYC/uROTM8O5eI7PCGlZD/JvEjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/969] ALSA: asihpi: avoid write overflow check warning
Date: Sat, 30 May 2026 17:52:08 +0200
Message-ID: <20260530160300.608467120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 591721223be9e28f83489a59289579493b8e3d83 ]

clang-22 rightfully warns that the memcpy() in adapter_prepare() copies
between different structures, crossing the boundary of nested
structures inside it:

In file included from sound/pci/asihpi/hpimsgx.c:13:
In file included from include/linux/string.h:386:
include/linux/fortify-string.h:569:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
  569 |                         __write_overflow_field(p_size_field, size);

The two structures seem to refer to the same layout, despite the
separate definitions, so the code is in fact correct.

Avoid the warning by copying the two inner structures separately.
I see the same pattern happens in other functions in the same file,
so there is a chance that this may come back in the future, but
this instance is the only one that I saw in practice, hitting it
multiple times per day in randconfig build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260318124016.3488566-1-arnd@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpimsgx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index b68e6bfbbfbab..ed1c7b7744361 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -581,8 +581,10 @@ static u16 adapter_prepare(u16 adapter)
 		HPI_ADAPTER_OPEN);
 	hm.adapter_index = adapter;
 	hw_entry_point(&hm, &hr);
-	memcpy(&rESP_HPI_ADAPTER_OPEN[adapter], &hr,
-		sizeof(rESP_HPI_ADAPTER_OPEN[0]));
+	memcpy(&rESP_HPI_ADAPTER_OPEN[adapter].h, &hr,
+		sizeof(rESP_HPI_ADAPTER_OPEN[adapter].h));
+	memcpy(&rESP_HPI_ADAPTER_OPEN[adapter].a, &hr.u.ax.info,
+		sizeof(rESP_HPI_ADAPTER_OPEN[adapter].a));
 	if (hr.error)
 		return hr.error;
 
-- 
2.53.0



