Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659F3B7753;
	Mon, 20 Apr 2026 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691474; cv=none; b=aiO6iIzEv6LjHPFKEygYJ+CMTdzF5yJiL35GNUE9t0dLvq7dFtE0+FW/YSGUA8fih7wrRps2ZRdpEczl80GAM190978YOY2FvHsi9i2VG1jGGrqYfWAjGzdzuKRznpJqT4qQPMwvjhVybO/YeDgsOmqLo3jdAZfldbabFWMfDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691474; c=relaxed/simple;
	bh=sKxcEIsMkYrqhqC0j+Rz8/yv4B2r7x61leiLSZj+R0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEkP47EkhSZbIWvkT0b96ZLzGq2oC2IhqkNiUfaOUe6p/GkyJACL3QgDlKOH3ul4FqA+29CGca5u5uemWKvbdHN1CDVez/90HAxpNn7BuOBYVy3AXljZsDMTZuD3dZxGwSxl97VNZVRVgkiHXBmRz8oTgDg62Ubkej+9pCVvFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOuXL8XG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOuXL8XG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D227AC2BCB6;
	Mon, 20 Apr 2026 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691474;
	bh=sKxcEIsMkYrqhqC0j+Rz8/yv4B2r7x61leiLSZj+R0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOuXL8XG/2l0yK/ZAeV/qhYyD3VS65HAWnptzEUgnV9LFFyTtCe41AflBMWOsegkR
	 wxWcdTrWLyVb8kc3L3pG0L8PUROQv+X0s8WBsSxGcksJEtMjK9pV7sL9oJpVK4yih0
	 fqa9KcPET/7ti2+1G3O76fKozzMaICN/tqFLSeMZS9XwYiyzk2+p23knKIMb/eeKZC
	 yMBe1S3ZasbwQEzG2tk1Mo4klTpzq7NtAjP9tdnjCr1p0ZazKxfCKE+5tVS9oQllPf
	 gQTtSk0azu4o55LULD0VzedL0epwW1rpqvFsLz99KAzJkfyvCcR18ASygCDP1bnkRU
	 AVUosa6kTSf1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: asihpi: avoid write overflow check warning
Date: Mon, 20 Apr 2026 09:17:25 -0400
Message-ID: <20260420132314.1023554-51-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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

