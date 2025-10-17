Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C923328FF;
	Fri, 17 Oct 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715524; cv=none; b=S+6OZ4yuucbLFYNXXCHwGjNsibkSLvLl1Uttxc/0c45na0pihOizKls0X7HNRmvINkaihZavD7CjW06gFRrs1f6fdHC6rRSGXBwpoc++jagY0/QCkZra6I+egCgG1S3hKWzxYRshgu/HumDe+k/cn/QmCIm5OZ9yL4tpWOrIfEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715524; c=relaxed/simple;
	bh=KwQqcPvm49go1jJmQ+E2OuxSOpyP7TIXshz40f6AIlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQlb4XiqWgLz0fu22a6W4M/toPSdttFPtU1IP5ihKjlQ3bZWHDpCgDpKdWWYwRHF6eq3z/Poze5JTmtAfMjYxiVH5fttm0eLh63wpcFbhB7xMAl/cHVjwvXIObwsUcuyPRTBBsBevR6MDU/0eSWwpaExfV0hbslJ+gMTTDMzGvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de1FLYSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de1FLYSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12811C4CEE7;
	Fri, 17 Oct 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715524;
	bh=KwQqcPvm49go1jJmQ+E2OuxSOpyP7TIXshz40f6AIlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de1FLYSV6wZeaOfPWRfh+fsni5kkKCQgelOA8g/igpRan5wemPK2Az0yDMHci5oS7
	 XRwpW+EtGP52YnO/72LWWOwzmTuxVut+gJrZPbqi6pPzWfev8DYnVlVjHM/Pxd5Tec
	 YU+Q/Nr6lYCGVIKemyxeZD3UE/riMfdedFim2ce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.17 247/371] PM: hibernate: Restrict GFP mask in power_down()
Date: Fri, 17 Oct 2025 16:53:42 +0200
Message-ID: <20251017145211.015805476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 6f4c6f9ed4ce65303f6bb153e2afc71bc33c8ded upstream.

Commit 12ffc3b1513e ("PM: Restrict swap use to later in the
suspend sequence") caused hibernation_platform_enter() to call
pm_restore_gfp_mask() via dpm_resume_end(), so when power_down()
returns after aborting hibernation_platform_enter(), it needs
to match the pm_restore_gfp_mask() call in hibernate() that will
occur subsequently.

Address this by adding a pm_restrict_gfp_mask() call to the relevant
error path in power_down().

Fixes: 12ffc3b1513e ("PM: Restrict swap use to later in the suspend sequence")
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -722,6 +722,8 @@ static void power_down(void)
 	case HIBERNATION_PLATFORM:
 		error = hibernation_platform_enter();
 		if (error == -EAGAIN || error == -EBUSY) {
+			/* Match pm_restore_gfp_mask() in hibernate(). */
+			pm_restrict_gfp_mask();
 			swsusp_unmark();
 			events_check_enabled = false;
 			pr_info("Wakeup event detected during hibernation, rolling back.\n");


