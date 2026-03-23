Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A4521D00A;
	Mon, 23 Mar 2026 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274069; cv=none; b=ZuaTRi0HgoONqLxsophyYIbJvcqwYuVerKehPkbWpJqZ927Qyt5zeoXLPCRT5ezT2NinNBqZBdbbBsE7n7kCUTvw73lXh0QUrhMfQ+1s4XiEg3efLwwLyx+O+uO4s9vTWwoMDmxbpZBJCR+ge1qTo0NuOiR27Tx51V3HQWHygHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274069; c=relaxed/simple;
	bh=5KwO3ETGFZOr8BQ+LMPlQFry08CzGa6iMLXGuEWTojY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjI029oniNoZXjWhm19GwurO+7PbnDOVBviCRUejSJ2wRuf4UTV2Pp4kEw7BNg0xjVz2P2z8oPoxNOhuT/GLeSzWCvI99GqXGGAKaQ5FZTM5RWD1sL0KBzxz+g7VaEy3hVNxouJAAtJsO1UDFXxB++Y85X+EHLmbURBmrjSf1/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4WkVwBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4WkVwBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045FCC2BCB1;
	Mon, 23 Mar 2026 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274069;
	bh=5KwO3ETGFZOr8BQ+LMPlQFry08CzGa6iMLXGuEWTojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4WkVwBYxluRUFoVY5EbzJB9GWsvWEHiQv4KizvebZjYFrfXqkThG5uaEYOblS/ou
	 Uwr5MVQWD8NfX9lJ1plXAoa59VxEnTFpZEK4g0mS76rtfCIf/Xb00XVSiCtWg3f496
	 FdqYswpCZKiRA/MpWTNMvfMSs7k2O170QG1fhye8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 099/220] cache: ax45mp: Fix device node reference leak in ax45mp_cache_init()
Date: Mon, 23 Mar 2026 14:44:36 +0100
Message-ID: <20260323134507.728840985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0528a348b04b327a4611e29589beb4c9ae81304a ]

In ax45mp_cache_init(), of_find_matching_node() returns a device node
with an incremented reference count that must be released with
of_node_put(). The current code fails to call of_node_put() which
causes a reference leak.

Use the __free(device_node) attribute to ensure automatic cleanup when
the variable goes out of scope.

Fixes: d34599bcd2e4 ("cache: Add L2 cache management for Andes AX45MP RISC-V core")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/ax45mp_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/ax45mp_cache.c b/drivers/cache/ax45mp_cache.c
index 1d7dd3d2c101c..934c5087ec2bd 100644
--- a/drivers/cache/ax45mp_cache.c
+++ b/drivers/cache/ax45mp_cache.c
@@ -178,11 +178,11 @@ static const struct of_device_id ax45mp_cache_ids[] = {
 
 static int __init ax45mp_cache_init(void)
 {
-	struct device_node *np;
 	struct resource res;
 	int ret;
 
-	np = of_find_matching_node(NULL, ax45mp_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, ax45mp_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0



