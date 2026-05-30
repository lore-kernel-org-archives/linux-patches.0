Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88439A7FE;
	Sat, 30 May 2026 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164582; cv=none; b=U38ds8Ya/QR5VQ6/E8XGQqR396yitIPup9NxUATyCIwx+pXuf+FcnC8W98UObM71w6SY0fhfLtM+HScuh8Y0xzvo/xwJ7/1ZsMHz7N3oiCXx99cYGnP4Ar2toUfbzoK4A3jhMl3x8q2lQr8NSzhqK5HlWHIjBMk77LZWyv+3G8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164582; c=relaxed/simple;
	bh=gk9Z220mPp3ozQXUQvS0U8IJ1V9hYQL6Tui/sIej6bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pM8HW+Q9/pPtfxVUW5m2tYAG8XeTbQG+w90cxrU6Ppl94rQ7peeP8fwg3J41dMol7TjCJnrAL53AwxIPYUEWwz+KU2pwWIhGCxRhVAW1Pmp7Rz3/1YJDRzp3318REnxQp8BQYVGNZhSnxsSUsK+hTVbKbIYmVnJY8uVlIPbCNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8sxpJlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8sxpJlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B81F00893;
	Sat, 30 May 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164581;
	bh=vQ3CAgIWrYQeSUFyQV64WysbFd7lgPvjCwtkCeERhmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8sxpJlKJyYbkAFCHPOOC1cpFDuOKq2jio0/+wbLDRbOYxTuLvrlPBQR98d5/BvPk
	 MiYPJIKrMO2lsCz4O6C4bCMhRpEHOWs4JIfnYFF1sCaqcE34STOGpYnnWCQtL9pNjj
	 9W5LU18o6vpNthxAZMo68eyTKYXH8uw71JszjyHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cuitao <cuitao@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 598/776] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Sat, 30 May 2026 18:05:12 +0200
Message-ID: <20260530160255.493285769@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: cuitao <cuitao@kylinos.cn>

[ Upstream commit c802f460dd485c1332b5a35e7adcfb2bc22536a2 ]

The expression `rpool->resources[index].usage + 1` is computed in int
arithmetic before being assigned to s64 variable `new`. When usage equals
INT_MAX (the default "max" value), the addition overflows to INT_MIN.
This negative value then passes the `new > max` check incorrectly,
allowing a charge that should be rejected and corrupting usage to
negative.

Fix by casting usage to s64 before the addition so the arithmetic is
done in 64-bit.

Fixes: 39d3e7584a68 ("rdmacg: Added rdma cgroup controller")
Signed-off-by: cuitao <cuitao@kylinos.cn>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 3135406608c75..3265fbbbe7e29 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -281,7 +281,7 @@ int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
 			ret = PTR_ERR(rpool);
 			goto err;
 		} else {
-			new = rpool->resources[index].usage + 1;
+			new = (s64)rpool->resources[index].usage + 1;
 			if (new > rpool->resources[index].max) {
 				ret = -EAGAIN;
 				goto err;
-- 
2.53.0



