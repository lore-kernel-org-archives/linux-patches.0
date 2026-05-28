Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2482580D7;
	Thu, 28 May 2026 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999392; cv=none; b=Eyy93o6alnAn+zUmKi4RGPeJolbvarSxOHh0UQdIUqZuT/oXSFcIgQ+DW0i5vIfNsh27r47W8jvhIp4CNiRWtAwy4e+HTBXxy9Ywdv66mX4XI3kSn0TIEebmqiiGQbO/P7c1vnaM1dvC4SBkxRZesnCXCN9zzbDoaEW7Y8fLCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999392; c=relaxed/simple;
	bh=xLyHM478zoics7hb2EhZEOGW2QHiFUt3OTlNZOzrbYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl0KrxY6i/txFTgBjk8BpwNmEwV3vtA0TsT0eekx4km1jmSSaE3eytz7Wo6+4i7ZY+BWUYbpea9EuoJ/aB2gd78/D8A7zqTU8SbXKuWnd42w7HT6PIN33XfOs3nK18sDwP0KIQJ0GW5ro5CXfw2RgucQzF0QhFnVH5HAfPInIkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TBu4uo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TBu4uo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAD51F000E9;
	Thu, 28 May 2026 20:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999391;
	bh=yFy4yReBx/tbjQtvNB7kvfYe7d7mCMd7Z4lhjs0NbNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TBu4uo6iwl7oWTCw9gd4O09R5E+uuL7fFQqxPKe2lwDvX6ip8F+lQI7QVQLXj+vH
	 FBP1Zup1cg92u7VX2vSLsJ6iDke2G4YqCZYh2oT0zylWLvfEAvD346qxyy1gdkdfcf
	 zcfuVKAXoShkkgkxxzcvLFWHFGX7bd3cz9rLxhJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 051/377] net: wwan: iosm: fix potential memory leaks in ipc_imem_init()
Date: Thu, 28 May 2026 21:44:49 +0200
Message-ID: <20260528194639.851396307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1426,6 +1426,8 @@ imem_config_fail:
 protocol_init_fail:
 	cancel_work_sync(&ipc_imem->run_state_worker);
 	ipc_task_deinit(ipc_imem->ipc_task);
+	if (ipc_imem->ipc_protocol)
+		ipc_protocol_deinit(ipc_imem->ipc_protocol);
 ipc_task_init_fail:
 	kfree(ipc_imem->ipc_task);
 ipc_task_fail:


