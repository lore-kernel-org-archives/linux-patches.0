Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62458311967;
	Sat, 12 Sep 2026 14:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222088; cv=none; b=oIhkUVwCjfPlL8iKVpCA/Dsw5eHwyM3dfU5VYdeGPbJVRgyyRL28mYMSFNzOEpeMk/AKh2mGHoS1R+mszXJBmKXX9hfNFQSnM4mWyGfQFWakFDtuYiziekuRb+AR6czFe0vIa2UZ5bqczDSBLIl86FlsT74L9W1TBPUdPzw1ii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222088; c=relaxed/simple;
	bh=3bRazzv4qaF50dvuTbS2sK/NjgWNOw+p7UKqwCo9oQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVyo05P/2Pbm2MXF/8uqgsnE8SZ0uUI1k93m10yRhZkUFt/ouI/GeTvT8/cFeDHtoomA2Eq+Y3gqlnrzxK9TKYNfLtqRJ1bQwK8bPfYdDU77/dZdur/eRkpmg36CsudkT3jAgRgqBIxEavFInOvUoTd+Zux91qh0i7bVw7l8NSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0cP17U/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0cP17U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9665A1F000FF;
	Sat, 12 Sep 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222085;
	bh=UfuIijeoyzz36e7RloXaUHlzlsSiD1OgB9Zokj/a2zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0cP17U/7C5fvlHg3B6DyQHAqCn57lGlo5VduuMHnu3fuXSHhFq7hTR2gFUE06znP
	 l93uF7Y/YzYHeMrFB6w6q1NqDdvgupOX/3WpZ+3CQRs4th6ULb66JnW1qKG209q/nF
	 kfUj7pnr2yks9GNHykJPLgsiTQliJ/zuXDZLTNVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0516/1424] drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check
Date: Sat, 12 Sep 2026 08:49:08 +0200
Message-ID: <20260912065618.846904956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1844,9 +1844,13 @@ static int vcn_v3_0_dec_msg(struct amdgp
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
@@ -1722,9 +1722,13 @@ static int vcn_v4_0_dec_msg(struct amdgp
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


