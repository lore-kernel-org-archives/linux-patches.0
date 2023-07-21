Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701D020F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3721C433C8;
	Fri, 21 Jul 2023 19:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967369;
	bh=4xK/OvB/T0/GZx7efTv9a9Ti0PyEP6YYLSt/NMJfXJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjWvppJIuMgmrTZmTTVlI8TZ2SpXwmnIeDRCEZzoyLZVwraN15zCEOnhsIHpI1Lg5
	 p8iZWlFElge7X6qj2z8OFjCmXWAK/0nHzI055u6t7LlX+txKhkFPTpzyNYfea3XNjL
	 zm2O3Y7ioxFzu/GjwCD7eaixgdbqHlcCSYsIY6JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 137/223] fs: dlm: return positive pid value for F_GETLK
Date: Fri, 21 Jul 2023 18:06:30 +0200
Message-ID: <20230721160526.715668507@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit 92655fbda5c05950a411eaabc19e025e86e2a291 upstream.

The GETLK pid values have all been negated since commit 9d5b86ac13c5
("fs/locks: Remove fl_nspid and use fs-specific l_pid for remote locks").
Revert this for local pids, and leave in place negative pids for remote
owners.

Cc: stable@vger.kernel.org
Fixes: 9d5b86ac13c5 ("fs/locks: Remove fl_nspid and use fs-specific l_pid for remote locks")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/plock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -359,7 +359,9 @@ int dlm_posix_get(dlm_lockspace_t *locks
 		locks_init_lock(fl);
 		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
 		fl->fl_flags = FL_POSIX;
-		fl->fl_pid = -op->info.pid;
+		fl->fl_pid = op->info.pid;
+		if (op->info.nodeid != dlm_our_nodeid())
+			fl->fl_pid = -fl->fl_pid;
 		fl->fl_start = op->info.start;
 		fl->fl_end = op->info.end;
 		rv = 0;


