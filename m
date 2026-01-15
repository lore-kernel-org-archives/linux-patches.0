Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227F33C0089;
	Thu, 15 Jan 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498090; cv=none; b=s+pe02CS7Q1hkYoaoL47odhHRtm5zURVPo9/0Gz5E/dq8+HTwkftgvx5c0dIGSo6FuKoNhEn6YrHyQ3YTHBJssv4sxwN2ERyxqBzKWPOQIzh/7yLAf8IM1NOYpRKxEAG9KE2gWx1PjIyT/1mV7ixpSMdUYarvRBp83rGdZ5ztbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498090; c=relaxed/simple;
	bh=KZfA/gcS4+yFvsjvNmc4Yd0qaK4LArCR0+WH/ajwz/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClTw18bgP6aixvW+H36l0CdkRrG4nEDN4mFTQ/uJvWyl6epppA0xXmEDOKt5zV7AhmQrvoAIOXRTziuoHvvo8ISKHjV4aiBDSHfRwSWg6sz0uK7UOFMuxQLWK1h9D96j2nJT+GTHe+pbdXVVoxwPPvm/mEtXde86Sg3x0lcFz5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtapgW0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtapgW0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44CFC116D0;
	Thu, 15 Jan 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498090;
	bh=KZfA/gcS4+yFvsjvNmc4Yd0qaK4LArCR0+WH/ajwz/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtapgW0cgXvWAWLhMkDIJ+DhWZ4o6mEgfx+ZaDCQ3dv1Qmzpx9/crTT5AHYxj6sMx
	 zw2qhF8jPbBgB/odxrtDOanhDCCeLPSu9AvG0HJpw4td6pMtYJGfdDDnH3vjOsmZ6N
	 4KOBAAwGwLdNxVJXrq7oAX1mDbgyXDf5de34dFM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d9c0edea5907af239e0@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 308/554] media: vidtv: initialize local pointers upon transfer of memory ownership
Date: Thu, 15 Jan 2026 17:46:14 +0100
Message-ID: <20260115164257.380799514@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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


