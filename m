Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEFE4F3939;
	Tue, 13 Oct 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894984; cv=none; b=oxo2bmyutpKNh9yjbqwK4jH2tB2VAkb0uwPS+hb860ZeEwqK6Stm7sfPaqBkOXkGDvYYghRzjU0BGR5RDafn8Ii4KEk2xTwqOm39kmLVSy55SHjqjs6hSaJ2N4hCAzrEFobUl6L+KOeH1W9cIdJru+4whGKBZSmo40j+aK+VCa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894984; c=relaxed/simple;
	bh=jj42+RMO/Ro1dxivJJosoYa8xSx9fCmnZB4FyU9tKyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5yFJzPjS3BZaFHcoKcjYg26RDF74SHf3Ko+xRJW4DmEDNTKcsoSSloeN26OFiJFiEUKiAuH7w8ddIh3D9lAD88wTPUkhtCOqf8cDmwdX7GbyQ+tJo9IE26wSV/iTMNw/YYwjccm8fH3tYfj41GTgnszar+2IDHM57KUPz0Mv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtTl1VZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtTl1VZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960BC1F00893;
	Tue, 13 Oct 2026 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894983;
	bh=du+O3VnjaBdfWrcScRv4k6LuxfFo/A+EXaR7QYKPTVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtTl1VZSabwXhMt0i+MpvTC7BSDcgW6F0/01hY4+tWc0UBy2k4685CIVahr8LP156
	 rXGyunMaruKqlzTG/L+tve8fo+/bSiSJVZtFKfZRbkMQU/z/cPci/oPAv58OWFCv/b
	 hBjIDskr3gtEy/4a8mnxaDZ6G36xjL/UiUc6ncaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 121/497] drm/amdgpu: fix IP instance memory leak on kobject add failure
Date: Tue, 13 Oct 2026 13:34:48 +0200
Message-ID: <20261013112910.763912029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1130,6 +1130,8 @@ static int amdgpu_discovery_sysfs_ips(st
 			ip_hw_instance->kobj.kset = &ip_hw_id->hw_id_kset;
 			res = kobject_add(&ip_hw_instance->kobj, NULL,
 					  "%d", ip_hw_instance->num_instance);
+			if (res)
+				kobject_put(&ip_hw_instance->kobj);
 next_ip:
 			if (reg_base_64)
 				ip_offset += struct_size(ip, base_address_64,


