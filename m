Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C037572694;
	Wed,  9 Sep 2026 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963027; cv=none; b=jv+cU5w7/rsUj5CnqHmWzfQygRtV9LVbtB4OoogRwUKe8pkAvVSRjBlB6ovFnDtacTyavnr/YbYwYp0QbKlhG0F2dXnUbyUTtKdO660NI6wjzDpeH1BQb7j9xWTQKfhyl9fb7Ku+LmtG0LP18q3ICVUXP4GJdVDSq8YQv8nhgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963027; c=relaxed/simple;
	bh=FjjAl8ikF9mR2XuujAvsw/DGMvOGtuijUX/oTzjIjhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXraXTpui47etqH4ERDKy5T0ZhyY9dTq6KqbdjhZMFI4bf85e7j5ks853gqczPwkb2KInwxBVkgHwP3FxndnwHIgCHWBWMxr+Y2dNcHB8vFNxhMEpE7iyqR/D46/5XnDc5i2ikr41GNGewMEtWsyTJIy7VZ6fDejC3ioNO3VG/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9mk/yG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9mk/yG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6D1F00A3A;
	Wed,  9 Sep 2026 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963026;
	bh=HI7hNVMFcCfK82GwiON3knqjBHO53du7/jLiTgVKVDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9mk/yG8SvfSHC5gNi8pbrirB/rXTZ6rW2FTmYhfAVVoySonIhlFgHotpKTI0X/MQ
	 r3tUfgzDDA6otGwkfIO+ydS0aZEMsA+wNJ6IdaKO+xuq8iJwt+Jg0aZUY+8z8SoWZv
	 y11/bKhjm+bKTz4Amwu9KYVZU9YVcNCSIEBbt1S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 495/556] drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check
Date: Wed,  9 Sep 2026 15:42:55 +0200
Message-ID: <20260909134247.899039163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit 4d7390530853eb7befda9cc786e4c86e8ad7ac9e upstream.

If the supplied msg[2] (num_buffers) is 0x3FFFFFFF, the expression
6 + num_buffers * 4 wraps to 2 and the bounds check passes, letting
the parser loop far past the end of the message BO. Triggering it
additionally requires a ~4GiB mapping so that msg[1] survives the
earlier "header does not fit in BO" check.

Rewrite the test in division form, which is overflow-free by
construction. Also update the message to reflect that msg is invalid.

Fixes: b193019860d6 ("drm/amdgpu/vcn3: Prevent OOB reads when parsing dec msg")
Fixes: 0a78f2bac142 ("drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg")
Cc: stable@vger.kernel.org
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |   10 +++++++---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1964,9 +1964,13 @@ static int vcn_v3_0_dec_msg(struct amdgp
 	len_dw = msg[1] / 4;
 	num_buffers = msg[2];
 
-	/* Verify that all indices fit within the claimed length. Each index is 4 DWORDs */
-	if (num_buffers > len_dw || 6 + num_buffers * 4 > len_dw) {
-		DRM_ERROR("VCN message has too many buffers!\n");
+	/* Verify that all indices fit within the claimed length.
+	 * There are 6 dwords in the header before the first buffer.
+	 * Each buffer has 4 dwords. Any trailing dwords after the
+	 * last buffer are ignored.
+	 */
+	if (len_dw < 6 || num_buffers > (len_dw - 6) / 4) {
+		DRM_ERROR("Invalid VCN message!\n");
 		r = -EINVAL;
 		goto out;
 	}
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1880,9 +1880,13 @@ static int vcn_v4_0_dec_msg(struct amdgp
 	len_dw = msg[1] / 4;
 	num_buffers = msg[2];
 
-	/* Verify that all indices fit within the claimed length. Each index is 4 DWORDs */
-	if (num_buffers > len_dw || 6 + num_buffers * 4 > len_dw) {
-		DRM_ERROR("VCN message has too many buffers!\n");
+	/* Verify that all indices fit within the claimed length.
+	 * There are 6 dwords in the header before the first buffer.
+	 * Each buffer has 4 dwords. Any trailing dwords after the
+	 * last buffer are ignored.
+	 */
+	if (len_dw < 6 || num_buffers > (len_dw - 6) / 4) {
+		DRM_ERROR("Invalid VCN message!\n");
 		r = -EINVAL;
 		goto out;
 	}


