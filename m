Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A1230BD9;
	Mon,  2 Jun 2025 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876201; cv=none; b=ETSRpD+211MuCqFLoPKAffNnQSqGyXjRcrYzDZ9jttfX5MV9X4/W75bkTjyf6AJkoK8N4WugC7WFCr/QsM+WKiiLEka69j7k460+zRPu63Wom8DhyfVL2XX7i56WOKZJuJt4WzDxKhFDWuyCyxG2rYOhFb8w4ufUU4MBc1zsGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876201; c=relaxed/simple;
	bh=b3bqMtt9jWyiyoPaZQqZv3RBGSbe9VljxicAH7xe9Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntxQMJkQJF3YJ84H18w1oMAtgo3l9LAq9HAXqF3pn395U/6NCqH7OQFQodvPX0bcLFqxX5RjD9FI4mzjawphC1VUN3mDZZvT/rquSY6WHlSvuORDoQnEsMIIar3L1lu7GD9VIwUUW7+UvJwXvCG7YKLtmQNgpEzHvF9CYjq21X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eg483RmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eg483RmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05173C4CEEB;
	Mon,  2 Jun 2025 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876201;
	bh=b3bqMtt9jWyiyoPaZQqZv3RBGSbe9VljxicAH7xe9Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eg483RmHN/FXRUW4Fydee0nq51Aly1oH3+OIagezGe2GO7ZHqvVT5janqIx4WMNZC
	 ydRiopMt9WXWju6YN206YWCpdjaiu2zCONfWP04OXif40zcduozdZ+0aXHjgeS06Cl
	 G4GsOoQBzKOSJfo7+1vamydtOUQdf1xIEZ1f52cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/207] firmware: arm_ffa: Set dma_mask for ffa devices
Date: Mon,  2 Jun 2025 15:47:38 +0200
Message-ID: <20250602134302.105058988@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit cc0aac7ca17e0ea3ca84b552fc79f3e86fd07f53 ]

Set dma_mask for FFA devices, otherwise DMA allocation using the device pointer
lead to following warning:

WARNING: CPU: 1 PID: 1 at kernel/dma/mapping.c:597 dma_alloc_attrs+0xe0/0x124

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <e3dd8042ac680bd74b6580c25df855d092079c18.1737107520.git.viresh.kumar@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index f79ba6f733ba4..27820a59ce25e 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -190,6 +190,7 @@ struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id)
 	dev = &ffa_dev->dev;
 	dev->bus = &ffa_bus_type;
 	dev->release = ffa_release_device;
+	dev->dma_mask = &dev->coherent_dma_mask;
 	dev_set_name(&ffa_dev->dev, "arm-ffa-%d", id);
 
 	ffa_dev->id = id;
-- 
2.39.5



