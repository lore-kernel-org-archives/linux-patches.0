Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D2611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC5CC433D2;
	Sun, 28 May 2023 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303116;
	bh=svX6p8RpOfbWOOhKfH6X87MPrUCKFo6yKVCFjmgu7FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdXYfIr9nZzvR+eSQwS9VM9Me8cnm1rvLo2X4eT/1pTP1y7pOLFCsGgIZx9ZDL1Y3
	 Bv8+CypDZ4g0zVWydNpx4mczx/5uuDrLv+Wvm6hOxCO15Cjn+BGd8kBHl8PeVHgQH1
	 TDc/aHJPbRH6ft7Sp6yAg5j/6+5BgloxK1K0fjdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>
Subject: [PATCH 5.10 161/211] writeback, cgroup: remove extra percpu_ref_exit()
Date: Sun, 28 May 2023 20:11:22 +0100
Message-Id: <20230528190847.502997819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Thelen <gthelen@google.com>

5.10 stable commit 2b00b2a0e642 ("writeback, cgroup: fix null-ptr-deref
write in bdi_split_work_to_wbs") is a backport of upstream 6.3 commit
1ba1199ec574.

In the 5.10 stable commit backport percpu_ref_exit() is called twice:
first in cgwb_release_workfn() and then in cgwb_free_rcu(). The 2nd call
is benign as percpu_ref_exit() internally detects there's nothing to do.

This fixes an non-upstream issue that only applies to 5.10.y.

Fixes: 2b00b2a0e642 ("writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs")
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/backing-dev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -404,7 +404,6 @@ static void cgwb_release_workfn(struct w
 	blkcg_unpin_online(blkcg);
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
-	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
 	call_rcu(&wb->rcu, cgwb_free_rcu);
 }


