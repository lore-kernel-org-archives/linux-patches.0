Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30DE2E7398;
	Sat, 30 May 2026 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167021; cv=none; b=EfW4vePBzBJv3O/WYGr1LTZe9ZODoi5AbDcDO2EH3f398Z4BFQrSYokq+KpYs4xL7F5UKsqqUtD3Pxl9R5AE3SHmFaQsb7iICCi7UZLIENPV5aLs26ugj+fDBvu1sfyhWyOl7QnLP4ZZNYJK4IJOYrTG4rcg1OsgO+HiAOiGGNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167021; c=relaxed/simple;
	bh=TI8a9Whhbbckwx+dz/E7q1yzS1EGXz9++X/gugs3ksA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRMCMdxtefOi9Jm3N8Kb1/ZpcUxeByIKM0LT4NOJomuFBM7CmGHz/ePAgUllZeGWBbddiu/ne0gidGpkmKFJFIGW73vElUW5t0htVpeB7RClgTxu72/bw/+N6y/wrWZ6PUURqHCUIfXUcZoo+JZFtpsIlvm9pTBr8DA6IrTvN9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJqgXdUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJqgXdUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124B11F00893;
	Sat, 30 May 2026 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167020;
	bh=EyLfYNrVj5LRtZ2eSIEvZd90UkISaF0IRlRGiWcpVhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJqgXdUXoO6Y869JPw9aDfs8SQJx9QsISYzFOdtoPKRVThfuJjrdzJmDXDI+QkEIK
	 XpQVaPB7/kXjbXC8n15fJqRQSLbr3U+I1E9ZJQCMQj100WwAi8CXfc+v8OEcpFTTWu
	 QmoUBPhzcnWZ3MA4hkopankHq8gdsQn8cJbj6hGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.10 511/589] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Sat, 30 May 2026 18:06:32 +0200
Message-ID: <20260530160238.041709245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


