Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D51433BE;
	Tue, 14 May 2024 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682374; cv=none; b=J78EAaAiH8Ug72aHhCtO00Mr75yFbXYj2UTzgHtACtPATH45HPdobj6dk80aL0hbHGTzGXNFWfhK4gBT/yBujWa9V3nc+xlcGuwKk/k69zBXMhAbF6GsEqGpPznUr0la5HR2IkdPlNhO9mSjfpqmlX960SZLKU6aT9KwgxN+twM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682374; c=relaxed/simple;
	bh=FETMME7ZVBDtrB4Fsj6bwJhoDbYgSLpOzGLKYpjIVMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzHuyecH5A4TrhwfdWnuH8Pg3e/FMPPmk8/EIr1UFT9fiEKkFJvZW3ecMT4Vz9NPuXXIvhnwteXtW6IPGFFo9dN4lzep+t4ak0P90ORHqaWi5DXkNsBKnR4HVm2LLbTJwYKJCIRHY096dvUrkrMU8WlT7W65oCQK5V9Zmu5k0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+bMdI7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+bMdI7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4962C2BD10;
	Tue, 14 May 2024 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682374;
	bh=FETMME7ZVBDtrB4Fsj6bwJhoDbYgSLpOzGLKYpjIVMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+bMdI7j2X/QtCxAUzIDJP9qAVXm/Ou9cpxTz+eHg9u5K0fNf+iYzoiHTwyx7xZEy
	 xT3s9jUfyEMxP+EE2KvBnYuYM/j6mZbrVIK0S+smxPkicJ/zJ1hyRVjv4Ymn1FNdDV
	 Hy69kPusIku6NBpZDxleUMabUlRs+/vY4LUXTcv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 050/336] thermal/debugfs: Prevent use-after-free from occurring after cdev removal
Date: Tue, 14 May 2024 12:14:14 +0200
Message-ID: <20240514101040.495860586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d351eb0ab04c3e8109895fc33250cebbce9c11da ]

Since thermal_debug_cdev_remove() does not run under cdev->lock, it can
run in parallel with thermal_debug_cdev_state_update() and it may free
the struct thermal_debugfs object used by the latter after it has been
checked against NULL.

If that happens, thermal_debug_cdev_state_update() will access memory
that has been freed already causing the kernel to crash.

Address this by using cdev->lock in thermal_debug_cdev_remove() around
the cdev->debugfs value check (in case the same cdev is removed at the
same time in two different threads) and its reset to NULL.

Fixes: 755113d76786 ("thermal/debugfs: Add thermal cooling device debugfs information")
Cc :6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index 1fe2914a8853b..5693cc8b231aa 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -505,15 +505,23 @@ void thermal_debug_cdev_add(struct thermal_cooling_device *cdev)
  */
 void thermal_debug_cdev_remove(struct thermal_cooling_device *cdev)
 {
-	struct thermal_debugfs *thermal_dbg = cdev->debugfs;
+	struct thermal_debugfs *thermal_dbg;
 
-	if (!thermal_dbg)
+	mutex_lock(&cdev->lock);
+
+	thermal_dbg = cdev->debugfs;
+	if (!thermal_dbg) {
+		mutex_unlock(&cdev->lock);
 		return;
+	}
+
+	cdev->debugfs = NULL;
+
+	mutex_unlock(&cdev->lock);
 
 	mutex_lock(&thermal_dbg->lock);
 
 	thermal_debugfs_cdev_clear(&thermal_dbg->cdev_dbg);
-	cdev->debugfs = NULL;
 
 	mutex_unlock(&thermal_dbg->lock);
 
-- 
2.43.0



