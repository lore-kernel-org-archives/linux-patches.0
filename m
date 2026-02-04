Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3919E96D;
	Wed,  4 Feb 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219068; cv=none; b=F29fyXvxiwq+nJP8YcrsR4qeJMaQrhaZQBvlDvwyY5EnUqJasMlA1PSpUZwKQPGxJHe1dNSlrO890ZBc5PQvFKj5SW12D65+DR2XdBARaMfQ/FkH5tlmgrjSTlZYWMhGeCxMRUVSyaj3F8eSSj830Q8i5N2doBUS2H4LceVwM6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219068; c=relaxed/simple;
	bh=BTAIEYbota6cAdxQoS/Cq+00w/Zt0Rb3z3Aao+7tKDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7sscQrZvKi0zYUQB8tgMHlWt5EtSAkZF9fuK2J4ya7kcghIS9lCedq18KVeNbBGABsp/OXsS8ihb/+GbDLtMp7Rys+dZ0XTi+yC9Czp+EqAw3vdOlDPIO9nJO2Wq7zXYlrTqHh7kbOHwbosjU+Un0wey9QmjWBHzkx3gQIvD1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIzxO3/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIzxO3/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560A1C4CEF7;
	Wed,  4 Feb 2026 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219067;
	bh=BTAIEYbota6cAdxQoS/Cq+00w/Zt0Rb3z3Aao+7tKDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIzxO3/Eo/T/URQYtUDISRhSoXfJP1+BgyTG0ooHbTZYIi+6VNPoXsBOj8NiRhivV
	 MDx9gF1AMf8oaYKPcVTePteZcSOWktRVdpsoNtUpvZB0zJHAvrYVVMnfUbAWKlx1YE
	 3ZA7zDbFw6T+6WpEqOiGQ6twI8uAAkmAXx7OFHSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Brian Nguyen <brian3.nguyen@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/122] drm/xe/nvm: Fix double-free on aux add failure
Date: Wed,  4 Feb 2026 15:40:38 +0100
Message-ID: <20260204143853.870156993@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 8a44241b0b83a6047c5448da1fff03fcc29496b5 ]

After a successful auxiliary_device_init(), aux_dev->dev.release
(xe_nvm_release_dev()) is responsible for the kfree(nvm). When
there is failure with auxiliary_device_add(), driver will call
auxiliary_device_uninit(), which call put_device(). So that the
.release callback will be triggered to free the memory associated
with the auxiliary_device.

Move the kfree(nvm) into the auxiliary_device_init() failure path
and remove the err goto path to fix below error.

"
[   13.232905] ==================================================================
[   13.232911] BUG: KASAN: double-free in xe_nvm_init+0x751/0xf10 [xe]
[   13.233112] Free of addr ffff888120635000 by task systemd-udevd/273

[   13.233120] CPU: 8 UID: 0 PID: 273 Comm: systemd-udevd Not tainted 6.19.0-rc2-lgci-xe-kernel+ #225 PREEMPT(voluntary)
...
[   13.233125] Call Trace:
[   13.233126]  <TASK>
[   13.233127]  dump_stack_lvl+0x7f/0xc0
[   13.233132]  print_report+0xce/0x610
[   13.233136]  ? kasan_complete_mode_report_info+0x5d/0x1e0
[   13.233139]  ? xe_nvm_init+0x751/0xf10 [xe]
...
"

v2: drop err goto path. (Alexander)

Fixes: 7926ba2143d8 ("drm/xe: defer free of NVM auxiliary container to device release callback")
Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Brian Nguyen <brian3.nguyen@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Suggested-by: Brian Nguyen <brian3.nguyen@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260120183239.2966782-7-shuicheng.lin@intel.com
(cherry picked from commit a3187c0c2bbd947ffff97f90d077ac88f9c2a215)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_nvm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_nvm.c b/drivers/gpu/drm/xe/xe_nvm.c
index 1fff24dbc7cd4..6da42b2b5e467 100644
--- a/drivers/gpu/drm/xe/xe_nvm.c
+++ b/drivers/gpu/drm/xe/xe_nvm.c
@@ -153,19 +153,17 @@ int xe_nvm_init(struct xe_device *xe)
 	ret = auxiliary_device_init(aux_dev);
 	if (ret) {
 		drm_err(&xe->drm, "xe-nvm aux init failed %d\n", ret);
-		goto err;
+		kfree(nvm);
+		xe->nvm = NULL;
+		return ret;
 	}
 
 	ret = auxiliary_device_add(aux_dev);
 	if (ret) {
 		drm_err(&xe->drm, "xe-nvm aux add failed %d\n", ret);
 		auxiliary_device_uninit(aux_dev);
-		goto err;
+		xe->nvm = NULL;
+		return ret;
 	}
 	return devm_add_action_or_reset(xe->drm.dev, xe_nvm_fini, xe);
-
-err:
-	kfree(nvm);
-	xe->nvm = NULL;
-	return ret;
 }
-- 
2.51.0



