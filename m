Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45C43BDCD;
	Mon, 17 Aug 2026 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978188; cv=none; b=a9plSgg7+vbj6EzevOfx7ndyOBhJ1UBsqYBAZkVvtk/E/69MNLq7t09k8GZYb1C2SZLsvbDfQFQrOHCuYCx/sRvnstogmpwMIZ5WiP28fx3txexagpv3Xma/ug1tT8sjPt2cLXU8H1OEGehcctZhl/NwRPujSwM0I2ptDn3dqNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978188; c=relaxed/simple;
	bh=7u5Pk0A+72MJAM0IdRkY4zILOQ2V3XPZJsmTIf6qzL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMqMn8yPUolRZa4zspPPjUFxmCoIYRBXN7BSkuee0uBusYr5YVW1dTv2N+rEX8EBg+RUSQZfeNX32QT5d+OpWNt2UCnQlEcrqZCmIN1BnwfztLKFYfNRpshpZ47ZI0paLYxZQIQ4OE3+juGDykCZa2m2HZ9QYmnIfkMj8b7KEaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jy/GUq0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jy/GUq0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB71F00A3A;
	Mon, 17 Aug 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978185;
	bh=yojqoJYZ/kfNSon7z1+lLbng2PBmClJeqyjuftEiWak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jy/GUq0xVoWF49+dQOGyHm3pMb4/yWePQgr3cBXkvXZhzkNlqCFooj/m9uoy1ZH+Y
	 zSS2dUh6Hj2PY4mfjHrekzHXrm1O2F5h6qvTACRDlL7sTcKPh/w+6AR34DZFS2+lK5
	 23OVoj2PYdLnKBw9icq++NE85/kyRogkvwRzb4jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 132/181] misc: fastrpc: take fl->lock when moving mmaps on interrupted invoke
Date: Mon, 17 Aug 2026 15:33:46 +0200
Message-ID: <20260817132540.805000389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit b85a0e91d7d6cd06a53c881a46f749cfcef416a2 upstream.

When an invoke is interrupted by a signal,
wait_for_completion_interruptible() returns -ERESTARTSYS and
fastrpc_internal_invoke() moves every buffer from fl->mmaps onto
cctx->invoke_interrupted_mmaps. This list_del()/list_add_tail() walk
runs without holding fl->lock, the lock that serialises fl->mmaps in
fastrpc_req_mmap() and fastrpc_req_munmap() everywhere else.

Take fl->lock around the move, matching every other fl->mmaps accessor.

Fixes: 76e8e4ace1ed ("misc: fastrpc: Safekeep mmaps on interrupted invoke")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1279,10 +1279,12 @@ bail:
 	}
 
 	if (err == -ERESTARTSYS) {
+		spin_lock(&fl->lock);
 		list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
 			list_del(&buf->node);
 			list_add_tail(&buf->node, &fl->cctx->invoke_interrupted_mmaps);
 		}
+		spin_unlock(&fl->lock);
 	}
 
 	if (err)


