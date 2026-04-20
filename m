Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB22329C6D;
	Mon, 20 Apr 2026 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700089; cv=none; b=AdXdHzscwJQvDuaVc/t3llx670stELiubi0cAv6iLDMz4MdcjyCf741okYml4obh08HU6Xd/FHjMmKW8c9cRI6dl8oafSfr2mff3uNP4JDv4H68AqazSRpaHO3PDCA3xo2/wSZWA2EU4rJT2YE3R/KLPqQjmLcU5xPhfyNhCnTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700089; c=relaxed/simple;
	bh=hFlPrrQ7ft1BhofwX4j7r/EmE5Ey4lI3n5whfGYfpWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN/lfZJzAI7FH7cP1uWxTo8y3V5Zi6TKaY2LIH8P7wqPBh+/gZiN7qjxIeQDc7abdBNvqq5JqoFhkVtBGqCCf1SlIFR06XTmWbCUfoRMUzKotYh3DZMptmarCKDZubI870R71yFp76jtZ3GO8tZnmc5p6dy9XJ7PMf7g+qHZ+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPVw/DbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPVw/DbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4670EC19425;
	Mon, 20 Apr 2026 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700088;
	bh=hFlPrrQ7ft1BhofwX4j7r/EmE5Ey4lI3n5whfGYfpWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPVw/DbDYTD3LI+Hofg1FCzqKu8DDzFDA3rMZXX7FKhobt9CeFw6yzESkFcnyXI0t
	 J0Ey7ZdsgeTHbL2awH02zq+mDOqepEd1Pg4MeFRSZJX3bsHqybAvmNCpPfZd1SvngT
	 6OH7L+BOZD2d6JLrVeo8k3SK2aduvpaACf0vViFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 008/220] ALSA: asihpi: avoid write overflow check warning
Date: Mon, 20 Apr 2026 17:39:09 +0200
Message-ID: <20260420153934.322319089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



