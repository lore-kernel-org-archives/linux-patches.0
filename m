Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C923EAC83;
	Wed, 20 May 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296652; cv=none; b=pYiA4DZz6Fruw4nmleUGT06OJZn8A7GVG5hOGob4RwM8PsyaHozzolaaeYlBJ5ljxIsTtuevVple9mIgiogQ3LveNcwMwIEagbRbHbLXoIAoVkEPiad7Npa41KVBVCTf9LtIRyrVoh4JLAuAUvagw8qTkCtwvShDvqBxxboyP8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296652; c=relaxed/simple;
	bh=tOV5gSa6AmoJTWyfkGc2lPjlRkAqXyIvoMbEvn+XJ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3brWAN7KpTEqYiyUPYz6MI58A3tfJ2q35OopFtlqG2iQ6T4zhdxp+F12VR5iEMWQRh6oD/vKjdrHankt/L43Xs3icd4US0bpBzcd3rnOdFbGrTaNPD60K8oYU0gckEHT1D33cRUS6l7nnReEOxhFV99iUUlajIzgvDtshBxBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoVA7edK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoVA7edK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BBF1F000E9;
	Wed, 20 May 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296651;
	bh=UEb/5eje90bEF4am6jcLyVRIgBKfrVU/uVoOSFKTM2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoVA7edKMGXz+wlZyWM6D6ziAYJNhdBzucP3C1UZvNVi7EuEkWzCltlOhvMpJ06Bn
	 IilvpuL3YpCHuhi4WRnASEI31Jq2uRgysxYYcwmFCp2ZUKqq5+wpemMOUS+vg6YgIa
	 8vcDECcwIM7XD+lKTsAxs+gMqDTpLPb0K7E8gkzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	cuitao <cuitao@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0881/1146] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
Date: Wed, 20 May 2026 18:18:51 +0200
Message-ID: <20260520162208.176926555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 09258eebb5c74..7d21a0db3cef0 100644
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



