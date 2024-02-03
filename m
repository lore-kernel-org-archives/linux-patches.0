Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BF51AADE;
	Sat,  3 Feb 2024 04:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933713; cv=none; b=KMPTBZy0BZGC7XTpuRyRBoJa1/UveEkwLydDtrUa1bo/ne7IPYLudq9wJmJz+TIWDhYhv+89G+cUP19pm94MbhaGYIDOMr2qn3fM2YuIAURoB32rmSoshvHHvPMwykc2S9eszft1eYeiObm3+kA0rBzxNbbiA/UZKnmgTraSbtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933713; c=relaxed/simple;
	bh=Gxx+34sZquzoUpubgc6JnvxlZqfyohHDlx60Ixp+RMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keNtrEmx6bHD+AsiHA0syST3ChpRMHnWLJDttStLngMZMf/dt2zvDSDfmIcRqtnYHNlQbhIj4QpSj2x6kgBY8PqK+aCwnGlrK1citgJ8AsObDGEMGPknfmvzOn4Nms5tGkr1ssi04XPmiQb8u2ClsW2FqgMoyZF+B2whojJpnss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mv7YD87r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mv7YD87r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1356C433F1;
	Sat,  3 Feb 2024 04:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933713;
	bh=Gxx+34sZquzoUpubgc6JnvxlZqfyohHDlx60Ixp+RMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv7YD87raMbO5XA1W+eCzfQJsDDqYLtoVippGNgkLQYMJmuFm8ZP9VM8gkQDrMacy
	 mifw86dSaj3G8/8GZY0b+RW4yMxAknl370fepwduRqL0Nb1dlrh3g8HyVJZf/UdBSD
	 5cS3qoooof/4lnLFs0esJn9cgm6JmxvbDeDp211E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/322] devlink: Fix referring to hw_addr attribute during state validation
Date: Fri,  2 Feb 2024 20:06:28 -0800
Message-ID: <20240203035408.481295703@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 1a89e24f8bfd3e3562d69709c9d9cd185ded869b ]

When port function state change is requested, and when the driver
does not support it, it refers to the hw address attribute instead
of state attribute. Seems like a copy paste error.

Fix it by referring to the port function state attribute.

Fixes: c0bea69d1ca7 ("devlink: Validate port function request")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240129191059.129030-1-parav@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/port.c b/net/devlink/port.c
index 4763b42885fb..91ba1ca0f355 100644
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -665,7 +665,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 		return -EOPNOTSUPP;
 	}
 	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
-		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
+		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FN_ATTR_STATE],
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
-- 
2.43.0



