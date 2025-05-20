Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4F61D5CFE;
	Tue, 20 May 2025 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750610; cv=none; b=pQ8RjNPgg4deWrcK4oR63rPsIrQeCbTe/aLG7MuV6hBc4nV/Radb939VNPtt6FbHW5JfInvY/PeZOaMhsL4Xunn2dOzJ6WV3vXnHfI0xArx6x1ILKfLdkuuIcQXPKyDGlchzGkjpLYrEzh+dsT6nSgMwPbzIWcIbzw7jrvpQtXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750610; c=relaxed/simple;
	bh=uc3qGyPx1EDDTmwhe0JyBKNGlmgmr5OzL20DQLXwwdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNjZVghwZk+bVPnBAjWfVxLNRhPP0VwQDTJ+RqyPGtEts9qnj5txlQhv4pnT4sQhzGPImUZEdkBUFcCFv5uJDje6XxZ0hUC3L0I8KjTk1QLROBg5U0gZNvzuogKWxDfwXLOajG+jAwkplbR0lseawoL45qQK+qrt0fzF6H2akhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZPyUHMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZPyUHMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D247C4CEEA;
	Tue, 20 May 2025 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750609;
	bh=uc3qGyPx1EDDTmwhe0JyBKNGlmgmr5OzL20DQLXwwdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZPyUHMmsYuw3duy28QZZq2zGS8DC3lNYxrWKoN05tgjRrinANYOP8KS9yMv/934e
	 d7DIYVtB5/SLx1ANexj/Qpf1ijK+p3cTXk9oGbXVaRIRSMYlnBMhXZgKXhwH++UHqs
	 iHoNux+qA4zxIGtIcUbGd/uFJ7WaNOTuLIMCrdaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 6.14 064/145] sched_ext: bpf_iter_scx_dsq_new() should always initialize iterator
Date: Tue, 20 May 2025 15:50:34 +0200
Message-ID: <20250520125813.085614982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 428dc9fc0873989d73918d4a9cc22745b7bbc799 upstream.

BPF programs may call next() and destroy() on BPF iterators even after new()
returns an error value (e.g. bpf_for_each() macro ignores error returns from
new()). bpf_iter_scx_dsq_new() could leave the iterator in an uninitialized
state after an error return causing bpf_iter_scx_dsq_next() to dereference
garbage data. Make bpf_iter_scx_dsq_new() always clear $kit->dsq so that
next() and destroy() become noops.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 650ba21b131e ("sched_ext: Implement DSQ iterator")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -7173,6 +7173,12 @@ __bpf_kfunc int bpf_iter_scx_dsq_new(str
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_scx_dsq_kern) !=
 		     __alignof__(struct bpf_iter_scx_dsq));
 
+	/*
+	 * next() and destroy() will be called regardless of the return value.
+	 * Always clear $kit->dsq.
+	 */
+	kit->dsq = NULL;
+
 	if (flags & ~__SCX_DSQ_ITER_USER_FLAGS)
 		return -EINVAL;
 


