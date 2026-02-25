Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA21D5ABA;
	Wed, 25 Feb 2026 01:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982974; cv=none; b=AM3k/wAisUT2g14QL49QjCY7i3VNYMBdCjBbcAo2Huspkmk4d62CrhRnKLtRbiVDcPlaqp9zkhLibBx8pjYAceeO5n07kPQ5ThUYyYDhP6/nJUXn53atkWF0+kI72avJ7/UET9/xx3i8sN2PV5lxCi0USpc9jqfjstM+WHxQDWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982974; c=relaxed/simple;
	bh=RigcJSG1A2XkkteEI4wlxdEattSy9JJssanUrqvK/20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/UnKGFii6QsgD8cUJFwh8Ks6P+un4OdAiEaHFRkbEYVGiv1xkqqLuOaL+hBUxwjqbSGXaOe6eDnAQz+sbeYzzZhAxVMRcYYhWF2nIBCenU60Ks3xSgozCU/E25da99aha2aXyuPkN4scQKP9O++XdooPw/wPeYHJZgA3IBYimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh3JRGRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh3JRGRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F115C116D0;
	Wed, 25 Feb 2026 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982974;
	bh=RigcJSG1A2XkkteEI4wlxdEattSy9JJssanUrqvK/20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh3JRGRTpHcP2/EhArcLQiIj8WpQs20pMQmMxsggIWjeGe2ckWUarsUKWIfJWDYA1
	 bSS7CfXuamDyf3GVS6CSMo/BTr0VJwK41CSwxcP42g1CWKd43nim1h+apF+HpQwsmO
	 YKV5FdWyzB0bVfDJSefQtfOVG4YKzhq9sAbCp6HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Avadhut Naik <avadhut.naik@amd.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 148/781] EDAC/amd64: Avoid a -Wformat-security warning
Date: Tue, 24 Feb 2026 17:14:17 -0800
Message-ID: <20260225012403.293638066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c816ba1dcd931b9db8d66c71e1ae34ddcdbf968f ]

Using a variable as a format string causes a (default-disabled) warning:

  drivers/edac/amd64_edac.c: In function 'per_family_init':
  drivers/edac/amd64_edac.c:3914:17: error: format not a string literal and no format arguments [-Werror=format-security]
   3914 |                 scnprintf(pvt->ctl_name, sizeof(pvt->ctl_name), tmp_name);
        |                 ^~~~~~~~~

The code here is safe, but in order to enable the warning by default in the
future, change this instance to pass the name indirectly.

Fixes: e9abd990aefd ("EDAC/amd64: Generate ctl_name string at runtime")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Avadhut Naik <avadhut.naik@amd.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://patch.msgid.link/20251204100231.1034557-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2391f3469961a..63fca0ee2c23b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3911,7 +3911,7 @@ static int per_family_init(struct amd64_pvt *pvt)
 	}
 
 	if (tmp_name)
-		scnprintf(pvt->ctl_name, sizeof(pvt->ctl_name), tmp_name);
+		scnprintf(pvt->ctl_name, sizeof(pvt->ctl_name), "%s", tmp_name);
 	else
 		scnprintf(pvt->ctl_name, sizeof(pvt->ctl_name), "F%02Xh_M%02Xh",
 			  pvt->fam, pvt->model);
-- 
2.51.0



