Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE5C41DEEC;
	Sat, 12 Sep 2026 08:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202420; cv=none; b=YxZojehjFGWP95l4ufvwSj8OUI45wlytcF7myrOjFyogFH/rczF9/1V1AsqoJoyM2bmsJbl82GOalNgdR7jI7ju9p8QmqginIUBD4ciL3d5OmFsTeJPdXgBElH8DOmV5U9C+ypwQlrJTKSvEI97Bim2nKFAD8aL7TtmW+4/ApU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202420; c=relaxed/simple;
	bh=5gFb2mzMplhy5rQsZHD7a1AmRUx7ml4ATXpni1WzvVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkVIwzuHwAlPv38GWNWagQxk6UHtF/svUTLQoR44yIclyCgKS06PONWlbUXQWDLjy495xdnOIprt+HAiOfuk4K2Xeb8U6X/LoTcfMpgUhmpG2cZocPA07pI8ZeTSQlZjrmA2kALGtCuZ/CBktd8aa6uyuod65nqjw0I36vZc1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce7SVNts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce7SVNts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92881F000FF;
	Sat, 12 Sep 2026 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202419;
	bh=bKQvg3nNWWloePIMK73P3WRaA0Pp3MlbjgxCEsn4BL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ce7SVNtswjJBAJUAk5k3wpB6zCBFFHJKFnaY+/EFFGKyxAUjg8E4ZooJZeTQ52A1G
	 VhO/Y3XTMzM1ogfUmW47zeXhO6t+jB4nlN+8TrVzURBMOE4VbwzA984YbvC1JEXXoW
	 6F/bIsschJ6Bz7HfI8E7ekK9VJDZYjBEXgZV4NcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1200/1815] arm_mpam: Disable driver unbind to avoid UAF
Date: Sat, 12 Sep 2026 08:49:10 +0200
Message-ID: <20260912065717.180979508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit bb1a0f582d519c0461b0940116e2b52c5ba31459 ]

When a user unbinds an MSC and that MSC is the only MSC left for a
component then the corresponding mpam_component will be freed. If the user
then goes on to read the schemata file in the resctrl filesystem then the
mpam_component will be accessed from resctrl_arch_get_config() leading to a
use after free.

As the MPAM driver is not a module the unbind sysfs interface is the only
way to trigger the remove. Instead of dealing with the complexity of
allowing some unused MSC to unbind just remove the unbind sysfs interface.

Fixes: f04046f2577a ("arm_mpam: Add probe/remove for mpam msc driver and kbuild boiler plate")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 59ea62b845c1e..dd422c56fbb14 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2139,6 +2139,7 @@ static int mpam_msc_drv_probe(struct platform_device *pdev)
 static struct platform_driver mpam_msc_driver = {
 	.driver = {
 		.name = "mpam_msc",
+		.suppress_bind_attrs = true,
 	},
 	.probe = mpam_msc_drv_probe,
 	.remove = mpam_msc_drv_remove,
-- 
2.53.0



