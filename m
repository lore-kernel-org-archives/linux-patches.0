Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0B4403AEA;
	Tue, 21 Jul 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654382; cv=none; b=Ew2FM9tRSG/mFHIA93erbSvi4HezNl2ABodmLM/EO8Umc1Vg2AJJ7RNB/jd0RC5ixb2XXuM89ZAbVBFLv8rx+7dDMb1YOtkLgISHKJ39xqQcq6HVtIIU10qY4neJecvuoZukO2McubtJ4+/ReckSkkDzKq8rEJe7tj5bSOb0p8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654382; c=relaxed/simple;
	bh=uhNH4NelCpbkIgdZwC8SJMrwiVc+cnn992ebej8o59k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KmPv82D/TPtEymgX0dCDNRDeoCMu9I92f8URNBuy4sNtiWEJVHpQq7d9+MU/0ImtflN48cvI9iUqK7fTJSWjlHuadYjgyp4klZDSO9WX+RisBP4najNH7mJ4twregkYl8GIeBk/Lv9XMz7FfjNdeN2sXNxNU3yirwy6B/NxOsIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x3eVH/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x3eVH/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992871F000E9;
	Tue, 21 Jul 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654381;
	bh=Bb3GMZD9Ys66W/F8DwIR2AouO9Aa2pSnBwOA7qt76Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0x3eVH/EEpRLcK+v40QwMbDs32B+Q9AyM3A6t8c2zakh8ValY0NGLqJ+dA2ycRT9V
	 tKwjP8AgCjYHE4XKDFXZMDPF66QjNC3ADxwu/MrxJiAhkJRYThYJmI26rzq0HehJIU
	 uikSCk0v1ewYLR9rht4Zv5KJq7kwi6+zlVnzp1wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1683/2077] ntfs: Add WQ_PERCPU to alloc_workqueue users
Date: Tue, 21 Jul 2026 17:22:36 +0200
Message-ID: <20260721152632.446052539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

commit 38e8db370843b518ff9bee4af46c6b800684cc78 upstream.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

  commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
  commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Cc: stable@vger.kernel.org # v7.1
Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2656,7 +2656,7 @@ MODULE_ALIAS_FS("ntfs");
 
 static int ntfs_workqueue_init(void)
 {
-	ntfs_wq = alloc_workqueue("ntfs-bg-io", 0, 0);
+	ntfs_wq = alloc_workqueue("ntfs-bg-io", WQ_PERCPU, 0);
 	if (!ntfs_wq)
 		return -ENOMEM;
 	return 0;


