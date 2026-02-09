Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459C435CB6B;
	Mon,  9 Feb 2026 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647239; cv=none; b=WRbXWCreQpkXfZf2w4JFioIW/JtZ61PKrLNEZzYeduK+58s04tHuRMfzRzpD3U9H+LtddWtMhE7lkiChMfBZXlxU2JPtGv5p3TR52HkGb8SrAjb3ANCiN07ypzAOPF27hY/KZxS3F5IIDPYuvND5i5mLScNAZwWNTTVVxMIJtio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647239; c=relaxed/simple;
	bh=SwYR0yOiEYF9+utkLVP0QbJnRRb/kleqIkL4gxy5NIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYlgS/pyTKU7SWgZ2qKe0/8fTKQofx3K/4gukvU/r2r/mHsEGsvnCOUGVYraDl3HmYPd6tYOCkCEsgSwzw1pqvjLXPVcGse1ER/08GSc6FE6/xr0hyGHJ3QqPbTWkWdD+a2zVfZMfu+ymWpIL/RHSoB0NJtrX4MSaO4px2O+lJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6EGEsQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6EGEsQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61E8C116C6;
	Mon,  9 Feb 2026 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647239;
	bh=SwYR0yOiEYF9+utkLVP0QbJnRRb/kleqIkL4gxy5NIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6EGEsQKFBlBGxOXvbNNYRIfKivztujpXuAG1iwWJJPlmrVfSksXXdCjJ12OfILIW
	 bOcrdaBTVYKkgj1UCux/dXzDa5RVoyDEOdavArBecV2NjgBB0NjPFRt6ZmFhLCBqKF
	 STWpUMlg3i+kmzWd/+8eSoiZvn7cyxIXq4/0rY5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.18 040/175] sched/fair: Have SD_SERIALIZE affect newidle balancing
Date: Mon,  9 Feb 2026 15:21:53 +0100
Message-ID: <20260209142321.917660634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 522fb20fbdbe48ed98f587d628637ff38ececd2d upstream.

Also serialize the possiblty much more frequent newidle balancing for
the 'expensive' domains that have SD_BALANCE set.

Initial benchmarking by K Prateek and Tim showed no negative effect.

Split out from the larger patch moving sched_balance_running around
for ease of bisect and such.

Suggested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Seconded-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/df068896-82f9-458d-8fff-5a2f654e8ffd@amd.com
Link: https://patch.msgid.link/6fed119b723c71552943bfe5798c93851b30a361.1762800251.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11744,7 +11744,7 @@ redo:
 		goto out_balanced;
 	}
 
-	if (!need_unlock && (sd->flags & SD_SERIALIZE) && idle != CPU_NEWLY_IDLE) {
+	if (!need_unlock && (sd->flags & SD_SERIALIZE)) {
 		int zero = 0;
 		if (!atomic_try_cmpxchg_acquire(&sched_balance_running, &zero, 1))
 			goto out_balanced;


