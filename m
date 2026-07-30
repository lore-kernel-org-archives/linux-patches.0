Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292F30C618;
	Thu, 30 Jul 2026 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424439; cv=none; b=e55heLLkadH4nNZYqyB+tfEYlggogyeiGgIYUYZcMILqbw0nOxwiARbl3l5n7tZAT7kq076dQjhE6sdRykQk8aTuH1wAtLkO7R20zzz0kAA9bhW5bBKSBu8+P5SRTcgta+9xn3MAU66DyuisTVCb/DOcqzK17oY5ypdZFyOUNXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424439; c=relaxed/simple;
	bh=BtN+EVSqPsZxXfnMqK4ipmwDfTVndWVpAVdDDG+tpD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hX+zdUFwW7kWiMEoR2CXiROKNpCpA/nzY3Ic93o1JWudMM2XOvZg5Lwo1CyYedegZ66CHV2C4eILBTNANulveu8XxYe/nEZRGoCCcij0Z1bcqpGrp7/4zIXTVMhhQlpY2jU7dBiK0KIA7+2oInBdlvm95AtS+dsEeGcEIDfLWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw6fBbGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw6fBbGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8C51F000E9;
	Thu, 30 Jul 2026 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424438;
	bh=KtTCQRtyt5RUjNnjjEZZpXz3INXoBoHF462AF8gvMZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qw6fBbGMNQQuUusbyg5iROL0qB2VPmmr7QD38sip/BBx2kww/ebtOqgCdwAOW+rl5
	 7hd4fBwfMM+nY/6M1swYkuBsxvPkSVlWj3GtcasypVXRyQaqyg5lU33Yc1wp2mTQ9A
	 0tFwGuIYL7cAEaKlSbZq3FtAnULNZ9yb8sXq3Q7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 393/675] drm/v3d: Reach the GMP through the hub registers on V3D 7.x
Date: Thu, 30 Jul 2026 16:12:03 +0200
Message-ID: <20260730141453.485766794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Maíra Canal <mcanal@igalia.com>

commit f7df2da0d1c375c1c4c70e1e0b569592de0d6b73 upstream.

v3d_idle_axi() drains the GPU's memory interface for a safe powerdown by
using the V3D_GMP_CFG register. It reached both registers with the macros
V3D_CORE_READ and V3D_CORE_WRITE.

On V3D 7.x the GMP is no longer a per-core block; it lives in the hub
register region. Reaching it through the per-core register block addresses
the wrong region.

Select the hub accessors (V3D_{READ,WRITE}) for the GMP on V3D 7.x and
keep the per-core path for earlier generations.

Cc: stable@vger.kernel.org
Fixes: 0ad5bc1ce463 ("drm/v3d: fix up register addresses for V3D 7.x")
Link: https://patch.msgid.link/20260718-v3d-pm-axi-transactions-v1-1-4ecd7729ed70@igalia.com
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -45,6 +45,18 @@ v3d_init_hw_state(struct v3d_dev *v3d)
 static void
 v3d_idle_axi(struct v3d_dev *v3d, int core)
 {
+	if (v3d->ver >= V3D_GEN_71) {
+		V3D_WRITE(V3D_GMP_CFG(v3d->ver), V3D_GMP_CFG_STOP_REQ);
+
+		if (wait_for((V3D_READ(V3D_GMP_STATUS(v3d->ver)) &
+			      (V3D_GMP_STATUS_RD_COUNT_MASK |
+			       V3D_GMP_STATUS_WR_COUNT_MASK |
+			       V3D_GMP_STATUS_CFG_BUSY)) == 0, 100)) {
+			drm_err(&v3d->drm, "Failed to wait for safe GMP shutdown\n");
+		}
+		return;
+	}
+
 	V3D_CORE_WRITE(core, V3D_GMP_CFG(v3d->ver), V3D_GMP_CFG_STOP_REQ);
 
 	if (wait_for((V3D_CORE_READ(core, V3D_GMP_STATUS(v3d->ver)) &


