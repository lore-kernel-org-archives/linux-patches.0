Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29C236C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302304; cv=none; b=CBH5aaSQWM93k9LbEDCWUxkXEQiA6ETF30HlVE8EfhEJyk/SXbIiwR1yp9FyqVgPd998iXsVYENPj1PmSQLNElPZiJsR0/oRB57gDYBUWertxZfC3gOFmd88Zef4tANunl9r8Co407ocDONSkVzGsDSK3iCBwG6ffe3jrSWDpxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302304; c=relaxed/simple;
	bh=6OYWL4b9WvFaf1PM6WVHSd1BFYq6ywzlhYSxR1XvxN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDjzRmdA02azADokLRBXikfKT8qkkeLTf4TNg+e6FdmL/T9VEHhpdlstUPa/ACnLIOuxWkE9cnDuyCCQrTmqHqZv7cMCDoIeo1QG1rnhcoo0NLd79CDxek2eXdALLz0wRp/+e+0fa7YjaqwIRP+Wl2tGcROiInIdvLonu56IGFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fj9AwHgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fj9AwHgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1105DC19424;
	Sat, 28 Feb 2026 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302304;
	bh=6OYWL4b9WvFaf1PM6WVHSd1BFYq6ywzlhYSxR1XvxN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj9AwHgDUU7F3zEjliRq4PH1X7jHJmn1YZmwgk+cLArm0FuUUjw6qvwViQ7mDOFhc
	 6dErEsm3kekEaLZQV1LiBzlr8TriRo8hvp7xESUG5lyrSnvXiURKvR0XGN5Q9UIaDP
	 HMYM0T4RD7YkrHbfDMptg90HqdCAdic8/qWSMfMAmvKjEN2qBaeemCvvLZEd4fZj9D
	 MW1fhB2H/Ga7uq50kjRckRkQoVmZyyqFGeAES/2VoZOreH2j80NcYEn4myf1yEFlw0
	 71OPqi3gsM7pJaBAPfPPsiQhJKEVL1nkhfRSNM5r6ZIHe5K8KwVMeRcNEbjOux4/29
	 3rg/OKPNws/6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/232] xen/virtio: Don't use grant-dma-ops when running as Dom0
Date: Sat, 28 Feb 2026 13:07:52 -0500
Message-ID: <20260228181127.1592657-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Teddy Astie <teddy.astie@vates.tech>

[ Upstream commit dc8ea8714311e549ee93a2b0bdd5487d20bfadbf ]

Dom0 inherit devices from the machine and is usually in PV mode.
If we are running in a virtual that has virtio devices, these devices
would be considered as using grants with Dom0 as backend, while being
the said Dom0 itself, while we want to use these devices like regular
PCI devices.

Fix this by preventing grant-dma-ops from being used when running as Dom0
(initial domain). We still keep the device-tree logic as-is.

Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 61367688f1fb0 ("xen/virtio: enable grant based virtio on x86")
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <6698564dd2270a9f7377b78ebfb20cb425cabbe8.1767720955.git.teddy.astie@vates.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index 9784a77fa3c99..46cc47bd1dd0f 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -360,7 +360,8 @@ static int xen_grant_init_backend_domid(struct device *dev,
 	if (np) {
 		ret = xen_dt_grant_init_backend_domid(dev, np, backend_domid);
 		of_node_put(np);
-	} else if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain()) {
+	} else if (!xen_initial_domain() &&
+		   (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain())) {
 		dev_info(dev, "Using dom0 as backend\n");
 		*backend_domid = 0;
 		ret = 0;
-- 
2.51.0

