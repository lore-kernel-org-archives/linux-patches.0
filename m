Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C41369D6E;
	Wed, 20 May 2026 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296303; cv=none; b=V0kGmGD7D9GSUXzeIJLZh97XMipb2x/NT3Xc7KoQpRdeQQYvHZfZzNaI6enqibgH2SuDxrvGWeUKnsa9GoZlwx5rbrKKX/QRW1RxGbbLprCElg4YH/3heWI5vQioogGnWG0Bkjqbw9WuDaPqoUBUxOQ11PJnXsDBDPG1gmVhh1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296303; c=relaxed/simple;
	bh=EDDpnOpNoCnYMsY6cueo/O8dB3NhYihmvMFFDYs4QaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQWeGnU/hQlzsy8zLndtZz7Vs4SIh2GlqsLpNEQj/zd1+VH0io4U2PNHNiy1E11ZlHakT62pDXgw0YJcDJXpmwbM9RvEbTB8j8Dx3XcbLLDqUysMpiG/nAQuWE9i6I+V5/iJPBExiYhpHgIlKHlU+B0Pu0n3mhu3tKHtFjpi9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmM55s8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmM55s8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE11F000E9;
	Wed, 20 May 2026 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296302;
	bh=7pILSf6qHYCe+48F7IIi7WgyQ4DZmik3bqdUnHiF/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmM55s8HIYC5qZPGlNvI7Q5z/GqeROOI779+3MtyflDP/jc0V5AUQFVNc+agMjQNK
	 Kg9wTzzdsI+cav8K7jG1MJFGIdncwI4pxxqbJUhFZirf2HFAXmc23n1Bbw+E7xTJWC
	 MwxtjQL0BectO2xJEEjJSjPjdgb6N3CEV0hzdnZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0749/1146] Drivers: hv: vmbus: fix hyperv_cpuhp_online variable shadowing
Date: Wed, 20 May 2026 18:16:39 +0200
Message-ID: <20260520162205.159547927@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Jork Loeser <jloeser@linux.microsoft.com>

[ Upstream commit 3c42b33433796b73ddecd8f60bda419b1648d997 ]

vmbus_alloc_synic_and_connect() declares a local 'int
hyperv_cpuhp_online' that shadows the file-scope global of the same
name. The cpuhp state returned by cpuhp_setup_state() is stored in
the local, leaving the global at 0 (CPUHP_OFFLINE). When
hv_kexec_handler() or hv_machine_shutdown() later call
cpuhp_remove_state(hyperv_cpuhp_online) they pass 0, which hits the
BUG_ON in __cpuhp_remove_state_cpuslocked().

Remove the local declaration so the cpuhp state is stored in the
file-scope global where hv_kexec_handler() and hv_machine_shutdown()
expect it.

Fixes: 2647c96649ba ("Drivers: hv: Support establishing the confidential VMBus connection")
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
Reviewed-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index bc4fc1951ae1c..3d2827477f0a5 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1430,7 +1430,6 @@ static int vmbus_alloc_synic_and_connect(void)
 {
 	int ret, cpu;
 	struct work_struct __percpu *works;
-	int hyperv_cpuhp_online;
 
 	ret = hv_synic_alloc();
 	if (ret < 0)
-- 
2.53.0



