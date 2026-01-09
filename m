Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260C338911;
	Fri,  9 Jan 2026 12:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960587; cv=none; b=cEkVagR7aDFrx39+uo6i0NkD7naO7UgkuIFVYdVOQc9KHKC8BSuG35eiu76bkfyRB/ZW3uKWy3mM/SHrNajRhTrfxkZBeeKbTrn3PESJPCXBPu2BLf66lh4q5IbuVSXJ7sTHzx8/vyJ611ySTWvzmzPPePphAhZlYvn48IUDS3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960587; c=relaxed/simple;
	bh=fkgSClaGZL+dBYFM3Tjt7Td580VU57xjarfhNVqKM2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOx0IfgHd8JtkVUrlhYMQrFFuqx6oXs2mNuhlxxf2tx7x9NUsgGNHaYySIhSGe/Vz09jcsMZORKIURBvW/IHfZosx2l9cpYOL2UfoG6iSskvS78it8AGvZceGGIpc+k81qFEf+Q3s7eQEMAFV6ZdJsWbMaPfomudP0n4Gn65v2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLjEznVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLjEznVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D4CC4CEF1;
	Fri,  9 Jan 2026 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960587;
	bh=fkgSClaGZL+dBYFM3Tjt7Td580VU57xjarfhNVqKM2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLjEznVOhuzfCHyyM6Bu2FJH8Tp7y7ebWeR+u/++YxIqx5YUu8ic8CHwK2ne6QDsO
	 e8rWY1vASzSgd+/RX4aCVC8XgAkxgX+6STcCNFsJM16B58i78WNJmrv1PKMeaxmDgz
	 qSCti0+YkIDQVs8yQ0i9T0y95wjov3LCU2fy90mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d9c0edea5907af239e0@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 455/737] media: vidtv: initialize local pointers upon transfer of memory ownership
Date: Fri,  9 Jan 2026 12:39:54 +0100
Message-ID: <20260109112151.110825687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


