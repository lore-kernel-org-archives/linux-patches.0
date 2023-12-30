Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5684F8487;
	Sat, 30 Dec 2023 12:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVussldi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B19C433C8;
	Sat, 30 Dec 2023 12:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937655;
	bh=KZ1RYs+eIXAq1DADaGMUr2TBrge+dtsEqGrvy678qmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVussldizE17q0ej5fvK2TJ2/v4GK+M1MAzxO3iSMW8pMvUSybvQpdJLVT+iGpnka
	 DfxkYlj0bMBN5HBnBrDwxXwlM72SQilLpjOeAY/nJuyKd6UTs17o2eD4EFKvCDN18v
	 wNpmQyVf2CWQrejg9wy4VhQ/GHrx0iNamDznrFOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingkai Dong <lingkai.dong@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/156] drm: Fix FD ownership check in drm_master_check_perm()
Date: Sat, 30 Dec 2023 11:57:46 +0000
Message-ID: <20231230115812.783250269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingkai Dong <Lingkai.Dong@arm.com>

[ Upstream commit 5a6c9a05e55cb2972396cc991af9d74c8c15029a ]

The DRM subsystem keeps a record of the owner of a DRM device file
descriptor using thread group ID (TGID) instead of process ID (PID), to
ensures all threads within the same userspace process are considered the
owner. However, the DRM master ownership check compares the current
thread's PID against the record, so the thread is incorrectly considered to
be not the FD owner if the PID is not equal to the TGID. This causes DRM
ioctls to be denied master privileges, even if the same thread that opened
the FD performs an ioctl. Fix this by checking TGID.

Fixes: 4230cea89cafb ("drm: Track clients by tgid and not tid")
Signed-off-by: Lingkai Dong <lingkai.dong@arm.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v6.4+
Link: https://patchwork.freedesktop.org/patch/msgid/PA6PR08MB107665920BE9A96658CDA04CE8884A@PA6PR08MB10766.eurprd08.prod.outlook.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 2ed2585ded378..6899b3dc1f12a 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -236,7 +236,7 @@ static int
 drm_master_check_perm(struct drm_device *dev, struct drm_file *file_priv)
 {
 	if (file_priv->was_master &&
-	    rcu_access_pointer(file_priv->pid) == task_pid(current))
+	    rcu_access_pointer(file_priv->pid) == task_tgid(current))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN))
-- 
2.43.0



