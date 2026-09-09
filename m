Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119A5867C0;
	Wed,  9 Sep 2026 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964334; cv=none; b=Uez0iqxwvA7iWKghBHXTjAwZ+AZGqgfZqcCkQAPiAHb5nAVBHUlq5m2ZCr6hsOwRi7PQ7NI6E6zKmEteVzDRKdsl5ClPRaeJSvQi+W0ZVpSxHQ4uFyFRDlfe1xSliZtE6BfkPCuMqwAXV9WeV9cKXkTmh6HuIQ7FuMdnr6eb2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964334; c=relaxed/simple;
	bh=eRVqVhUyGNeZBTt727vTKWjYdLvlPjj/N2ZfJOkvl+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSgDNDL648odXSoQGJnC6iGTaQ0njNcvmlXVQdBDGz6rTolcaDxlQm16BFbeR8KIAr2byTELqxo7RpIk67Y3XYE28a7D+vE7aatJvf16cMf7ZlNav0xAuM4PcDX0Y9tIxNxdsoE+w8iX1/fjgrykg+ceHoIMr9jtQQUckrZeccQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Acu8iHMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Acu8iHMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E451F00A3A;
	Wed,  9 Sep 2026 14:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964332;
	bh=SLSkdozvd51HIJ5ntMlCfdVL9pMFfppw1OGdRo0IKhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Acu8iHMXAY47kxABq0MC7sDBCXpeR36u6yBFDXKXycWu8DJTfatUQhlPtmFSizq7Y
	 PVu/zqTY913opg7gHusIKsS7/eO4wkIymq6SrNAO3PGOy1K+llBqbRPL6Rj79SERms
	 IQYav0uH1qLYj02qGkjuOj8CWZmcEYU5G/YbqgqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 386/583] drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check
Date: Wed,  9 Sep 2026 15:41:11 +0200
Message-ID: <20260909134251.365287385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1963,9 +1963,13 @@ static int vcn_v3_0_dec_msg(struct amdgp
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
@@ -1879,9 +1879,13 @@ static int vcn_v4_0_dec_msg(struct amdgp
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


