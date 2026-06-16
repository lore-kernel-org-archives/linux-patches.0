Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD09043E9C6;
	Tue, 16 Jun 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624315; cv=none; b=uuvrYdYnUzNciK4IjY+VJO5BEBj5EU/Lk6AmNKGupyAhJfZBPfGt+nPuCVyoaCky37Wx9YYttoAeiJw0T7OLgeHJFfW6c87pmjxRc7Wq5XSAU7wjofy2L0u3c7HKY7EXM2KqOCfNbu+wtqJopSvPZA9aTPzFKcllsKu7aGpfJ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624315; c=relaxed/simple;
	bh=cwe31C5EpgOsUmLx//eyNcnHbfoIt7uFTfieVkJTvzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqI5IJfEQN2ZSNbB+1YZxLfjes4EvNLrFWXeU7gai6CTkcUbwM/Izj6c6gI5Vkyp6FFB9oflSdU+FOCu+Q3XjqbF8Yljc8Iivq3iGuNJ39IF3tHucXmfYBZcH9dLm6GZnPQUWBWo3SmY3MkRQ9ee0v0A9L4cg5lQ3GIdzr+xZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iRh/+uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iRh/+uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F51F000E9;
	Tue, 16 Jun 2026 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624314;
	bh=ksM0UTeX+f2XUVkEd8VdgRw5NGZaVl2nDU2pMMJBYRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iRh/+uyoqubaUhB/HX87QSjfJdrdXPj/Uj3U99KN1B3MZjoulmt4VjEBp0rPYxsP
	 /I5jZF+HOm1ixLTWAq4E3dKRett2BAMu8BbZKv9ADU0hSg9p+/Bk1EGpDubTomt1L4
	 4Mi7nJM5G70WIOV2Qy1LrnKlFGJuVSDbMCgCubLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.0 313/378] pmdomain: imx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:29:04 +0530
Message-ID: <20260616145126.722619479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit fba0510cd62666951dcc0221527edc0c47ae6599 upstream.

for_each_child_of_node_scoped() decrements the reference count of the
nod after each iteration. Assigning it without incrementing the refcount
to a dynamically allocated platform device will result in a double put
in platform_device_release(). Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 3e4d109ee8fc ("pmdomain: imx: gpc: Simplify with scoped for each OF child loop")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -487,7 +487,7 @@ static int imx_gpc_probe(struct platform
 			domain->ipg_rate_mhz = ipg_rate_mhz;
 
 			pd_pdev->dev.parent = &pdev->dev;
-			pd_pdev->dev.of_node = np;
+			pd_pdev->dev.of_node = of_node_get(np);
 			pd_pdev->dev.fwnode = of_fwnode_handle(np);
 
 			ret = platform_device_add(pd_pdev);


