Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6733B3C03;
	Wed, 30 Sep 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793408; cv=none; b=mbPCKdbpH8L5s/a2YHjLwCWIvI7nYxe91m6v2+7OnhiFLHDrDm1wsDe6V/uwktjVYAcwMmRwhaiDVkLfr0NvCeqaffiKnhebhCdXQDVkASApykbPkk05GYq8Bu6iW/plezJQhcT2wAfFqkem2rKf7Pm74xyShz5nPFk7brPYg2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793408; c=relaxed/simple;
	bh=tTUptYSRD6ANwOnU4M4/zjJUaJl6Or3KC+wkG0vuXS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTdwfbOqECnIXc9RwmQ/D6hsvyhtvy4BEIq5mXk04FizwOdoefiFhiVommvmalm2nzjpzhglR+ygpKI/iYBXUi9wtn5mmeBZgPtnM3IJgQuzACQWirejo34ayZA8Aa4LFYYYqtQy0lJo72VcOuF6k6hlIb0NDUsRdefFkmU8/EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvbLeOo5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvbLeOo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F0D1F000FF;
	Wed, 30 Sep 2026 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793406;
	bh=aqKZjFjNoBAoFWwrHiBAjHHRfhlE/K3hglUQdtVd6dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvbLeOo5QLlV4ofAehme/BbHKHZfQM9dtDyr7HrMGTsUwenN/YbAjKRblIZnshHHM
	 kTyvdH+9ppYRwVqlnU1fmPaWJgbr9k3l7WbGY0zIby51wPmk41TJx7TaKlriLBtZ7f
	 kBoGuY47hWwhDCEOcmJgZanOqTY1binBzNAWyX58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 244/395] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 30 Sep 2026 17:28:26 +0200
Message-ID: <20260930152345.948430488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 2b86ab1bd6673c525adda88819d7658ba9e784ec upstream.

amdgpu_debugfs_test_ib_show() resumes the device with
pm_runtime_get_sync() before taking the reset domain semaphore with
down_write_killable().  If the write lock acquisition is interrupted,
the function returns without calling pm_runtime_put_autosuspend(),
leaking the runtime PM reference acquired for the device and keeping
the GPU awake.

Drop the runtime PM reference on the interrupted down_write_killable()
error path before returning.

Fixes: 6049db43d6dd ("drm/amdgpu: change reset lock from mutex to rw_semaphore")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ec30a576c2d4c0364549e6c04218f50704ef56c8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1671,8 +1671,10 @@ static int amdgpu_debugfs_test_ib_show(s
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_write_killable(&adev->reset_domain->sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {


