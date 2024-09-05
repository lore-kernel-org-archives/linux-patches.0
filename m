Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85D5154BFF;
	Thu,  5 Sep 2024 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530150; cv=none; b=olaK3GaS4+9fwKG6fgYFqXoTBbILiYv42aVws7TuJt/ser4mpHaVbhRaLPUp6kWCWNlIWj8C3nPVt7sR7QFb6rJRnl5c8PUZ+50Kp2iIf5YnU9Fya++bdYnKLZ+pzyy7tHJ9C9cLgGFFbtW9aEyHNI07b5IGCoZyIj4J7nUPph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530150; c=relaxed/simple;
	bh=VIPFISC4mtgJqLXYCpfHlsJeZhAmswYvHrKodB57jP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3LixuH+QaehTGUd2F80R5SNebF+/w6e/o/7BDEiXFqaPU+BlNuRTuATucr0BxeqL201HNCRnjlnlvGjjcRPOkfewGrikYuzQ4Nrw9pOzmPoFTBLmYkVbpRkHyVeVqWLT1LP/IVk9U0gBCwkKEbQD6gaUpA4JeQMyC1oJ6+ezNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcZQszpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcZQszpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B01C4CEC3;
	Thu,  5 Sep 2024 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530150;
	bh=VIPFISC4mtgJqLXYCpfHlsJeZhAmswYvHrKodB57jP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcZQszpnMKriL+i3MKVlDESiHWe29JhSvhg8PdZllf59lk9xRDD69i02QOQs9WY6x
	 0c4hW0CDAX/O0zwhCCb8iz15Dhn5kB9dSJiHfT1ASN+KdikHsrOIzcXd84JeOgAB/f
	 7yMnFBeUH+fqzh3Eqe4kO/bXMJrsyRIB6TM6nGVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/132] drm/amdkfd: Check debug trap enable before write dbg_ev_file
Date: Thu,  5 Sep 2024 11:40:57 +0200
Message-ID: <20240905093724.980986883@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ec750666382..94aaf2fc556c 100644
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



