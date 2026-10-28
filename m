Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216762;
	b=G/i/i4ucqKeMV149HDFn3n3lPFtIGABRZanqbcqDMDfm8mhMzuJaxYU2542Z/Z/AR0ia
	 Q5Mf+QmmEtzRWXIMYwzvw5wilF7vJ84cCiyaEw8NRum5zoWmwaEaV2ap8Q2FSLh5o2qb2
	 OeQmPVrs5WwVl0NSvHg8fIVdDqoX90Em3FY7gW7dECrFDYwEYyjEeeI75kCC9gUGWJsYH
	 jb+vRVNwRz6v/kZjzXAtSsCSOIZSbGgKcfcIbqTAuaUoGoV/BC+ZWFCA+1TqD5Wl49bDA
	 waFogJdsJxm/5dHKEpvRvPmsx7v7/ADbbzQRVO1aOAfTvYH3eUBLvivKsFp1KCwU29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzpLiFkH7bVAc5jJXvPKgDccTRmK+9nG0ZBnwhWcfpE=;
	b=FRaTzfi+XCLIq0nHCjs0TybFI722Oj+wRYlv2FB89ww8rxn0KsIeiHDBOtzZJX7utKgd
	 vjoLWgI18nkvnVDya2ZmNHVFNU1/2YRa2vL1j7m3h/GY3V0uvXgunoRrdvnsvM3MKPNgw
	 9pK7w9QqLyXS/8BUGZRBsgJRTWLZ1CzkRnqkeSztHT5Qu+YF9SXvVPFOKeN4oRlkMUCPD
	 E53y4XVp2Sj9Aqy3kENzzUiY/jy3XYQhwrcfsR+/2sL6hY05Q3QETRRqwZYeFKAnPEf3Y
	 6L03sr+EaYf10Vv8o8PZc66YTFWze1R4U2QzZPGJj90mDEZuwodwLR1xVlMnl2vHgaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BV8DBILs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85104606A31A;
	Wed, 28 Oct 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BV8DBILs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35821F01825;
	Wed, 28 Oct 2026 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216762;
	bh=mzpLiFkH7bVAc5jJXvPKgDccTRmK+9nG0ZBnwhWcfpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BV8DBILsLG8FmvKcRrdteyljSnZZLxCeIPOPN79Z4TYJogFLJ276wbXPAKUg1m9Tm
	 8fb2c9siK+haUho//6wAoAMfqOkm3Gwq2kEEHIyBd0vqYSEPihGeFzHBSQuFXbXZmT
	 iWMhBHLwrgKE9bUcaMiT8a8lx5PWPsJDS60nUzBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1670/1887] drm/amdkfd: fix SMI event cross-process information leak
Date: Wed, 28 Oct 2026 18:02:46 +0100
Message-ID: <20261028170537.460093440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 92a8dba246d371fe268280e5fd74b0955688e6df ]

kfd_smi_ev_enabled() skips the suser privilege check when pid=0.
PROCESS_START, PROCESS_END, and VMFAULT events are emitted with
pid=0 while carrying another process's PID and command name, so any
/dev/kfd user in the render group can monitor all GPU workloads.

Pass the target process PID into kfd_smi_event_add() for these events
so the existing per-client filter restricts delivery to the owning
process or CAP_SYS_ADMIN subscribers.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index 7640fb76884ff..60007dc2c2764 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -244,8 +244,9 @@ void kfd_smi_event_update_vmfault(struct kfd_dev *dev, uint16_t pasid)
 	if (task_info) {
 		/* Report VM faults from user applications, not retry from kernel */
 		if (task_info->pid)
-			kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, "%x:%s\n",
-					 task_info->pid, task_info->task_name);
+			kfd_smi_event_add(task_info->tgid, dev,
+					  KFD_SMI_EVENT_VMFAULT, "%x:%s\n",
+					  task_info->pid, task_info->task_name);
 		amdgpu_vm_put_task_info(task_info);
 	}
 }
-- 
2.53.0



