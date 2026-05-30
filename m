Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E63B263F44;
	Sat, 30 May 2026 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161790; cv=none; b=MG2scpzyzJvH1tvEa2oHO5wKIXDdi9fhRH5PVB5vTwvGbmMOH3aw1aXMrsjZk9c8TT41Kl6yEkQlSC+HmDCvqMVJgKYQeaBpS8VyfEHckB6IoVZXDQRCgBIt8g2mmtJk/aKDsL8BpnJh+VvXLBFXxcAK3sVz4gfanvd/R/GRNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161790; c=relaxed/simple;
	bh=TREyT0MxGa3VAyptw68Gj/4TA8KgRnqoJEHelUfgUaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+ud9ZTk/4tQZEKyfK9FshQs6iub6TOpYOZ2WceUGdKuYewVsTbwurpBfERB75KSuwf6D0BOeQ6ZlQLp1pBgFlBd6ziuXPpj1PkxKQQZU4IOfGPJyavyQX5l4HMiNMTSo/4vQS2YF5tLoFwK3qwfk6BCVCJWRBNo9bDXfWp5teU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvL5P3E+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvL5P3E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECE1F00893;
	Sat, 30 May 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161789;
	bh=oVFLohBmfTgO57S43zFa32Nk/AhLN74JvRHI3ho0CoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvL5P3E+xB5+stvS1w4Choe+BnZwurOPvtHp8YVoRec827NMtOrPBrwbir63o75Mc
	 D6O4uS7N9Tw5d0h3cqYmQSLHTePFqNu1/nTJX+Mj7bDK4ak9aKPq64qMtiaWzM7mNF
	 z33tVLxQirnUM5SAdqJ9Q/w9rsPT2vIgrufdZozM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cuitao <cuitao@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 726/969] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Sat, 30 May 2026 18:04:10 +0200
Message-ID: <20260530160320.589935755@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



