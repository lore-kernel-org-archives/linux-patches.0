Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BBF199395;
	Thu,  5 Sep 2024 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529613; cv=none; b=CokjG3LXchrgY90qaXZjrMKtMFKx2f8DJQ+6+hyXi823akPtTh17kH5m89AtZzFlaYMTGxbS7rQc3tIFCXAZo657A/N+exG8ijYCFhNnSP5Gm7+jvRgL8igLm4XYOS4Sgl21e7xf8qgoCSUb9QnYmpMmunzun+orRysk64UulL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529613; c=relaxed/simple;
	bh=spAmDzx50BeYbg5pw8YI9XhEHXw5bobUNum7Nx6hj7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7pfFv66kepE8nskDGZAhDdsCAmCAEGJ3pUufc+VcGuoqpcZoD5/r1wTrbr6M9irbj7dtiDlbGSjfjJpfhfv0sbDsLuLOvmAUf+fS8ZzTmCft9/v3ixilWYEOxbTVP9OQgPZollOuKEe6Vf9K7MksCy13wHq7Pi3F6rp16X6/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxpCl+EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxpCl+EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23601C4CEC3;
	Thu,  5 Sep 2024 09:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529612;
	bh=spAmDzx50BeYbg5pw8YI9XhEHXw5bobUNum7Nx6hj7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxpCl+EHVhJ0pZkvljyAkXfTQF0FYsjWyNGfdlYE1mvckXrPFlu47u9V75osBnV4E
	 hQC9pmENP05wE0mBfhCQRQ9xJCirc26dLcAtZeMiJcuQrNN+HsAsNdhvzmExXZihlU
	 bmkNUBP/48eYm8O62RIhB7sGGmmlliZ/B0ZWIUi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/184] drm/amdkfd: Check debug trap enable before write dbg_ev_file
Date: Thu,  5 Sep 2024 11:40:00 +0200
Message-ID: <20240905093735.635512291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

[ Upstream commit 547033b593063eb85bfdf9b25a5f1b8fd1911be2 ]

In interrupt context, write dbg_ev_file will be run by work queue. It
will cause write dbg_ev_file execution after debug_trap_disable, which
will cause NULL pointer access.
v2: cancel work "debug_event_workarea" before set dbg_ev_file as NULL.

Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
index d889e3545120..6c2f6a26c479 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -103,7 +103,8 @@ void debug_event_write_work_handler(struct work_struct *work)
 			struct kfd_process,
 			debug_event_workarea);
 
-	kernel_write(process->dbg_ev_file, &write_data, 1, &pos);
+	if (process->debug_trap_enabled && process->dbg_ev_file)
+		kernel_write(process->dbg_ev_file, &write_data, 1, &pos);
 }
 
 /* update process/device/queue exception status, write to descriptor
@@ -645,6 +646,7 @@ int kfd_dbg_trap_disable(struct kfd_process *target)
 	else if (target->runtime_info.runtime_state != DEBUG_RUNTIME_STATE_DISABLED)
 		target->runtime_info.runtime_state = DEBUG_RUNTIME_STATE_ENABLED;
 
+	cancel_work_sync(&target->debug_event_workarea);
 	fput(target->dbg_ev_file);
 	target->dbg_ev_file = NULL;
 
-- 
2.43.0



