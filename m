Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6744A63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22DFC433EF;
	Mon, 20 Feb 2023 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901515;
	bh=LjnptQC/m9gst/345v1qhBUFZbG3h7rSVOpc8+YXL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lW+j4ZtjTReX7x+qdt6LnLrd+/uoxmPSLAbn4Gtd1FgzyUcfpq7N5Q69FoNrt3QV
	 pjQ801kmVtEtMolZlMOWFuZSy9EGUipI6x5Jb+rzz8vKG26PpIl+UwYAdgJdiniS8P
	 uEBrZ0ZhOrqOj3VV8fdYBYkF3/2iZiL/6p6sC4Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seth Jenkins <sethjenkins@google.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jann Horn <jannh@google.com>,
	Pavel Emelyanov <xemul@parallels.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 047/118] aio: fix mremap after fork null-deref
Date: Mon, 20 Feb 2023 14:36:03 +0100
Message-Id: <20230220133602.319103879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Seth Jenkins <sethjenkins@google.com>

commit 81e9d6f8647650a7bead74c5f926e29970e834d1 upstream.

Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
a null-deref if mremap is called on an old aio mapping after fork as
mm->ioctx_table will be set to NULL.

[jmoyer@redhat.com: fix 80 column issue]
Link: https://lkml.kernel.org/r/x49sffq4nvg.fsf@segfault.boston.devel.redhat.com
Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -361,6 +361,9 @@ static int aio_ring_mremap(struct vm_are
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
 	for (i = 0; i < table->nr; i++) {
 		struct kioctx *ctx;
 
@@ -374,6 +377,7 @@ static int aio_ring_mremap(struct vm_are
 		}
 	}
 
+out_unlock:
 	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 	return res;


