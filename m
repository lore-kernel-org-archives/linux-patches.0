Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7477820F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E864BC433C8;
	Fri, 21 Jul 2023 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966838;
	bh=edg6UkgKYLS5pK85NQ0bKz3X7ep0m+uVIjaSywVztWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGPZtJzIeYvUtucjjCgEmLbNYLduFTEsaum7NDC6ulfk3tVUSHAAjd1X6lJ+wAQlf
	 QtVxDTfdtQkZb9x4L1c7N3JMCjakC7EIhJimZApUQ45AFmnboaLpaBOhfI0UKXwF9g
	 Du8/fs4S3lmCUfCa0xmR+MbO3knTTs9YpsPTvCZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 486/532] fs: dlm: return positive pid value for F_GETLK
Date: Fri, 21 Jul 2023 18:06:30 +0200
Message-ID: <20230721160640.864309352@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -363,7 +363,9 @@ int dlm_posix_get(dlm_lockspace_t *locks
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


