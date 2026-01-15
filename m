Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264A53BFE29;
	Thu, 15 Jan 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499323; cv=none; b=nhGlj5sKUJNFVHNPeezePaJT8v5+9zsITvFSLS1NAqFfYimIus3mvjLuxG2Sdf1Azf10ekBobuQfrRonWtPLTLkCjaWiO8ge4k9tTHrRSjEPiXrSu0Cmo6IkpdSODIY4jh0kXyl1tH+v36CTgrp1HTcf0grgZJTCK/dRoIbTxcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499323; c=relaxed/simple;
	bh=GP6p3Kq0d1TyW7NB3FBn8y7Y7judo6Ot/Ju7IZprfII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zkx3+n2xkpYxZRaTMBV++X7mD+cvwgJYvDcUZrIl4JJglkZmIMagw7y4CZP8WnajQAfxN7Re9nia5PtwDLW8Nj3WoSekb4i3tUd7NDlXXFJ/cwmZ4VVr5i0AFeazsjCwK4wOe63Iaai668THkU8f6CpmqaKLQjZHYXDpfdiANN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzilIbWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzilIbWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8816C2BC86;
	Thu, 15 Jan 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499323;
	bh=GP6p3Kq0d1TyW7NB3FBn8y7Y7judo6Ot/Ju7IZprfII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzilIbWQINen81QIpsQcw/2PhqzemVrped+mMj4Ey633XyzK/TjmSJHtaNNdRUDj2
	 SX63kKZgnCJaRJbXiJzmQP1vciyp3E75YkUlgq/bQ3WqcZKx2jvTYe+amt/jEJTzQf
	 BxjLZARaph2UYPfboypqCTB428ZSZ4vxu4t0s7/M=
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
Subject: [PATCH 5.10 186/451] net/mlx5: fw_tracer, Handle escaped percent properly
Date: Thu, 15 Jan 2026 17:46:27 +0100
Message-ID: <20260115164237.632010161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2645e941ef1ce..f3985421e739e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -364,11 +364,11 @@ static bool mlx5_is_valid_spec(const char *str)
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
@@ -386,7 +386,11 @@ static bool mlx5_tracer_validate_params(const char *str)
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
@@ -463,11 +467,15 @@ static int mlx5_tracer_get_num_of_params(char *str)
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



