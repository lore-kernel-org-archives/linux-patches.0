Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EF52874E9;
	Tue,  6 Jan 2026 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720463; cv=none; b=A4t5TdMvZc5CVzpObxPQhHgYWmjKlq+/YOmFJVaArowfbnK2n22zkXxGFprr6cpqBKHF1fY6BpIe33+zMY9eNGYEVkp95raz25tgSC3aBfCeSIO/ZSivz4sQ6drkxTSXw/5vtntkdduhBEjTtoAXZpr99UxS1VndITEhFjM9RK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720463; c=relaxed/simple;
	bh=mRC2p7+7UE0GbtfWDrm1Jc+OqoU12ykb2WsQ7zAh3Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az1f76agxAPExDoJCBulWt5tF8CriUt/4Qvf8ovuzYRpMGHlIuXIruTXY933U0cMsJtfo7GZ9Ia7usprhIjFf5dEPgET6oBrUfUkgtdyoJry4DTYW7xX8R3NfWSsYWpMv2irjvLp39SKEmKbgrz3q4Bz/3bo/btYVU1WGgUJnhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1jvetbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1jvetbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDEFC116C6;
	Tue,  6 Jan 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720463;
	bh=mRC2p7+7UE0GbtfWDrm1Jc+OqoU12ykb2WsQ7zAh3Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1jvetbiFGkxsF2PAqDiANzcRq1/rZMfKsz5/8YQ96iZ5qonp7qOeXUFi9JVFlEGU
	 xRL/Q+OziAgA7jZi2k9XpmKSR/Lw9abslSGdqxjRF9E/eBz3mDzf1iL5alIUj4k8kn
	 KH8IAiUXOC3rmxNTi7G+uvPCN1S57Mc0pMiVtA50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d9c0edea5907af239e0@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 212/567] media: vidtv: initialize local pointers upon transfer of memory ownership
Date: Tue,  6 Jan 2026 17:59:54 +0100
Message-ID: <20260106170459.163283048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 98aabfe2d79f74613abc2b0b1cef08f97eaf5322 upstream.

vidtv_channel_si_init() creates a temporary list (program, service, event)
and ownership of the memory itself is transferred to the PAT/SDT/EIT
tables through vidtv_psi_pat_program_assign(),
vidtv_psi_sdt_service_assign(), vidtv_psi_eit_event_assign().

The problem here is that the local pointer where the memory ownership
transfer was completed is not initialized to NULL. This causes the
vidtv_psi_pmt_create_sec_for_each_pat_entry() function to fail, and
in the flow that jumps to free_eit, the memory that was freed by
vidtv_psi_*_table_destroy() can be accessed again by
vidtv_psi_*_event_destroy() due to the uninitialized local pointer, so it
is freed once again.

Therefore, to prevent use-after-free and double-free vulnerability,
local pointers must be initialized to NULL when transferring memory
ownership.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+1d9c0edea5907af239e0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1d9c0edea5907af239e0
Fixes: 3be8037960bc ("media: vidtv: add error checks")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_channel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/test-drivers/vidtv/vidtv_channel.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_channel.c
@@ -461,12 +461,15 @@ int vidtv_channel_si_init(struct vidtv_m
 
 	/* assemble all programs and assign to PAT */
 	vidtv_psi_pat_program_assign(m->si.pat, programs);
+	programs = NULL;
 
 	/* assemble all services and assign to SDT */
 	vidtv_psi_sdt_service_assign(m->si.sdt, services);
+	services = NULL;
 
 	/* assemble all events and assign to EIT */
 	vidtv_psi_eit_event_assign(m->si.eit, events);
+	events = NULL;
 
 	m->si.pmt_secs = vidtv_psi_pmt_create_sec_for_each_pat_entry(m->si.pat,
 								     m->pcr_pid);


