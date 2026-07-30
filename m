Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC95031E833;
	Thu, 30 Jul 2026 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422505; cv=none; b=akeUh23NwwyNSozamW2s1xM+DfujrQanQaXOaXFcZ5WDnebzlwHBYzCQFIVcaVvltT8kvMM9/FDFUMAUG3Ujk7G0pM4moNsJd5KdH4tSjSYrPTP6RGJRcKjqDYJmp/VnboNS5Sd4tIGlrQkdna8VSSXzVdxlLX/eMKBsN1hkn9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422505; c=relaxed/simple;
	bh=kt8SnNB0qLxwLUR1BjGSYvJHEJYf4gIhWN4RmjUWdRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv9l3yC+ausAGcjcWpimrCcACDo9FmPWBvSd6H89tQd5qvdbR6//At03nQ+/hj3CulsM3CF9xiqBnGGbak6xLW2/Nk9KvY1rYxDg6/LghjpfUcTyHF0t3vobaq16ziAYzNR7ilL1UOSxHQz6qZJZtYohj1HXnqaBvr9CfO8DyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty9i2k2L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty9i2k2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E381F000E9;
	Thu, 30 Jul 2026 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422504;
	bh=ZMEDCLgdUmLPPE8YnmsQ1ScbYfFCrdAk9VqEvsWOsKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ty9i2k2LoC/PhD3uu/7IyCKyrQ1v+0MW8ODNr/pWPfpIKzJVdHTkV4sSi9yZ0q3yG
	 oeoJRpDTCs1mH0jGUtes/F8nbh8HXZNBrgRrEoOx9Rn6NdbL859MsnQZKv8wi94qnL
	 ynSvC4sl32m60FjKwU3embpE4mwm5dEhR2Qob6U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 417/744] drm/amdkfd: free MQD managers on DQM init failures
Date: Thu, 30 Jul 2026 16:11:30 +0200
Message-ID: <20260730141453.160233152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit b240f792ae02e9b687eafff934a39e57d1e45365 upstream.

The change referenced by the Fixes tag releases the HIQ SDMA MQD trunk
buffer when device_queue_manager_init() fails after it has been
allocated.

However, the same failure path can also be reached after
init_mqd_managers() has succeeded. At that point dqm->mqd_mgrs[] contains
per-type MQD manager objects owned by the device queue manager. The
normal teardown path frees those objects from uninitialize(), but the
initialization error path only frees dqm itself.

Free the MQD managers from the initialization error path as well. This is
safe for earlier failures because dqm is zeroed when allocated and
init_mqd_managers() clears the entries it rolls back internally.

Fixes: b7cccc8286bb ("drm/amdkfd: fix a memory leak in device_queue_manager_init()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1fff2e07b6670bc5b8f7344a8708c136259cb176)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2936,6 +2936,7 @@ static void deallocate_hiq_sdma_mqd(stru
 struct device_queue_manager *device_queue_manager_init(struct kfd_node *dev)
 {
 	struct device_queue_manager *dqm;
+	int i;
 
 	pr_debug("Loading device queue manager\n");
 
@@ -3062,6 +3063,9 @@ struct device_queue_manager *device_queu
 		deallocate_hiq_sdma_mqd(dev, &dqm->hiq_sdma_mqd);
 
 out_free:
+	for (i = 0; i < KFD_MQD_TYPE_MAX; i++)
+		kfree(dqm->mqd_mgrs[i]);
+
 	kfree(dqm);
 	return NULL;
 }


