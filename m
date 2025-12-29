Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5886326FD9B;
	Mon, 29 Dec 2025 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025152; cv=none; b=YCHot7c2pQcq4ZBxCy+anUVp4Z9veY9haTXFIihuRrj1glGLgQTGCJ+B44hS32tIo5vyLNmuUZb8d0SJ2VdsuqRUSENlu2CuckRj2s3X9iTIsfN4UaPX+qbYmDUqPA7oOzlBHCfCPUvd+vNXhF1X5SoHg0Dvf4tXfSiWHg4fUBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025152; c=relaxed/simple;
	bh=vC1xv0vqB37V49oiWryjiDYvrAsL5EZAb4SlKmpfp8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6Jx1fUoQYsEARZhby/5ZgXji93W9TRz4MgLWqbCSpelVEn6QtWntVvK6yRoLq4Dnwh/K9YSnR6JFqaXCH0SK1Ip60VDHapHrcfbGZkT0SrQv6ObcpvAV5geJvzBaZ1fcUtz/MAuhm5uEqAnB5Vnf3YRPiuxknoNSlCdtU+K3vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEAVUsQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEAVUsQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B89C4CEF7;
	Mon, 29 Dec 2025 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025152;
	bh=vC1xv0vqB37V49oiWryjiDYvrAsL5EZAb4SlKmpfp8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEAVUsQMrtSJsBcPFuIm1HR6U11Tw0ohT9c6DNo371aIIs3LiRSdPVxVN1fNQrLic
	 5NSPyosWtwUt4ny1FzAKUsNKRkaHwyz53s3J0906O0yrDP+MUljYw0YWLyCDhL8rde
	 hRLpqwudI3GN1hebLvBHLw/sOj5ZPQoiz0qEGhTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/430] net/mlx5: fw_tracer, Handle escaped percent properly
Date: Mon, 29 Dec 2025 17:08:17 +0100
Message-ID: <20251229160727.858182063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit c0289f67f7d6a0dfba0e92cfe661a5c70c8c6e92 ]

The firmware tracer's format string validation and parameter counting
did not properly handle escaped percent signs (%%). This caused
fw_tracer to count more parameters when trace format strings contained
literal percent characters.

To fix it, allow %% to pass string validation and skip %% sequences when
counting parameters since they represent literal percent signs rather
than format specifiers.

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing support")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reported-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Closes: https://lore.kernel.org/netdev/hanz6rzrb2bqbplryjrakvkbmv4y5jlmtthnvi3thg5slqvelp@t3s3erottr6s/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-5-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 9c86c8c72d049..0b82a6a133d6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -368,11 +368,11 @@ static bool mlx5_is_valid_spec(const char *str)
 	while (isdigit(*str) || *str == '#' || *str == '.' || *str == 'l')
 		str++;
 
-	/* Check if it's a valid integer/hex specifier:
+	/* Check if it's a valid integer/hex specifier or %%:
 	 * Valid formats: %x, %d, %i, %u, etc.
 	 */
 	if (*str != 'x' && *str != 'X' && *str != 'd' && *str != 'i' &&
-	    *str != 'u' && *str != 'c')
+	    *str != 'u' && *str != 'c' && *str != '%')
 		return false;
 
 	return true;
@@ -390,7 +390,11 @@ static bool mlx5_tracer_validate_params(const char *str)
 		if (!mlx5_is_valid_spec(substr + 1))
 			return false;
 
-		substr = strstr(substr + 1, PARAM_CHAR);
+		if (*(substr + 1) == '%')
+			substr = strstr(substr + 2, PARAM_CHAR);
+		else
+			substr = strstr(substr + 1, PARAM_CHAR);
+
 	}
 
 	return true;
@@ -469,11 +473,15 @@ static int mlx5_tracer_get_num_of_params(char *str)
 		substr = strstr(pstr, VAL_PARM);
 	}
 
-	/* count all the % characters */
+	/* count all the % characters, but skip %% (escaped percent) */
 	substr = strstr(str, PARAM_CHAR);
 	while (substr) {
-		num_of_params += 1;
-		str = substr + 1;
+		if (*(substr + 1) != '%') {
+			num_of_params += 1;
+			str = substr + 1;
+		} else {
+			str = substr + 2;
+		}
 		substr = strstr(str, PARAM_CHAR);
 	}
 
-- 
2.51.0



