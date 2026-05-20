Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F0406269;
	Wed, 20 May 2026 18:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302985; cv=none; b=KgQrjlAUvLPpbG9zvPDf8Qet+qrnj4nJW+yYjc3cyRCo0jVip8IrZCJO7PO5QvRO+pGqqmeFMSci5gSIh3Ye6GtZ9QFf10p9dYY0v9TzT/n6fyNc+RAXhg5ITQHvl/7mOE1LTS+3S8JvcV5aO5mcVOmzi8bIkOGoxHz0Va7Ghiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302985; c=relaxed/simple;
	bh=HArxH/rgybhClQC5qGsiuUMoJJBPI098k07/PfiJsjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebOIRwTF3aZoHkQwFXGlbI3nPaN6RUcYb6tNFZLJkwHPk3AfLZBlfAMGX4CQ8F3Fihl4FLRb+c4Ey78B9AWBE/txT0RSGGV71smw6YeA5Fueihz52vJETXdNfSwqfe8axRvc/OvNMEk2EA6fMjFNZryXG/T1nXwUKZqzoq+aA3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aInmct1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aInmct1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423691F000E9;
	Wed, 20 May 2026 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302982;
	bh=z+D6rLMaUl3d5g+Bun7IiW2AJCzsgqch9aRyGj3XwO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aInmct1UotsA9Vbj8FV9A8Xnwz2Fvaz2wm0HNU54SG7kv9N1XHV9L8XLdrODB7uPs
	 8d7WII0htuH+pnR6h3YaOXrlPqQkj3GPr01ymE65Gx/O7xLrziU7qeHSV8WdrcSHhq
	 eePAm6HOS1ZBSLzamFgRHETJhq5UOhIHAanNoymU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 472/508] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Wed, 20 May 2026 18:24:55 +0200
Message-ID: <20260520162108.823146165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -292,6 +292,8 @@ static int pika_dtm_thread(void __iomem
 		schedule_timeout(HZ);
 	}
 
+	put_device(&client->dev);
+
 	return 0;
 }
 


