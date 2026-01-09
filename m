Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947A831ED6D;
	Fri,  9 Jan 2026 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962163; cv=none; b=S5LYQo+sUpFArDZ2nv3WnsnWimwV/V44nz/lAAIFOb36kCX/de/q7UfGz2CStxpqSqyqwnwaDY/+5twt8yj5bTZEslHsQjjZakG6Ev5xNPoBXqu1qdpQqRw80PXN1mvzk8tiHicvek41v2qDbaWzpUIJm9BfErHHbcCHa42Wv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962163; c=relaxed/simple;
	bh=diwwmvtyE7przSG5Qku4+YSOqLeXbgEqTS3K3CCJG3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAoreNs9JOY6nhe8NWhTXD8Q+hXFAZ4DKaxV7n3LcD1UtQv5F3AH+wlVcSJo9pyry2X7MrYoKc9lUuj4nt1VkkuqFt8inuK/Rqjyj67G2qF+niFVJP0PHe77LAzPW3CUnhceFLxz6nBnGNydGWriSQrkRmcUqIo8aMbhYAviwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQWQCH8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQWQCH8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B22C4CEF1;
	Fri,  9 Jan 2026 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962163;
	bh=diwwmvtyE7przSG5Qku4+YSOqLeXbgEqTS3K3CCJG3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQWQCH8aHA755JoWrEGS0JMJiaq6hJqD8y24sb7eKXJzDfBqu3Bw3H3EJBf54UijJ
	 /o1geBL40ic2hc7GI9K37dH0j9IybSYylXCT3iVpuzoqp14yN3I5Zqoe4CvUwdW0NX
	 KrnQdkHmaSgaWnGjinQfz+G19qHNranVb5tsU0dk=
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
Subject: [PATCH 6.1 268/634] net/mlx5: fw_tracer, Handle escaped percent properly
Date: Fri,  9 Jan 2026 12:39:06 +0100
Message-ID: <20260109112127.620221330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 2ce900b18f705..c216634c8919e 100644
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



