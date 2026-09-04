Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D29A3E866B;
	Fri,  4 Sep 2026 05:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501405; cv=none; b=FB7MEcQKq0HWhZQ8qU16phRPk0RxSz5/Pu8L13zcsQAEodDCSm1QA8vAfiln+60OwNK706ViznF/dx+F9/YaHUc/xd/x8QbXL4Klxj6wxZu4ha5iMcgXfUBMCsNYRmE4RHdJOcqsANa8pEWy0ABsLOwyimyjUw4ba8sNLiGtKcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501405; c=relaxed/simple;
	bh=ocDAWXGG3h2Rc1EDJRxLlKoi+8/b2ziDJcy7RZ2l3IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI/EGLxQ4+Oag4llL2SVnel4Z1yQuP2sMAtAK7/jHOH46dwJ/NAz/NOw5La3yw7W6WWI/GFaphMgwFhoxpjf5LriPZujYLD0Yb+wg+akhrBqFaiDwF8oScqAdHDkRXxyfGf/myLgGEb/1Ih5CyzjtqBihRUj+Kgka55IwPfuxVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nnsm10KN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nnsm10KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3661F00A3D;
	Fri,  4 Sep 2026 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501404;
	bh=I0SGB0H5xsRKAzg4/yxhSravHfVZxaq/Y5xZQ0zzJr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nnsm10KNGDRunkvuWKJerGyrM8oKJVtaby6Y7C65QN/FGp8MCcRX11uUXsyqlxJYi
	 Q+/FAVWXEWjpgkDk/qEK4OF/j1WGMZevoNpFZT/RNy3M5FnRJLICR4s8IEQgUvvAJ0
	 aHFiZ9mxWhmUqBz16BVtitrxnf2INjva4rXGTpS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 355/552] nvme: nvme-fc: Fix nvme_fc_create_hw_io_queues() queue deletion in error path
Date: Fri,  4 Sep 2026 06:58:32 +0200
Message-ID: <20260904045758.289117956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Ewan D. Milne <emilne@redhat.com>

commit 22eb631bf86ee3246f47885e4fa94154a46863e4 upstream.

nvme_fc_create_hw_io_queues() will call __nvme_fc_delete_hw_queue() for the
last queue on which __nvme_fc_create_hw_queue() reported an error when deleting
all the io queues if they cannot all be created.  This is incorrect since the
last queue did not actually get created.

The most recent change to this code was commit 17a1ec08ce70 ("nvme/fc: simplify
error handling of nvme_fc_create_hw_io_queues") which moved the cleanup to the
delete_queues: label and changed the loop bounds, however the code was not
correct prior to this change in a different way.  The original commit
e399441de911 ("nvme-fabrics: Add host support for FC transport") had a
different error which called __nvme_fc_delete_hw_queue() on queue index 0 which
is used for the admin queue.

Fix this by correcting the initial loop index when deleting the io queues.

Fixes: 17a1ec08ce70 ("nvme/fc: simplify error handling of nvme_fc_create_hw_io_queues")
Fixes: e399441de911 ("nvme-fabrics: Add host support for FC transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2316,7 +2316,7 @@ nvme_fc_create_hw_io_queues(struct nvme_
 	return 0;
 
 delete_queues:
-	for (; i > 0; i--)
+	for (--i; i > 0; i--)
 		__nvme_fc_delete_hw_queue(ctrl, &ctrl->queues[i], i);
 	return ret;
 }


