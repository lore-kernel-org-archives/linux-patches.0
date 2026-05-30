Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFD92E7398;
	Sat, 30 May 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166745; cv=none; b=UC6WQPqW8W2aTlSKXSMQo2Y1OwqsgXQ/SEor7L6gsiD0YUMHd4DMVdpVAHMUgtwew+6Hb6+A0Z/kmQG/40mEF0KE22ZVMXmb8hpaQvcOwyk9H+RhcLp0tmNqx7pvfDbYaZHb8EtxPStOK85A97C+0ssa+AsUDMqKQc9iSjSvQ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166745; c=relaxed/simple;
	bh=odffVqWDLzUQ+Gmse39Q3LZ9kMTVtUk06Y0bo/0caEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYd9Rm3pamnLr0uSV0TDhJJLowAxWSeXD1CaNvcFHL1SJdFqDeQ4Z/tfGTb0dWL3sn6JKSag9nTU/E1NTYZCUe4pVXkhIQct77/UsyJBNBvFaKUO7HtOwV2y2p/D6oqUQOxS3KnjUIINK8K7+l03CngErlm9qyEXKYFc/WDIxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir56+AmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir56+AmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285971F00893;
	Sat, 30 May 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166744;
	bh=Y3m3t0T6gV96odeY1JX70mRpGxpQbKCIuk4fK0sk0VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir56+AmE7qkvH91ziHJsrboNkytxRHuPoomGz/LpXphwFCQGz7ai1T6vKepwKPRtz
	 0+hMqWNEpEH04265b54RS0VS0ozb97chydY2lueHEj5NF9r949y1642TzbTqrFvhVD
	 0pzRDnmfIroG3e5FMfxiAZ2FA6DjTMz5xKCTEgiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cuitao <cuitao@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/589] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Sat, 30 May 2026 18:05:39 +0200
Message-ID: <20260530160236.715778023@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae042c347c640..b52ee28be3455 100644
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



