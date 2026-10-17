Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FFA3A4F58;
	Sat, 17 Oct 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256462; cv=none; b=gONkKgDNAeHwtbrI7ZGdWLdw2/9PMZIekFMKrWoNqjUYt4PbM/hQiK++wjyl5yFhs38piEZgsIUDzU/SiGY4z+y9uhppE2EnBRYSKHXVgNInIXLcH92hmOVZjGcpPzvurXbx/AmeXEUu8bIYLqIg0EdtZ2IR4+9Uyv9VWrQs0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256462; c=relaxed/simple;
	bh=JGuJa0zGeZtkY6E4ABa03GIsTl/ufVdl33wN1bgyf8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwRFC7BPryN50TKa/27SwO6k6OnOfp5pyBGn77LIOFuCbonebnmrSnYFLJn7IRD4/r9UMJaeRUTWsgKmLXPCb1spKGpFnVajc+V+qdtrcoIy/BlQ8eF2zKjDHd/r+Bet/tKqgRxQ6piOUtEIV7t4msoP/hATKkkmEx9YNk7c5PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S55dWjuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S55dWjuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53711F000C4;
	Sat, 17 Oct 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256461;
	bh=mDAz0oRIxxZIksrQwqHpMW5zuCLVl6GzI7BfVIIgh/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S55dWjuIY++mMLGd6Lx9j2jcPjJJawv98R0cFql3oOR+P/fVWMM6QJtDh3+go5rGe
	 SsL/0M/brddm0YeiaQZSXXcRrbLVu7feLIyrkTU37IYLS1KynKnSS0xL4cdw/EGlE7
	 UU2HR3n8OQvPOLyyYkLDEK7qC+sPAvyjvxwFWl4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0243/1674] drm/amdgpu: fix IP instance memory leak on kobject add failure
Date: Sat, 17 Oct 2026 17:41:55 +0200
Message-ID: <20261017160437.368022920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -1033,6 +1033,8 @@ static int amdgpu_discovery_sysfs_ips(st
 			ip_hw_instance->kobj.kset = &ip_hw_id->hw_id_kset;
 			res = kobject_add(&ip_hw_instance->kobj, NULL,
 					  "%d", ip_hw_instance->num_instance);
+			if (res)
+				kobject_put(&ip_hw_instance->kobj);
 next_ip:
 			if (reg_base_64)
 				ip_offset += struct_size(ip, base_address_64,


