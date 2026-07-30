Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788793B05B8;
	Thu, 30 Jul 2026 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426917; cv=none; b=BL9ThJ87Dmo3pqEr+gh4+e4rhdr6fh6wW+Z0Gvw+yOY7tw6b6abpjMTwCu3xF9FYg87HK5Aynwx/Cf0uWVAoDs4KlPHy1yFTgzWmmuabluPa0g+EaboKfZm8xEMmQAmKmiRQkY57taShpP8aJUzc28F85dn3zqX+x6Z1u0FZE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426917; c=relaxed/simple;
	bh=hqD4TZCDCL2pE3jaKvg+SRSF63n7z/uOGHwb5wJPFks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/0lnp+kK6f/x7gbOo4qgDXoNZ6kCYQiCOo552clJU+2PNMUrTSLqGqdwfZZFJ5wjEods7enIuEHljin99FodoIDdd28FL9kPUGTyZUR5nLf5iLH5L+RVSHOIP3D247BzQy/qotW1QdQdCB7OOLYOAxtliJ5yp2E/qiAuwtWvyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiKIIHEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiKIIHEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00571F000E9;
	Thu, 30 Jul 2026 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426916;
	bh=YzPF2upV8momy5cerApkC0K/NSAtqwBA6VX0zGxfDfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiKIIHEivsmRP3JVAjNf5stCmbGVG3xxqiKxEcyEuOvmXeij8hyZ9wKC0Z5kKgOcq
	 8PShVwScRp/CJhBOX+KfKKn0MgzixoAYd+RAbw49jeKNZMq+NdiwcKxWwm39AHsn2K
	 o8cMOYCnZqfK4TaAGAGiyYYk/rKveSjso0v4wRmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 587/602] net/mlx5e: Fix NULL pointer dereference in ioctl module EEPROM query
Date: Thu, 30 Jul 2026 16:16:19 +0200
Message-ID: <20260730141448.389546994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

commit 7d36a4a8bf62dc508bc6bb4b59727aec25064ca5 upstream.

The mlx5_query_mcia() function unconditionally dereferences the status
pointer to store the MCIA register status value.
However, mlx5e_get_module_id() passes NULL since it doesn't need the
status value.

Add a NULL check before dereferencing the status pointer to prevent a
NULL pointer dereference.

Fixes: 2e4c44b12f4d ("net/mlx5: Refactor EEPROM query error handling to return status separately")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -393,9 +393,11 @@ static int mlx5_query_mcia(struct mlx5_c
 	if (err)
 		return err;
 
-	*status = MLX5_GET(mcia_reg, out, status);
-	if (*status)
+	if (MLX5_GET(mcia_reg, out, status)) {
+		if (status)
+			*status = MLX5_GET(mcia_reg, out, status);
 		return -EIO;
+	}
 
 	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);


