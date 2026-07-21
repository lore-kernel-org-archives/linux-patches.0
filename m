Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D243846EC61;
	Tue, 21 Jul 2026 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658931; cv=none; b=pL1ZfhSVGezYVu9p242ic+dj/B5cH9Pio5DN8xP9ddQuvnmhmDaF/U6MY3kYJph5i11O/BqTwGmOc6n+ApNYVi/toK4+5M7Msau/O1vBS9nupvq+hqjfEWM/3zUABJWvK7DrW6PnG5EVUpGkLVWX1QnF0vWs89JOegEealWE9kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658931; c=relaxed/simple;
	bh=7TVz3Zt5nZn/vOatxxmQEUy3ktz5Auu1rgMdFE7dDXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjDVytyMAf/4N+CWtuL946tNnM9LnUF4zQo3QOEx4pl3zFguV+ykxpsd+4IVjbSKvGU38lovXXJxZTzimkwnKWubP+tS6DcWq6PP7/zwkmsj8a7YtX4ERNMtQfWDda1Hl/IhzRX6OK8BG62dxse7bVUXOL6WKcEqO+OhU4SJyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evqIRAGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evqIRAGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4379F1F00A3D;
	Tue, 21 Jul 2026 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658930;
	bh=1jjuVhZJgqEYR2GIAQRcNsmOLFWUoMuoB7XX02w025M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evqIRAGKetj0QVTwogNP/cFTF+BU9wCN07+8R8Ck9/QNvYNfgIpkWod/aVPtcuXCf
	 nTKdzZeTC3/Hxn8NR4kq2KmcMbfVpQ9GhX8cn3ug3j2eRvIoNfCOSHEKPO190UZjYf
	 Vo6viDXJ75wiU8T0zRrzw4WJM6KBTfGhpUSdCH7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 1329/1611] nvmet: fix refcount leak in nvmet_sq_create()
Date: Tue, 21 Jul 2026 17:24:05 +0200
Message-ID: <20260721152545.345806913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -935,7 +935,7 @@ u16 nvmet_sq_create(struct nvmet_ctrl *c
 
 	status = nvmet_check_sqid(ctrl, sqid, true);
 	if (status != NVME_SC_SUCCESS)
-		return status;
+		goto ctrl_put;
 
 	ret = nvmet_sq_init(sq, cq);
 	if (ret) {


