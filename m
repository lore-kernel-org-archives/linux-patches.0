Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304CE3F825C;
	Tue, 21 Jul 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654729; cv=none; b=jZONTPI39Cm/w/EU4CZJkNewk3EaIxIH2xvATHUwlPBtr1aHjvozHo3cfgkzqsLlKLxAE4wvuZnpPCPhqdfnKP5lvyckaKIeJc4LqGCf8tAxKKgvLCoqTrX1Au06remMRdVWi/Ls35IUwv24XAdQCtD/FTbUw3oIPvIMr57ojSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654729; c=relaxed/simple;
	bh=Oc72/ExP0CTE+u2O924R46N2VwGAToEMLWWolw6yWkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwjrkBO3Mly4G+K86Z723lArfQs7HCA3fifn14e2uYa1ZD8ErcpcgiuoaXFpZLb/xVsiZstx2ZJl+DRgWa+9YbqBoFG6bwCDc7nELXzyKPzfJMO4wc3vqlOK2LEju41BOTIffsT0qwnskNVTBwrMScvMuJrUYEcLBekdv3/9dMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDQgFsSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDQgFsSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810031F00A3A;
	Tue, 21 Jul 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654728;
	bh=L5XES8sqymhcM+GGhap/hayl9/RKEzWjNdlegdoz9sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDQgFsSrEN2mZQKGgigvYVQn6wSe2lKlPW6d83e5/i4b5VtbIcfOg/59TN7mTeQlT
	 PEEgkJ00vkL5HwKbaRpQLWVT3jN2k1B3ngz+40ra68MJI75NtGeI+xrae/mW3NIO7c
	 AvCFzrSEezmIrLOQme/XIPSqmjrdmXo8HP2RxJto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 1816/2077] nvmet: fix refcount leak in nvmet_sq_create()
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152635.580534903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 34b9a83c50660148bde01cde16451dbe78369749 upstream.

In nvmet_sq_create(), a reference on the ctrl is taken
via kref_get_unless_zero() before calling nvmet_check_sqid().
If nvmet_check_sqid() fails, the function returns the error
directly without releasing the reference, leading to a leak.

Fix this by jumping to the "ctrl_put" label, which already
performs the necessary nvmet_ctrl_put(ctrl). This ensures the
reference is properly released on this error path.

Cc: stable@vger.kernel.org
Fixes: 1eb380caf527 ("nvmet: Introduce nvmet_sq_create() and nvmet_cq_create()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -944,7 +944,7 @@ u16 nvmet_sq_create(struct nvmet_ctrl *c
 
 	status = nvmet_check_sqid(ctrl, sqid, true);
 	if (status != NVME_SC_SUCCESS)
-		return status;
+		goto ctrl_put;
 
 	ret = nvmet_sq_init(sq, cq);
 	if (ret) {


