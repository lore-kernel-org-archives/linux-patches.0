Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103AF3C1406;
	Sat, 30 May 2026 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165006; cv=none; b=copsq4T8zQt5tXdhb39oHetF9qtamshWqQ1MKFcuG45VuP/pgrEN/sjpOfIaUubYyI0NLsAqpUrmYej8mbRCzebiGlxg+ZgRDzl7VJQYFi63XNLjhs46KDxnd+6SFOjwBCfDlsPR2hvJRaDBh71aqllOwZKI7Tjg/femvBqSChg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165006; c=relaxed/simple;
	bh=J5GdDYkt2IhhIeeRdO6Sa3uo6Vb0xD34enjSpuQaRFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqXnn+F3BkbRyulNG4xRc84Kx1H+jPgiFkqFrtzzwCXIan/UOaBEa7l44WntyMJYdMnjQHhS/QlTOPdCvRLgN/8V6hxmugcKAH7T/2fhtLlbVPli7zrgXK3XWA3RAM0t4nI+cgII254lCs3wqiSJsc8j4+zJUuDJcBdASaVsFqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN2EMgDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN2EMgDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E58B1F00893;
	Sat, 30 May 2026 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165004;
	bh=KGgfR7QzDezesBTMXJahfqaJTesMgq23IHlNh7vsmxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tN2EMgDp6vt7NpyfwiRtepV8MDWHOA2MDAr5M46F3l6dFmZCNDNHsqYkyrysY4okX
	 jXgMrasOAdX05UJzbF0TOFbqwwV26MHCtR1ZxMsUNPVkyGJWkc6vqEHtB+xM7OZtpZ
	 t6A+ihSFpHzLGBP4axYzI6ynG9fgYsLB3YAE/CV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 682/776] net: wwan: iosm: fix potential memory leaks in ipc_imem_init()
Date: Sat, 30 May 2026 18:06:36 +0200
Message-ID: <20260530160257.492285353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit c5d93b2c40355e999715262a824965aac025a427 upstream.

The memory allocated in ipc_protocol_init() is not freed on the error
paths that follow in ipc_imem_init(). Fix that by calling the
corresponding release function ipc_protocol_deinit() in the error path.

Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260519062815.55545-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -1338,6 +1338,8 @@ imem_config_fail:
 protocol_init_fail:
 	cancel_work_sync(&ipc_imem->run_state_worker);
 	ipc_task_deinit(ipc_imem->ipc_task);
+	if (ipc_imem->ipc_protocol)
+		ipc_protocol_deinit(ipc_imem->ipc_protocol);
 ipc_task_init_fail:
 	kfree(ipc_imem->ipc_task);
 ipc_task_fail:


