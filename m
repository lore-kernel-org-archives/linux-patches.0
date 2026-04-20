Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1B13382F4;
	Mon, 20 Apr 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699906; cv=none; b=IinyGPw4xcfSn3YckvLz8t9STsOEf8BrCcOGgv3raqpAhqqkqPMIz95kMAwQczNADLvHpSlGSHF0435axICfLnkXlm2rnLf950R80XUi0Xcp9jTRVhp2G5RJhZjRkdRa0IiY1gKEbt4/9WW3EiFk3f71lEizCFL3dUCqVeWlDsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699906; c=relaxed/simple;
	bh=pIsyzkSQzKCDYvogbpz+Jwg2YYv6RG8WIVTiAqEnRpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht/5T/DFsVEOwjZsRTaCVv+bilvCxk6mnGEchk8rvdpCsitH6E1Ke6CDEAXAWv2cJnNw13LXo3atMAAUJ9QmJRbEfZztYVeFV+YIix0jWeGdHXNvp/7gWmC0pXkBGhks3YI8zaCVvhfgRMU1UzyHP+B9m++ujhV+HZ1L8EVAds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1u8XlCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1u8XlCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82DDC19425;
	Mon, 20 Apr 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699906;
	bh=pIsyzkSQzKCDYvogbpz+Jwg2YYv6RG8WIVTiAqEnRpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1u8XlCHPJAtgEsp/ZSRavgGpCQ/8A7hGdSdqviTcH4EIac/RJNsvogc20W2Kt3m9
	 NTYzNfWtn7ahNK/fr/vvr1K8zPtCxhFIrRAlaKP0cP+qSv/3Wvc7oMskmO2vBlyT/Y
	 JLC6X22hBnzBp78FjBUUKT6OqN5pEMr/pyzf+SUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 44/76] media: vidtv: fix NULL pointer dereference in vidtv_channel_pmt_match_sections
Date: Mon, 20 Apr 2026 17:41:55 +0200
Message-ID: <20260420153912.429789524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit f8e1fc918a9fe67103bcda01d20d745f264d00a7 upstream.

syzbot reported a general protection fault in vidtv_psi_desc_assign [1].

vidtv_psi_pmt_stream_init() can return NULL on memory allocation
failure, but vidtv_channel_pmt_match_sections() does not check for
this. When tail is NULL, the subsequent call to
vidtv_psi_desc_assign(&tail->descriptor, desc) dereferences a NULL
pointer offset, causing a general protection fault.

Add a NULL check after vidtv_psi_pmt_stream_init(). On failure, clean
up the already-allocated stream chain and return.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:vidtv_psi_desc_assign+0x24/0x90 drivers/media/test-drivers/vidtv/vidtv_psi.c:629
Call Trace:
 <TASK>
 vidtv_channel_pmt_match_sections drivers/media/test-drivers/vidtv/vidtv_channel.c:349 [inline]
 vidtv_channel_si_init+0x1445/0x1a50 drivers/media/test-drivers/vidtv/vidtv_channel.c:479
 vidtv_mux_init+0x526/0xbe0 drivers/media/test-drivers/vidtv/vidtv_mux.c:519
 vidtv_start_streaming drivers/media/test-drivers/vidtv/vidtv_bridge.c:194 [inline]
 vidtv_start_feed+0x33e/0x4d0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:239

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5bcc7c919ec578777a
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_channel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/test-drivers/vidtv/vidtv_channel.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_channel.c
@@ -341,6 +341,10 @@ vidtv_channel_pmt_match_sections(struct
 					tail = vidtv_psi_pmt_stream_init(tail,
 									 s->type,
 									 e_pid);
+					if (!tail) {
+						vidtv_psi_pmt_stream_destroy(head);
+						return;
+					}
 
 					if (!head)
 						head = tail;


