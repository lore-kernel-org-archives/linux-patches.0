Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E02505A9;
	Mon, 23 Jun 2025 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685659; cv=none; b=XnYjIqQP5Pfr76nEdT4lJnz6rbsf9MLm+w3sdTF3qtcqAal0kbfKJj0cSXE5goN8OquUsXeYQee9DcIjW+h28zaAsbY2R0bTo+J+70JIcRxnxJACmj+hV6mT5118alFzC7CSxVvbvJewMxP5w/S8dcKlZnZvh4yZfsP1VIXTE2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685659; c=relaxed/simple;
	bh=5vyrZdVMDQsy04zO2iLUaZx52pVuFNgZ9NHkJVmKMPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fabWzuyW4q36Z+cSeQ6A3M+43ALciwfDtxmtR0lTySIfD7IO+QjWdt6lB1IAJ7Hywz5B2tkRC5BsLnm5sSIXPgWJzm5wbZNBcdyq2ViC7rgZM12kCNGRmZM2GA0/OlJB//v40pjUyWjR6IaAtX6ghVWHmtPBJ8cZPGe/lUuHVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkIgQ7Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkIgQ7Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04B6C4CEEA;
	Mon, 23 Jun 2025 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685659;
	bh=5vyrZdVMDQsy04zO2iLUaZx52pVuFNgZ9NHkJVmKMPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkIgQ7Ub0j3W+884Wb22wc3o8bNCIgE1eU2pv/5MS1xI4DyK7h7LyoY7amVDu9wNo
	 a95W+JmfQO5JBb8PapkO8XubYsEMHZobw7Vgin9KXnqvoTUUG29pv/+XbzlOV7Glbb
	 Ttk5OJW6Pdx8/tps0QUPa0Y8Ey/AfCVWRd+pYnKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/355] bus: fsl-mc: fix double-free on mc_dev
Date: Mon, 23 Jun 2025 15:04:27 +0200
Message-ID: <20250623130628.812089038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d694bf8a9acdbd061596f3e7549bc8cb70750a60 ]

The blamed commit tried to simplify how the deallocations are done but,
in the process, introduced a double-free on the mc_dev variable.

In case the MC device is a DPRC, a new mc_bus is allocated and the
mc_dev variable is just a reference to one of its fields. In this
circumstance, on the error path only the mc_bus should be freed.

This commit introduces back the following checkpatch warning which is a
false-positive.

WARNING: kfree(NULL) is safe and this check is probably not required
+       if (mc_bus)
+               kfree(mc_bus);

Fixes: a042fbed0290 ("staging: fsl-mc: simplify couple of deallocations")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-2-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index e329cdd7156c9..9c207f1c19fbd 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -800,8 +800,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
 error_cleanup_dev:
 	kfree(mc_dev->regions);
-	kfree(mc_bus);
-	kfree(mc_dev);
+	if (mc_bus)
+		kfree(mc_bus);
+	else
+		kfree(mc_dev);
 
 	return error;
 }
-- 
2.39.5



