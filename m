Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617842;
	b=QTMhldJlUT0z6XyBDFBlIfuyIiQ3O+fmJ8PEyt2MFMXbRSoQVblSO7EweaqqTtjzNe4j
	 d+Ipo3QQSSnef9VBdAB+RzpyxRvgTBDP720taxbPTdVVPwLjx8mm9P1oPvqmoTNxrLRqJ
	 c0pS2CFJbDl1dohr9A55IRCYwHRDSUR7G6oyKArejDkJtXUlLLt4CYceLyv3euocXYYm5
	 ygH4R7FG/Lzu1MH95B+D9Rkl3fESq0yZ8fXBCvjM83SklDwm9f4UiO2C9iTkyJ8/63kzj
	 MRAxde7AULml+6FSmof2WpVa7kbXFoXxdRXfvrrIZm8Th44btXR0sV+HS5spzgDrA0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRgEm/hv4sFeXRvSR2Xg69WEs9307l0zjaRyV1CLYh4=;
	b=L3HLayEFbt/FNf6dHLF2s5JdayMPFKzzUe3vHyhcdkGlMn4JHnzg+jf2UPwNDTa4vJPK
	 otoxkfNllBITA3dCkZCp+TW9YQhrqR/uaiRTXSYTIGXUwqYEwrVjKjqjQhGTXsOV1QM8x
	 10qakOWWGI13GcGnSwCm/+jWXO+cdtH2h0N5eleXHL51SgWPE7goZxJ9LvrTEJay3a/bV
	 O2j8ZhCzLD2bYnlXs/rKv9GO0bRzqy2Yc4N/pM0F0+82bO3623sa8XTVa0xceFSzn6ska
	 G4hr9QJ6v0p/oznLT6ODdQLDQTcgiuXFqsqN2HfWt0/8Li5HaoZtydm8pbQb+xdU6qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OL9U6fm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC9F606A334;
	Wed, 25 Nov 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OL9U6fm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0283B1F00AD3;
	Wed, 25 Nov 2026 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617842;
	bh=QRgEm/hv4sFeXRvSR2Xg69WEs9307l0zjaRyV1CLYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OL9U6fm7p2DrwSDDvXDWAGARCLKAE4F8TPGkyi5XEiE+KBY+OnaTDzalEP/gar3gE
	 xH7I/jh6dYU9jy1BMnLUEWDyj+u96HzMWRk5u7/m/d0m5cxsGeqyCiimgDkDjg8ktW
	 kE2QN0ITWFKNaXH5y1CDellAckTTINoiZYeJEtfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 0092/1005] ALSA: hda/core: Fix double free on stream page allocation failure
Date: Wed, 25 Nov 2026 15:23:50 +0100
Message-ID: <20261125143823.898030488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 1886b8132cd37edbc28b55f30a885011aa0bbe8a ]

Since commit f16eaa38ea64 ("ALSA: hda/core: add cleanup in
snd_hdac_bus_alloc_stream_pages()"), snd_hdac_bus_alloc_stream_pages()
frees the BDL and position buffers it has already allocated when a
later allocation fails.  snd_dma_free_pages() doesn't clear dmab->area,
so the freed buffers still look allocated to
snd_hdac_bus_free_stream_pages(), which the HDA controller drivers call
from their destructors, and they are freed a second time when the
device is removed.

With fault injection failing the CORB/RIRB buffer allocation of
snd-hda-intel on a QEMU ich9-intel-hda, unbinding the device then
crashes:

  page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
  kernel BUG at include/linux/mm.h:1986!
  Call Trace:
   ___free_pages+0x9b/0xa0
   free_pages_exact+0xa5/0xd0
   snd_hdac_bus_free_stream_pages+0x43/0xb0 [snd_hda_core]
   azx_free+0xb3/0x1b0 [snd_hda_intel]
   azx_dev_free+0xd/0x20 [snd_hda_intel]

Clear the buffer pointers after freeing them in the error path.

Fixes: f16eaa38ea64 ("ALSA: hda/core: add cleanup in snd_hdac_bus_alloc_stream_pages()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261028144443.992569-1-sashal@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/core/controller.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/hda/core/controller.c b/sound/hda/core/controller.c
index 78855ac357c60..d1d85511a9dba 100644
--- a/sound/hda/core/controller.c
+++ b/sound/hda/core/controller.c
@@ -745,10 +745,13 @@ int snd_hdac_bus_alloc_stream_pages(struct hdac_bus *bus)
 
 error_posbuf:
 	snd_dma_free_pages(&bus->posbuf);
+	bus->posbuf.area = NULL;
 error_bdl:
 	list_for_each_entry(s, &bus->stream_list, list) {
-		if (s->bdl.area)
+		if (s->bdl.area) {
 			snd_dma_free_pages(&s->bdl);
+			s->bdl.area = NULL;
+		}
 	}
 	return -ENOMEM;
 }
-- 
2.53.0



