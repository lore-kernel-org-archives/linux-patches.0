Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CC370D54;
	Wed, 20 May 2026 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296958; cv=none; b=AKCyDLAcL2qYC4g6OZK4dhV0Dvgj7+ygmE7aVm+qwpRV+m9r8QPRMcg40Dt+3xSa8M/YgEjk5ikvEqvAhklDHrtbr3mcNepOcRLf2zWM2WE3Hvm/Cqmilw4F+Y0bM6KQ+v2IxHVnf6tQs3q3pY+xu9E2XymX20BUkMOKhhpsLW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296958; c=relaxed/simple;
	bh=mzp89KiHoyjre3jYD7VwsP4Q7aYFGZQaOlKBJCDWhuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbsVApvW5hAJhkAASC1fprstdj6qVKMoTOF9DBKRBxPlvZlLaDOQ7CZhNaE44Vj4x2Agj8Ds8VZzu8L9Oxsgy0Ch8yCO7blnjzsepfJ4/Zk0hYvGK5GXes4Edr2CNTn5MalLaw1bLmG25n4ycx4OwvogEHFCaf4mGXLOB88zGTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVStVMlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVStVMlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A64C1F00893;
	Wed, 20 May 2026 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296956;
	bh=apdbwlXN1M0jhpLwwRajSIQ6MliS55PfLfb/hNgs6z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVStVMlb4f2nW2JCAFSS7HjtFexvdrc0/YaGpNU6eSejuaKhg4vYxvdsXbXW9FVfj
	 CUbg84J5r4WrQRGp/4rOEUMgnBOQ0LO5ITe2MojEClJ5dDmsWnIVFIA74UJi+YDlr/
	 5s43/sdD1LAFLrujIzCJGVWsAVLImaw9THLKK7FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0994/1146] netconsole: return count instead of strnlen(buf, count) from store callbacks
Date: Wed, 20 May 2026 18:20:44 +0200
Message-ID: <20260520162210.727504177@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d62c6f2df5c0e1390b9a1f45b1b52689e3f234f0 ]

Several configfs store callbacks in netconsole end with:

	ret = strnlen(buf, count);

This under-reports the number of bytes consumed when the input
contains an embedded NUL within count, telling the VFS that fewer
bytes were written than userspace actually handed in. A conformant
partial-write loop would then retry the trailing bytes against a
callback that has already accepted them.

Every other configfs driver in the tree returns count directly from
its store callbacks once parsing has succeeded, including
drivers/nvme/target/configfs.c, drivers/gpio/gpio-sim.c,
drivers/most/configfs.c, drivers/block/null_blk/main.c,
drivers/pci/endpoint/pci-ep-cfs.c, and the rest of the configfs
users. netconsole was the outlier (along with
drivers/infiniband/core/cma_configfs.c, which has the same latent
issue).

Align netconsole with the rest of the configfs ecosystem: return
count once the parser/validator has accepted the input. The numeric
and boolean parsers (kstrtobool, kstrtou16, mac_pton,
netpoll_parse_ip_addr) have already validated the meaningful prefix;
any trailing bytes are padding and should simply be reported as
consumed.

Fixes: 0bcc1816188e ("[NET] netconsole: Support dynamic reconfiguration using configfs")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260427-netconsole_ai_fixes-v2-1-59965f29d9cc@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 205384dab89a6..76d7fbf9e1883 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -752,7 +752,7 @@ static ssize_t enabled_store(struct config_item *item,
 		unregister_netcons_consoles();
 	}
 
-	ret = strnlen(buf, count);
+	ret = count;
 	/* Deferred cleanup */
 	netconsole_process_cleanups();
 out_unlock:
@@ -781,7 +781,7 @@ static ssize_t release_store(struct config_item *item, const char *buf,
 
 	nt->release = release;
 
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -807,7 +807,7 @@ static ssize_t extended_store(struct config_item *item, const char *buf,
 		goto out_unlock;
 
 	nt->extended = extended;
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -830,7 +830,7 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 	trim_newline(nt->np.dev_name, IFNAMSIZ);
 
 	dynamic_netconsole_mutex_unlock();
-	return strnlen(buf, count);
+	return count;
 }
 
 static ssize_t local_port_store(struct config_item *item, const char *buf,
@@ -849,7 +849,7 @@ static ssize_t local_port_store(struct config_item *item, const char *buf,
 	ret = kstrtou16(buf, 10, &nt->np.local_port);
 	if (ret < 0)
 		goto out_unlock;
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -871,7 +871,7 @@ static ssize_t remote_port_store(struct config_item *item,
 	ret = kstrtou16(buf, 10, &nt->np.remote_port);
 	if (ret < 0)
 		goto out_unlock;
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -896,7 +896,7 @@ static ssize_t local_ip_store(struct config_item *item, const char *buf,
 		goto out_unlock;
 	nt->np.ipv6 = !!ipv6;
 
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -921,7 +921,7 @@ static ssize_t remote_ip_store(struct config_item *item, const char *buf,
 		goto out_unlock;
 	nt->np.ipv6 = !!ipv6;
 
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -957,7 +957,7 @@ static ssize_t remote_mac_store(struct config_item *item, const char *buf,
 		goto out_unlock;
 	memcpy(nt->np.remote_mac, remote_mac, ETH_ALEN);
 
-	ret = strnlen(buf, count);
+	ret = count;
 out_unlock:
 	dynamic_netconsole_mutex_unlock();
 	return ret;
@@ -1133,7 +1133,7 @@ static ssize_t sysdata_msgid_enabled_store(struct config_item *item,
 		disable_sysdata_feature(nt, SYSDATA_MSGID);
 
 unlock_ok:
-	ret = strnlen(buf, count);
+	ret = count;
 	dynamic_netconsole_mutex_unlock();
 	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
@@ -1162,7 +1162,7 @@ static ssize_t sysdata_release_enabled_store(struct config_item *item,
 		disable_sysdata_feature(nt, SYSDATA_RELEASE);
 
 unlock_ok:
-	ret = strnlen(buf, count);
+	ret = count;
 	dynamic_netconsole_mutex_unlock();
 	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
@@ -1191,7 +1191,7 @@ static ssize_t sysdata_taskname_enabled_store(struct config_item *item,
 		disable_sysdata_feature(nt, SYSDATA_TASKNAME);
 
 unlock_ok:
-	ret = strnlen(buf, count);
+	ret = count;
 	dynamic_netconsole_mutex_unlock();
 	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
@@ -1225,7 +1225,7 @@ static ssize_t sysdata_cpu_nr_enabled_store(struct config_item *item,
 		disable_sysdata_feature(nt, SYSDATA_CPU_NR);
 
 unlock_ok:
-	ret = strnlen(buf, count);
+	ret = count;
 	dynamic_netconsole_mutex_unlock();
 	mutex_unlock(&netconsole_subsys.su_mutex);
 	return ret;
-- 
2.53.0



