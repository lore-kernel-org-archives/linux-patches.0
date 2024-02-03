Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFF101C5;
	Sat,  3 Feb 2024 04:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933954; cv=none; b=bFCkW7QhKfTvnjywn5aCFpvU8So1DIdTnfkQP5mWQAHVJbOsrxRYcty0Rq7kYFn8ME8KJhZNnb+NteaiuqOyBNpSih9Qh5isNL+X6grBkEaqFHJf4nrl3tIeF864ZEPVcsVRkK9DtXESq/FBoTG+jW6GqTGn14o5KGLq0WX0Bvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933954; c=relaxed/simple;
	bh=D6wZKZ2f5G4qHJuI3LsxMXMP+FO7jfITHIRN87nqNEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jyo/wUh7tyQjHwrPsuHGNX5jZ/8+xZsYoZhLXcPRsFO/f8RqCeMX+kOo51wtkRnXVRMFRDnKnIIwyBcyppfIgbhjvHjoOWQw+kEeQLfdeo7Rc59yg4eeS458TqAIrnuC1FEA+gBZxQcRORTdPo8joyamoQYwa1KwsDo5ZXDh4dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWRWaa8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWRWaa8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC100C43390;
	Sat,  3 Feb 2024 04:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933953;
	bh=D6wZKZ2f5G4qHJuI3LsxMXMP+FO7jfITHIRN87nqNEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWRWaa8S9Jmetn5W90Diu0YiBmIr7CbXKDZxxPqCfJf8PJMGSUkP2ujumdRL/gzS5
	 VoXNVGZ01D37UKaT6DHe0xKMkzATSxdDhUiQGDWcker0Id+rpCxp/80XvlUF8Ostgz
	 ZqswCW75ZjIPCcnFe8LvllVyAAJDJj0JqQOew9Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 322/353] devlink: Fix referring to hw_addr attribute during state validation
Date: Fri,  2 Feb 2024 20:07:20 -0800
Message-ID: <20240203035414.013301384@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 7634f187fa50..841a3eafa328 100644
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -672,7 +672,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
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



