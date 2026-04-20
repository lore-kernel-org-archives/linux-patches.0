Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBB3385B6;
	Mon, 20 Apr 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700519; cv=none; b=lrNk+xXDbiepnjLhFDpBdGRwCURcRU7hdlYmvFobI9GcnQzXOPsWmZpbFr19ASQPQDQroe3QLd0X1JJaA0HxUNzy8zokE1Ecg4npQVTkUsXc8Id7HATFKfWfQuXCApE7Vo9QPqZkpySXT59N8zSGoREjWbMkDPFZBxVhOD3sOlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700519; c=relaxed/simple;
	bh=nsVoiw2CaHThiSDItu9J8Wt7uwMcz6IhjQD+Sfua+Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plBNZpAJnplX94VmIkFu3FQphUPquy3vKpRb0raC0YYMVrzJq496TOSbXVtnM3BR22ZH3GDKtpfiPmstGwt5LMs4VAZhnVTT+shWRhhWiWX0HQnpH1khAt4Gn+yIAo/KpgwQtRxxJ7H76HW6oloyxccronGATOSOsMhMQhpLSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUcUWBeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUcUWBeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2AEC19425;
	Mon, 20 Apr 2026 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700519;
	bh=nsVoiw2CaHThiSDItu9J8Wt7uwMcz6IhjQD+Sfua+Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUcUWBeH7si02ljOVcLEsz0+VDKgM2RU8WpbwZyEn9lD898ke573klMne7sU7dnrc
	 /ITYTEOmT0tLspyUtV/QJCTN8VNTrJW2A4m5ysGx4Mt59xfddugBSdn507xjtmejkb
	 lm6djjRhC9bIqUkt+ennKuCBHJgrYbwlVxId1f7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 177/220] ALSA: ctxfi: Limit PTP to a single page
Date: Mon, 20 Apr 2026 17:41:58 +0200
Message-ID: <20260420153940.400642719@linuxfoundation.org>
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

From: Harin Lee <me@harin.net>

commit e9418da50d9e5c496c22fe392e4ad74c038a94eb upstream.

Commit 391e69143d0a increased CT_PTP_NUM from 1 to 4 to support 256
playback streams, but the additional pages are not used by the card
correctly. The CT20K2 hardware already has multiple VMEM_PTPAL
registers, but using them separately would require refactoring the
entire virtual memory allocation logic.

ct_vm_map() always uses PTEs in vm->ptp[0].area regardless of
CT_PTP_NUM. On AMD64 systems, a single PTP covers 512 PTEs (2M). When
aggregate memory allocations exceed this limit, ct_vm_map() tries to
access beyond the allocated space and causes a page fault:

  BUG: unable to handle page fault for address: ffffd4ae8a10a000
  Oops: Oops: 0002 [#1] SMP PTI
  RIP: 0010:ct_vm_map+0x17c/0x280 [snd_ctxfi]
  Call Trace:
  atc_pcm_playback_prepare+0x225/0x3b0
  ct_pcm_playback_prepare+0x38/0x60
  snd_pcm_do_prepare+0x2f/0x50
  snd_pcm_action_single+0x36/0x90
  snd_pcm_action_nonatomic+0xbf/0xd0
  snd_pcm_ioctl+0x28/0x40
  __x64_sys_ioctl+0x97/0xe0
  do_syscall_64+0x81/0x610
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Revert CT_PTP_NUM to 1. The 256 SRC_RESOURCE_NUM and playback_count
remain unchanged.

Fixes: 391e69143d0a ("ALSA: ctxfi: Bump playback substreams to 256")
Cc: stable@vger.kernel.org
Signed-off-by: Harin Lee <me@harin.net>
Link: https://patch.msgid.link/20260406074857.216034-1-me@harin.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctvmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ctxfi/ctvmem.h
+++ b/sound/pci/ctxfi/ctvmem.h
@@ -15,7 +15,7 @@
 #ifndef CTVMEM_H
 #define CTVMEM_H
 
-#define CT_PTP_NUM	4	/* num of device page table pages */
+#define CT_PTP_NUM	1	/* num of device page table pages */
 
 #include <linux/mutex.h>
 #include <linux/list.h>


