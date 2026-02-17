Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7FD261B70;
	Tue, 17 Feb 2026 20:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361643; cv=none; b=Pj0eocDle8/9Klu1W+W4CJ16swxyBhzoZvm/FMklxqcRx23gDDfGg8tNLs4HQEIEpiO/HRVaAox2QwBlaNarwyMDKjoXgeNcYXkweSnKKoL7PmRiPEQIf744l9Vg1R+qlmXiCfBNmVBeRYfPburaS/kjHc+seSO26l782LU9XAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361643; c=relaxed/simple;
	bh=02WGYaTOUg51gglPRkBrZ0SVIZM5MfcxPNGdD//MjaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrJPwRa/3lNT4t18ZL/V+jZqU6Db3xNtahCiQ/HAiAyKS9iFmlnyB179tEd4+xlzokKdEnJKXLL2cl/FIBhl3xtwdsxquzFO0Sb+T+Gu2oJVt/AH8j4XjSetRMaKUCoJnQctDzkxCt2rzsN839hmTRLoZVP+R838X4c9r3IDz6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dQACNaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dQACNaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E1C4CEF7;
	Tue, 17 Feb 2026 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361643;
	bh=02WGYaTOUg51gglPRkBrZ0SVIZM5MfcxPNGdD//MjaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dQACNajxWJ8LYJ1zEoidGMP4bFVnusKJdFKM7hWmsx2d7mYj+1DYHhby1lfNWqRE
	 /NmvjKAXQry74Y8zwGTeumnIgSqrbWEn8nd7JAaRE6hv6oz8Y4nU1xcEhUvhz0nX+s
	 honRgvdYvOlz/vtSE2eTRAUMI9f4iUC2a150L1kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.12 32/42] cpuset: Fix missing adaptation for cpuset_is_populated
Date: Tue, 17 Feb 2026 21:32:23 +0100
Message-ID: <20260217200007.228384213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

Commit b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
was backported to the long‑term support (LTS) branches. However, because
commit d5cf4d34a333 ("cgroup/cpuset: Don't track # of local child
partitions") was not backported, a corresponding adaptation to the
backported code is still required.

To ensure correct behavior, replace cgroup_is_populated with
cpuset_is_populated in the partition_is_populated function.

Cc: stable@vger.kernel.org	# 6.1+
Fixes: b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
Cc: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -347,7 +347,7 @@ static inline bool partition_is_populate
 	    cs->attach_in_progress)
 		return true;
 	if (!excluded_child && !cs->nr_subparts)
-		return cgroup_is_populated(cs->css.cgroup);
+		return cpuset_is_populated(cs);
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {


