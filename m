Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5D6409E0A;
	Wed, 20 May 2026 18:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302681; cv=none; b=ku0TEq/BIViQQN09L5NttXFsQuZ8rZiYxSzVTaeGi5nYtRFV+tRkNzP15823w4nBg89elpOiVWk1wx7+AXd07p2ROzt9Bw5SCMx0s0jlyZFjilLXW+FwYl4uqEUmrfzC3Ww/SqfgfkUicDiD9oO7ksmr20KHUY7QfVVqnIZtORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302681; c=relaxed/simple;
	bh=32hm4SuuJpHlpPogPf/anTxQ6/4GfBeg5sOKtvac4JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgrQcOQiDKIDpash02jd9UsonOmSQp+GnxiADPqk7keMABxKT6RHf9WB74QSyzJgLhIbALsgEeqmsFW4pD2dBoebge7kNABPHcpL8tzn/IhFaFl/sIR+Tj0ugpoXbMPID2+2zPSk9sGQJG36byxMHH65mwpZ0Ro5m+sfq2FtNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBrN9EKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBrN9EKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C753F1F000E9;
	Wed, 20 May 2026 18:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302680;
	bh=no6cdk581AZmSG444mUaaLDxsNvFyD5a65BS4oQ27O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBrN9EKBsupoLVFv3RlqzEmxpWqMDT1HB6ttb6KGlPzDU4x8V0krGfdermfhpe4jo
	 rUgP/Nz+FT7sIfvo6RY/kHu82vzIjFmGqu/2e3b0r990rdiQWa21hCcsWg81b+6RkK
	 EBAfuDwiqkGso216ZHSm7/86gtA5ghPbDib5/BwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cuitao <cuitao@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/508] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Wed, 20 May 2026 18:23:03 +0200
Message-ID: <20260520162106.431215918@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef5878fb20057..d544a747f3954 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -283,7 +283,7 @@ int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
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



