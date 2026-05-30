Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66D931F98D;
	Sat, 30 May 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164884; cv=none; b=PpdAl6NOSQ0cHwkKJoLWdPksu4eRDdT/hIZu7A+G+LmJGIgx6hElHav+JOxCoRivCrYIB6nv8Bn4y+xHFMPoE4OF59VbzngPDwzYnQcVjLeHbg8fJsRTf2zsYLoQstWsedlgvFLmSL/P2BfwYaf01jFia79M3zomy/RlAjtXmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164884; c=relaxed/simple;
	bh=WVtqv3iPdX78jQd3ZrAxsFBlsTWgzUhecw6ZplOqu14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDaz5oqFY1pq03D+rF79lim6A+B1AWGhkXa35gxDaG8MDeeVMp+Z2XoKRX8gjcs9q0Li882KlqnbjAZ5Kk8+eaA8Ti1fUEnUT9Eih3Es+XjxO4zC8FfPdUJY3Tl3vzjhg/9zwU/neui7Ff3nhDBPdwrmm2Mh9qeBJsudsRMRO9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUvqEuoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUvqEuoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFB41F00893;
	Sat, 30 May 2026 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164883;
	bh=qEUVOAmUmp9mlDNrBcCV0v50ll/0erij7mAD6zYh83g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUvqEuoJUInAIRaW8S2jm3DCUlUHdF6NtchMYP/dUAEuPV06r4dZRFNHybZ/5GfAM
	 NmEd9BJxeisY3jpeV2k9tsWdx3WDpEk3JhXcoDLrKQU3BxS9qiaih0Kj52QU36DHf0
	 getJzjYE2mLF/ny9QjjYiQ2ihKA493as4z3ylQA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 658/776] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Sat, 30 May 2026 18:06:12 +0200
Message-ID: <20260530160256.910641608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -261,6 +261,8 @@ static int pika_dtm_thread(void __iomem
 		schedule_timeout(HZ);
 	}
 
+	put_device(&client->dev);
+
 	return 0;
 }
 


