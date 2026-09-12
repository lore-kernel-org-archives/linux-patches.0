Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD0E345EB9;
	Sat, 12 Sep 2026 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228830; cv=none; b=daHpsPvTtBpoRBwWMYpD28AtFAlH2BJtdsMehscR+7ou3mUDUdMjX+V8GD/B/hpdi5S8vmOHuVPA0Qhgsn1Ed3Szlj5MHHxbPuNrSDwiHCgnx41cQ4zxvC8H9SQijYpiN3Wx71ZR1Ax0UiLuKFfIx/uHibqH4Tth1Z4d9b1isQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228830; c=relaxed/simple;
	bh=56yaVn+TehJQRYvVSZt+13buxhzYS7ra5I+hTvEu1sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbMFWvqPVmiHaitW3XLEoROVObc9WOXdNufkmturAWDe8HnVbU/0PNrB+zBt5O2P6v/paIfEcvB86pXhagZPrD4DCIHduU/+pV4B2ElDu4iXzBMTu2p4NT04iHgN7g/FJsJ2+SKmJi5Xov8soA3QOk8idVsxSbns3aqbmRdZUyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVrwaH3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVrwaH3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7C91F000FF;
	Sat, 12 Sep 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228829;
	bh=GXSnHbrcCzQFCl/acHmgifao1Km8h4kvRf/KYq9gLmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVrwaH3tAh9H2wmdu6kzHbwO5sVzpklBtu/3hgz0w1E+1SZtrvD3J9yDKH/6tzeV3
	 WJNEXdLubJvrkoTS6OAs2eM0bys0e0HJR7dPERIUPmmkU3vquqwZa14bZZeMsw/jav
	 zL3WYJBl1apM1duK7rzX93SylxUW/Mqx/KMOJuwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0422/1191] drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check
Date: Sat, 12 Sep 2026 08:52:30 +0200
Message-ID: <20260912065557.718779424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1835,9 +1835,13 @@ static int vcn_v3_0_dec_msg(struct amdgp
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
@@ -1666,9 +1666,13 @@ static int vcn_v4_0_dec_msg(struct amdgp
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


