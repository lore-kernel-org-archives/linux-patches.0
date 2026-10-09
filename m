Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE03BB112;
	Fri,  9 Oct 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556571; cv=none; b=ApGG+5LI92qRaVpijlKa5KRBLQt8IhqiEfKz9+n/Gbh9/VPTyodc5jdXGYh5557F3pdbJgeTy4qoKQ4x6n85bmecqz/i1voZul3DWGbTAh4gSz+Tn9X9450+s1bqtnZx1sNyQu9r+igPjUU8ihgPffXoWT/3827a4RmRz6z0cJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556571; c=relaxed/simple;
	bh=MekKFVFJZi3CsBFby8S5l7wH+Dfxvmj35gbXpLToIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPHROj/rwqIqgP8BWm8h267N2UyoEPXjWnxPFHyhV+ijiPCV5yJR1+6P8LsgiJQcDHaktO/3ZkbjYbttWov9QLGkSv9uhm3qmdfkcDTsibQD5PiL+JEoiVE1K4ICfg+C1AsXiWx/fZJQb7AiB5flAJyP1jzX66zY7zNj17njJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0noNM2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0noNM2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867841F000FF;
	Fri,  9 Oct 2026 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556570;
	bh=N1AiFfEqZfCishlL8jEbVqQi5Q8zLwEwtuvLKMpTEp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0noNM2vHKq6W63Da2RvVn3t10FLmr0G+FqFLXgpOY/yVveYNkpz0tNMTTmT3Z3D9
	 vv+Yy8kOmYvG9MznIRbc/SaHdKSfLigooqYIt+XSuhq0ynt7Fgm+EuFgjaKE9ehuQS
	 ACYJlganR8FuO6myj93OYebeMgpJO8liBIR454gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 185/428] drm/amdgpu: fix IP instance memory leak on kobject add failure
Date: Fri,  9 Oct 2026 16:08:42 +0200
Message-ID: <20261009140950.208808339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f5a5add3605935163dd0f75749b6a7869e9765af upstream.

amdgpu_discovery_sysfs_ips() allocates ip_hw_instance with
kzalloc_flex() and initializes its embedded kobject before calling
kobject_add().

If kobject_add() fails, the return value is ignored and execution
continues without dropping the initial kobject reference. The failed
kobject is not retained in the kset list, so the normal sysfs teardown
path cannot find it. As a result, ip_hw_instance_release() is never
called and the ip_hw_instance allocation is leaked.

Call kobject_put() when kobject_add() fails so the initial reference is
dropped and ip_hw_instance_release() can free the allocation. Keep the
existing best-effort sysfs behavior by continuing with the remaining IP
entries after the failed registration.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: a6c40b178092 ("drm/amdgpu: Show IP discovery in sysfs")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5c75fbcca8af1096d8d9415b91d8ea6212c22ee1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1270,6 +1270,8 @@ static int amdgpu_discovery_sysfs_ips(st
 			ip_hw_instance->kobj.kset = &ip_hw_id->hw_id_kset;
 			res = kobject_add(&ip_hw_instance->kobj, NULL,
 					  "%d", ip_hw_instance->num_instance);
+			if (res)
+				kobject_put(&ip_hw_instance->kobj);
 next_ip:
 			if (reg_base_64)
 				ip_offset += struct_size(ip, base_address_64,


