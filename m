Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8769230E855;
	Wed, 25 Feb 2026 06:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002708; cv=none; b=HbgNKZH996mYoGUqY5FUPm9vMXdLxZdICDXVJ+bQgbvm6ORybS+4nY4KpBT+XOTUNH+muJ51jCuFjwee5bXUU068JlDI8WHja0g3dGNv9qnyfum5LSGa8OCwFhuwwt9QK+wLdW9KhQ1oQVKJwBLHIg3dmXP0bWRqcoRPZyO891M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002708; c=relaxed/simple;
	bh=XnsbEzyKI+ZDxhwR3IraOGN3FPULirJxZ8q/vFaJ/vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeoZul0oGwwhMBq/XW5f9U80H3Cp0dgvkx36WCxOV9ZawJO/XBJruc63DXPHcORk/2+7u2S3hHYswSKXTnzw6vrPYuwnteLLY3+cF57cG9U9iA52l51UPW6l+xzNJusHCKd52UHN76B0EdiwH7eKkYDdk8AWdcC5Gn5zYgeOMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/pO1rBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/pO1rBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E28C116D0;
	Wed, 25 Feb 2026 06:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002708;
	bh=XnsbEzyKI+ZDxhwR3IraOGN3FPULirJxZ8q/vFaJ/vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/pO1rBSIbgEagKdrKELO34VxNz8a5RIu618uH20HPyovKDznK5eYjGBU58GfG9A2
	 PwcWbD+6zCvmTQ3Q9lnslB8j+/VleVwOfQ/KXMShmB+P+aaPg7V7cIRaO42xONTyRO
	 Tck2389OblgOIgUnu8dB1ZPqGpVrWBobAKFIggLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/641] cpuidle: Skip governor when only one idle state is available
Date: Tue, 24 Feb 2026 17:23:55 -0800
Message-ID: <20260225012400.858957687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
Message-ID: <20260225012355.YHhrI928UUScP9sU-Cx30O_NJYFYPF1ElJ_K-KrXzU8@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit e5c9ffc6ae1bcdb1062527d611043681ac301aca ]

On certain platforms (PowerNV systems without a power-mgt DT node),
cpuidle may register only a single idle state. In cases where that
single state is a polling state (state 0), the ladder governor may
incorrectly treat state 1 as the first usable state and pass an
out-of-bounds index. This can lead to a NULL enter callback being
invoked, ultimately resulting in a system crash.

[   13.342636] cpuidle-powernv : Only Snooze is available
[   13.351854] Faulting instruction address: 0x00000000
[   13.376489] NIP [0000000000000000] 0x0
[   13.378351] LR  [c000000001e01974] cpuidle_enter_state+0x2c4/0x668

Fix this by adding a bail-out in cpuidle_select() that returns state 0
directly when state_count <= 1, bypassing the governor and keeping the
tick running.

Fixes: dc2251bf98c6 ("cpuidle: Eliminate the CPUIDLE_DRIVER_STATE_START symbol")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260216185005.1131593-2-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 56132e843c991..8950796a493de 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -357,6 +357,16 @@ noinstr int cpuidle_enter_state(struct cpuidle_device *dev,
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		   bool *stop_tick)
 {
+	/*
+	 * If there is only a single idle state (or none), there is nothing
+	 * meaningful for the governor to choose. Skip the governor and
+	 * always use state 0 with the tick running.
+	 */
+	if (drv->state_count <= 1) {
+		*stop_tick = false;
+		return 0;
+	}
+
 	return cpuidle_curr_governor->select(drv, dev, stop_tick);
 }
 
-- 
2.51.0



