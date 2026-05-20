Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2792E3F7ABB;
	Wed, 20 May 2026 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299897; cv=none; b=IHzhn/2EIiTU309z4GFOrYry7eGECo6V6ZdFSfCzpMc6R2Q6taNSqs2YaOGrQJyj9yxWnjYYe/9L8Moaq2qvRJzwJ72hCZQo3vDw0/+1O+553yTn3wuU6ejWcaj33R/pcnHYq3Kqey4Gr8pZQ6PBizB1Mx4fEfvrQxkiSw9GUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299897; c=relaxed/simple;
	bh=IZmtsA15vjSS123QNly4oma//P9iIf6Y2wM5ee6+hEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srSWgC8eyEkg9dtu7avaFuZ7xHVs208jfyP8KA4k+//H1QXWjU9BaoKMD+90CoNPyRsPiUmYl+f2BbJRw/ZvJi/+M1aTJisIWhanoXEwYMm44NBEUZV1X4z/+g/9g07vwbuMMdj05siErCSrssNjpIzMQ3Sqm4see2d84wbk4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLwPrdrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLwPrdrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EE51F00894;
	Wed, 20 May 2026 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299894;
	bh=wqsfiqCQcRVG9n8zj2aZ6nzm831zCG1wuZMgpm3aOdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLwPrdrTfgAgtFSqLedkO4FyEyCDVRlTylkvANwgG3/LuaizT4vz+qt3+MPJGZ0S1
	 3NBqP/y5quD/UFw4KTnpnCy6OQFcaNGv7em3f4KLnzPCvjYa/Mle2ApTWRQXWPxIpL
	 ahkpqNHYzvC1cI03KJFjtHIoBGX26SBDb+H7xtVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 925/957] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Wed, 20 May 2026 18:23:28 +0200
Message-ID: <20260520162154.644161318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 108d7f951271cbd36ca36efc5e5d106966f5180c upstream.

pika_dtm_thread() acquires client through of_find_i2c_device_by_node()
but fails to release it in error handling path. This could result in a
reference count leak, preventing proper cleanup and potentially
leading to resource exhaustion. Add put_device() to release the
reference in the error handling path.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 3984114f0562 ("powerpc/warp: Platform fix for i2c change")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251116024411.21968-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/44x/warp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -293,6 +293,8 @@ static int pika_dtm_thread(void __iomem
 		schedule_timeout(HZ);
 	}
 
+	put_device(&client->dev);
+
 	return 0;
 }
 


