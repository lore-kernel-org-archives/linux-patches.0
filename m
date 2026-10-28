Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217103;
	b=b6ciGELluYeeZFDr7i8Xe4PslE2uWiIHWd4/CJrsILUqOValVp6d3/OTVufwF2z8AI2g
	 UWPA0rVtsR7rxw2ZgkA1aUqLECBlOEJ9XQa1PfKta3aDdcEmgAztreILMO/XJPfZThKwR
	 kBTWpmDY5SXRIg2vhcbhRXSv7JiJwrlAyd0On25mp8Sbq+JeBe+WK+KYwFNqbiO8ju5QO
	 /E1APRDD+52EsHBMBZrfl1b2Jxi7tMiRj3wWO8YgcNc85PY2+BLZvBCoJe+2FpOSbx+Tn
	 dEqFjS4LrJbgyW/sWIVuTkBGZbfFa6NYJbBtDeyibQh4kdSRydqRZvIq7Ew4CYAgKrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKITA6rhJ4E/PvxDNdLzE2bgan9WSuOxZigB/PchQX4=;
	b=YMLrOBRD8pFePjEDjHfMdzfNjx9mGiQfsEOVjKNRSt5zcJOApBYNoY9h7NzrT8Hl5eB+
	 2AsI8KIPEz1x+JGCpBTiwPMRcF22c6fJqkxeIFR6neGx0U0cp/W/3Qc7zvWCBpCO+DGCS
	 8K3srnG9IisQ0U5xrrA/jBNFEnWdwjE7VicBSQR/W/02Es7SWEjyOTZuDIwN/Yf0+pNDA
	 4uqWdqn8x2Gbth09CH6hBQTHynloyJrmaczIU4UiFrx43lXjQPtHYkFEwmPtwUMvwXnqC
	 UX1cQ57TOtLEN+QlJ+ufLXW6rCQbC11OKipnM8DkPO/1hwhyOdf87WNiJ6zTdcGCDGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqmM8fGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD356606A320;
	Wed, 28 Oct 2026 19:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqmM8fGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098BA1F01825;
	Wed, 28 Oct 2026 19:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217102;
	bh=JKITA6rhJ4E/PvxDNdLzE2bgan9WSuOxZigB/PchQX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqmM8fGnqw9/N4gZB4c7kdc0LrhUDWeWpGVS1gXe/5brLHcR/BWXSx6dVZeVNHs0N
	 8+T67wU1jTX7xBd08TsbM77fqdx2qG7Nk6CC54lOMQQzVPx10Qdh+GskFD3Hk49Pt+
	 oCQ0/npfl9E6wcqWb/zoGtdCYl1S5DHIwjc6N3wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.1 1746/1887] drm/amdgpu: dont drop the runtime PM reference twice in amdgpu_gpr
Date: Wed, 28 Oct 2026 18:04:02 +0100
Message-ID: <20261028170539.188323594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit de9f6bcdb44f0e410031002e2f103826ea6b6259 upstream.

amdgpu_debugfs_gpr_read() drops its runtime PM reference right after
reading the wave registers. When copying them to userspace fails, it
jumps to the err label, which drops the reference a second time. A read
into a bad buffer on Navi31 either steals a reference somebody else
holds (power/runtime_usage goes from 1 to 0) or underflows the count:

  amdgpu 0000:03:00.0: Runtime PM usage count underflow!

The registers are already in the kernel buffer at that point, so finish
the hardware access first and copy the buffer with a single
copy_to_user() instead of the put_user() loop with its own error path.

Fixes: 9eee152aab56 ("drm/amdgpu/debugfs: fix ref count leak when pm_runtime_get_sync fails")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 31035bbd74f7c3e10c163db875b8e67f8b50ee6a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -997,7 +997,6 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 {
 	struct amdgpu_device *adev = f->f_inode->i_private;
 	int r;
-	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
 	if (size > 4096 || size & 3 || *pos & 3)
@@ -1042,25 +1041,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 
 	pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+	amdgpu_virt_disable_access_debugfs(adev);
 
-	while (size) {
-		uint32_t value;
-
-		value = data[result >> 2];
-		r = put_user(value, (uint32_t *)buf);
-		if (r) {
-			amdgpu_virt_disable_access_debugfs(adev);
-			goto err;
-		}
-
-		result += 4;
-		buf += 4;
-		size -= 4;
-	}
-
+	r = copy_to_user(buf, data, size) ? -EFAULT : size;
 	kfree(data);
-	amdgpu_virt_disable_access_debugfs(adev);
-	return result;
+	return r;
 
 err:
 	pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);


