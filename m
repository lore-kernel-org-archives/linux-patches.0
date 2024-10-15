Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C81D4154;
	Tue, 15 Oct 2024 11:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993266; cv=none; b=SH49O9AeTo6JrD4o/1hhi1XzDqrwmCIRIXZ4+ZJoARKLrA5nLaoMAXI7KV/qvtKwuq6KuFAxDNZPG+Llg4rm3WNWR1cIjYAUYwN7U5oxo4c6rDZxJZV+Qn43rE/d7YMzX8lL9FaTdmMU5rIdM8Z9sYLcBywlTdPBaJ90mW6LUw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993266; c=relaxed/simple;
	bh=VXBsXgnhx2H1kOTtRBwKPCruk+IKM2aCpefXg6KjxOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCdGAghX0qb3QVUDZgc24Fl8V1G/lA6cUL0SLmDSmc48DG82SWecxTBdGLFNI+pHAUTk4rPkt1M/heDNE0Glkw/InQkfj+SNSmlcdwRZGXm+NMjHyplSWYgXr9i4AEVeHVEkf6gT0+PuzuoX+Hf/TAemDwlyn0mzDNgy5ItzVsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pG9Own+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pG9Own+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBE9C4CECF;
	Tue, 15 Oct 2024 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993266;
	bh=VXBsXgnhx2H1kOTtRBwKPCruk+IKM2aCpefXg6KjxOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pG9Own+rJ398f7QmMVcs58xvIACMvaNZCY922qyMeRlDVD5crBHjWQvisVGgXwzfJ
	 SgdWKFmBdcZtWUTRxxsc2nt7Axkby1l68pncgjkUfOjM3dQT3vffQ2IrP53Cs/F0oh
	 tSeE8NJW5TkBMNxQzYxKiy/A3zeA63w/FNDSKZiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/691] pps: add an error check in parport_attach
Date: Tue, 15 Oct 2024 13:25:09 +0200
Message-ID: <20241015112454.673159824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 62c5a01a5711c8e4be8ae7b6f0db663094615d48 ]

In parport_attach, the return value of ida_alloc is unchecked, witch leads
to the use of an invalid index value.

To address this issue, index should be checked. When the index value is
abnormal, the device should be freed.

Found by code review, compile tested only.

Cc: stable@vger.kernel.org
Fixes: fb56d97df70e ("pps: client: use new parport device model")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20240828131814.3034338-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps_parport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index af972cdc04b53..53e9c304ae0a7 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -149,6 +149,9 @@ static void parport_attach(struct parport *port)
 	}
 
 	index = ida_alloc(&pps_client_index, GFP_KERNEL);
+	if (index < 0)
+		goto err_free_device;
+
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -159,7 +162,7 @@ static void parport_attach(struct parport *port)
 						    index);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
-		goto err_free;
+		goto err_free_ida;
 	}
 
 	if (parport_claim_or_block(device->pardev) < 0) {
@@ -187,8 +190,9 @@ static void parport_attach(struct parport *port)
 	parport_release(device->pardev);
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
-err_free:
+err_free_ida:
 	ida_free(&pps_client_index, index);
+err_free_device:
 	kfree(device);
 }
 
-- 
2.43.0



