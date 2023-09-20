Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AB82E640
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F4C433C8;
	Wed, 20 Sep 2023 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213773;
	bh=yohrV4EAy4CGZonk3omscBa69N1Z0rnBoO7NGZO7hWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+kiqTI+vnBxnJQGVpZ+P/NxozTvk/kXBQOmwCJVZHfvNwcyvwWCMQUrYn1GS1wRz
	 h8uLsvwNxsMtGP3R5972AcrYh2zMG7qbxoVB8zYqlaa8AGryxKLa/qU6WsxuZLtSAv
	 OzuIBlKEy042QkYb9HarUbPNGeJumKMEroncgefA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	Ching-lin Yu <chinglinyu@google.com>,
	kernel test robot <oliver.sang@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 361/367] tracefs: Add missing lockdown check to tracefs_create_dir()
Date: Wed, 20 Sep 2023 13:32:18 +0200
Message-ID: <20230920112907.831794795@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 51aab5ffceb43e05119eb059048fd75765d2bc21 upstream.

The function tracefs_create_dir() was missing a lockdown check and was
called by the RV code. This gave an inconsistent behavior of this function
returning success while other tracefs functions failed. This caused the
inode being freed by the wrong kmem_cache.

Link: https://lkml.kernel.org/r/20230905182711.692687042@goodmis.org
Link: https://lore.kernel.org/all/202309050916.58201dc6-oliver.sang@intel.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Ching-lin Yu <chinglinyu@google.com>
Fixes: bf8e602186ec4 ("tracing: Do not create tracefs files if tracefs lockdown is in effect")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -551,6 +551,9 @@ static struct dentry *__create_dir(const
  */
 struct dentry *tracefs_create_dir(const char *name, struct dentry *parent)
 {
+	if (security_locked_down(LOCKDOWN_TRACEFS))
+		return NULL;
+
 	return __create_dir(name, parent, &simple_dir_inode_operations);
 }
 


