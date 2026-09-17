Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE7C3A963E;
	Thu, 17 Sep 2026 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661361; cv=none; b=FD6BWTt36XZEoh0H8//7vUKWmCI8Figj2r51TnsYK3pX15QzwAQ4t1ijOj1LnLGXKXiAOyGpPXmzRQG/ykee12ljdEOjf/PNreZrpa+TAbkAbpgP8JPH/4K5tXz/pt3z+TCMGRi0LhdVRC5NUrmX7MIEpSunAGpmnYA5XX30EDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661361; c=relaxed/simple;
	bh=cn001aqcBpbm1vWA81idB47Re1xOcLk+qFryRPsI2yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XphauV9gYXJMtjQhcrFu3NfGXNeeaoFjKMWPq1i12SgFkZpkeMKztFWS5hfh6uJ822aN1HnG8jPNsMe3MXDxdN87GJK6NWftOR4srsXvPj/0wrkDLmc8TffL6aav+lumCA0o3WGIwgKMHGaT6x+BDd9SBrt8bIjSli1ERnTOaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4fYmbJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4fYmbJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36C81F000FF;
	Thu, 17 Sep 2026 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661359;
	bh=eel8VfPaMqokNenMI3pLDsVXOIjV0cVnnE6vpHGeMNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4fYmbJ0WfiDc9OVtyVgRy6S2UwfaMYDNXuP9p47oeCKNdgO/e0y/tjI+qnIkQ7U+
	 4BjMvQBU9zmZHG1/3Exg4qim6bJkLyCjie4ubEfK1TUssQ4sH/G4Vej2Irx8XUVL2h
	 CrZAPJxup7vfChCQZoQsRA6LW8J2w7UEeZx2X8O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Leach <matthew.leach@collabora.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0167/1250] PM: hibernate: call preallocate_image() after freeze prepare
Date: Thu, 17 Sep 2026 15:59:22 +0100
Message-ID: <20260917151556.616977299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Matthew Leach <matthew.leach@collabora.com>

[ Upstream commit 783c8109844503bd1c35dab41b6d5fd074a9f131 ]

Certain drivers release resources (pinned pages, etc.) into system
memory during the prepare freeze PM op, making them swappable.
Currently, hibernate_preallocate_memory() is called before prepare
freeze, so those drivers have no opportunity to release resources
first. If a driver is holding a large amount of unswappable system
RAM, this can cause hibernate_preallocate_memory() to fail.

Move the call to hibernate_preallocate_memory() after prepare freeze.

According to the documentation for the prepare callback, devices should
be left in a usable state, so storage drivers should still be able to
service I/O requests. This allows drivers to release unswappable
resources prior to preallocation, so they can be swapped out through
hibernate_preallocate_memory()'s reclaim path.

Also remove shrink_shmem_memory() since hibernate_preallocate_memory()
will have reclaimed enough memory for the hibernation image.

Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
[ rjw: Subject and changelog tweaks ]
Link: https://patch.msgid.link/20260403-hibernation-fixes-v3-1-31bc9fa3ba2d@collabora.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 46 ++++++++--------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 26e45f86b9554..26289e3c28ae7 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -392,23 +392,6 @@ static int create_image(int platform_mode)
 	return error;
 }
 
-static void shrink_shmem_memory(void)
-{
-	struct sysinfo info;
-	unsigned long nr_shmem_pages, nr_freed_pages;
-
-	si_meminfo(&info);
-	nr_shmem_pages = info.sharedram; /* current page count used for shmem */
-	/*
-	 * The intent is to reclaim all shmem pages. Though shrink_all_memory() can
-	 * only reclaim about half of them, it's enough for creating the hibernation
-	 * image.
-	 */
-	nr_freed_pages = shrink_all_memory(nr_shmem_pages);
-	pr_debug("requested to reclaim %lu shmem pages, actually freed %lu pages\n",
-			nr_shmem_pages, nr_freed_pages);
-}
-
 /**
  * hibernation_snapshot - Quiesce devices and create a hibernation image.
  * @platform_mode: If set, use platform driver to prepare for the transition.
@@ -425,14 +408,9 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
-	/* Preallocate image memory before shutting down devices. */
-	error = hibernate_preallocate_memory();
-	if (error)
-		goto Close;
-
 	error = freeze_kernel_threads();
 	if (error)
-		goto Cleanup;
+		goto Close;
 
 	if (hibernation_test(TEST_FREEZER)) {
 
@@ -445,19 +423,13 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
-	if (error) {
-		dpm_complete(PMSG_RECOVER);
-		goto Thaw;
-	}
+	if (error)
+		goto Complete;
 
-	/*
-	 * Device drivers may move lots of data to shmem in dpm_prepare(). The shmem
-	 * pages will use lots of system memory, causing hibernation image creation
-	 * fail due to insufficient free memory.
-	 * This call is to force flush the shmem pages to swap disk and reclaim
-	 * the system memory so that image creation can succeed.
-	 */
-	shrink_shmem_memory();
+	/* Preallocate image memory before shutting down devices. */
+	error = hibernate_preallocate_memory();
+	if (error)
+		goto Complete;
 
 	console_suspend_all();
 	pm_restrict_gfp_mask();
@@ -492,10 +464,10 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
+ Complete:
+	dpm_complete(PMSG_RECOVER);
  Thaw:
 	thaw_kernel_threads();
- Cleanup:
-	swsusp_free();
 	goto Close;
 }
 
-- 
2.53.0



