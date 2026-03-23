Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE438C2CA;
	Mon, 23 Mar 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277030; cv=none; b=cWvbW+3/IMmobqI4IMP2QyUHTuJV84w/01Oqrh8PUO/HO9d5ji7iusIksV3cjrr4bmEiU8yRmDm7xGexiDlX3oiRUQlv8nLgL5niIg5DRHRHpriAWQtqEb012w98YuH7UypFnfXFtuWNg9I+26+9AfhGCEknbmedTlWCWg/kHpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277030; c=relaxed/simple;
	bh=xvhPYug+fHnpkMKd5UMVyXxPuwPWgReJQO9RfH28ukg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA3RgAQDE+eyAkEsJQ/1ScwawqihI6LCrOV4yd2HKpSIbTAI2VTs3BaDzo8Op62DWbDtmuYWxkMSGaYcvAIbYVzq3WsVkox6l4RmwvD0rN6riOaUZOcquzagcKvSX4C8mMVVJP0VTXWuMzPNYRoSv60eQbI/WGM9EQjHNfariXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ8Vc1K3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ8Vc1K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CF6C4CEF7;
	Mon, 23 Mar 2026 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277030;
	bh=xvhPYug+fHnpkMKd5UMVyXxPuwPWgReJQO9RfH28ukg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ8Vc1K35rEyO2uK+1y/uYf5vNAanPyK7CuZhdMtBzdHXOHIjc+OnQaQNvTBbDABt
	 /CeVWFAO/SfgHe69m9xlSGtf9o8CDGUVY4RYxwydbd4IAWMEaW8JHwy01QKMvMtNiE
	 mC7uoqI3rgKQ+AdZwrklvdqLAazOuVYZ0/vymsg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 296/460] sched_ext: Remove redundant css_put() in scx_cgroup_init()
Date: Mon, 23 Mar 2026 14:44:52 +0100
Message-ID: <20260323134533.758864579@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng-Yang Chou <yphbchou0911@gmail.com>

commit 1336b579f6079fb8520be03624fcd9ba443c930b upstream.

The iterator css_for_each_descendant_pre() walks the cgroup hierarchy
under cgroup_lock(). It does not increment the reference counts on
yielded css structs.

According to the cgroup documentation, css_put() should only be used
to release a reference obtained via css_get() or css_tryget_online().
Since the iterator does not use either of these to acquire a reference,
calling css_put() in the error path of scx_cgroup_init() causes a
refcount underflow.

Remove the unbalanced css_put() to prevent a potential Use-After-Free
(UAF) vulnerability.

Fixes: 819513666966 ("sched_ext: Add cgroup support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4319,7 +4319,6 @@ static int scx_cgroup_init(void)
 		ret = SCX_CALL_OP_RET(SCX_KF_UNLOCKED, cgroup_init,
 				      css->cgroup, &args);
 		if (ret) {
-			css_put(css);
 			scx_ops_error("ops.cgroup_init() failed (%d)", ret);
 			return ret;
 		}


