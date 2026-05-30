Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B6340298;
	Sat, 30 May 2026 17:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162097; cv=none; b=VG5zTp4RJ81uKkPq53DT7Ghb6ZUSAziOhzCF59X6Yz90iI2iMpYhP2fro5fseIXRq5BZQaLmdmBoC7rLrwM/1RRlvP6TyG7Ax7a6WDWqNqNzZLNvy/L/qkgn0/hSOTmenOo4yQ5qf/jfzxakK8QayFzvSFx2NJv2RjdGEd9zvhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162097; c=relaxed/simple;
	bh=UGENDnLdU8z5uSnatV/JA5+QKWVzTfgT/LsVkDoj+Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMJEuAB9yrifb4CtKtkSe4fhiOU9OBS2HZLEl8WXAVCsOeV+XKXOWbKUxej6fzOv7Ds7P0iMpzk8EegPLhwhFIwztFNUJNsXHLJVbBaM3VLPtX5GsXB0ZfR+76GkszJ//qNzY84dPUcj5esKMVLuQVwreQt18Ec5W77o1QNmRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1t0AUWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1t0AUWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C531F00893;
	Sat, 30 May 2026 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162096;
	bh=5CgzdLXuJq0gwLI9smFavdo56qw7lE8E2mCylofKJT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1t0AUWKK2c1ULbjU731HhApTAzBfbbkT882Yuhm4HoM+RxK2obwHm09EVUdeNpOn
	 gCLsRKD2DEPW/hlPliKpKySoCZCI66bS4Sg1KVKKSVnbame6HcrVeTzs2tixEW93LH
	 nnbpjf/HnRo80kKqTsu6AtswYCDq+0TwF+q8/JLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 819/969] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Sat, 30 May 2026 18:05:43 +0200
Message-ID: <20260530160323.257987059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,6 +262,8 @@ static int pika_dtm_thread(void __iomem
 		schedule_timeout(HZ);
 	}
 
+	put_device(&client->dev);
+
 	return 0;
 }
 


