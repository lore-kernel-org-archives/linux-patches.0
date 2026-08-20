Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B425C6EE;
	Thu, 20 Aug 2026 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244541; cv=none; b=qaWuYtJ6ad6ZKcBt/MkQuh0rWJZew7OOZIKk6GBEPDRch8b7BwN54AG21UT9qqj/1adLIuGr8vovtJA6o8mclPtYRQsfjCw3r+zQL1rlzdV9RbxU67ojReyEZjQavC0JdEHrCHsDGb+L0ih3RP4+ObcBU0uKftrbUVowcOkRVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244541; c=relaxed/simple;
	bh=lmCq+NpvNbHGN64VXLgzum/meNbLuWAGIptWLVsHX8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btxAoBSzYV6xIfXDrqPe3HNDaG6YDx7NtyeP+2ZdE6dG5i4LQ3FkGuolcpkt0R3ZPL+tQM4F8CmBNs+H41N3nWJu/hfF+EAWcJ/dme/B5dlRNIfcSOrMzB0FD7k6V1lXmRiWzRvWLlVr3sb4OpSztvbWaLT7FxEu9iSE2/nano4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDivQmwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDivQmwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CEF1F000E9;
	Thu, 20 Aug 2026 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244540;
	bh=VBr85JX4hzDnzeM2gDZpf0iKTZAFpBoJWi3LLrcsrGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDivQmwNA8EWJe36TvqIBNlzPYEbKTgo5YrsRgxJE/CDKQo3+BVb3rYMDKsKPbFKD
	 c2Fdq79HNn9TyZ2CYJxyjTZl0qLeEJmyPhZGX0v/ArZWVWmkZ6RqtNEuK47V1Mqnij
	 SAkuQN92AMfjFcajMbJSosBxpUGRLRUkW69t3fr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/235] fsnotify: opt-in for permission events at file open time
Date: Thu, 20 Aug 2026 16:57:20 +0200
Message-ID: <20260820145222.737911172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a94204f4d48e28a711b7ed10399f749286c433e3 ]

Legacy inotify/fanotify listeners can add watches for events on inode,
parent or mount and expect to get events (e.g. FS_MODIFY) on files that
were already open at the time of setting up the watches.

fanotify permission events are typically used by Anti-malware sofware,
that is watching the entire mount and it is not common to have more that
one Anti-malware engine installed on a system.

To reduce the overhead of the fsnotify_file_perm() hooks on every file
access, relax the semantics of the legacy FAN_ACCESS_PERM event to generate
events only if there were *any* permission event listeners on the
filesystem at the time that the file was opened.

The new semantic is implemented by extending the FMODE_NONOTIFY bit into
two FMODE_NONOTIFY_* bits, that are used to store a mode for which of the
events types to report.

This is going to apply to the new fanotify pre-content events in order
to reduce the cost of the new pre-content event vfs hooks.

[Thanks to Bert Karwatzki <spasswolf@web.de> for reporting a bug in this
code with CONFIG_FANOTIFY_ACCESS_PERMISSIONS disabled]

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/5ea5f8e283d1edb55aa79c35187bfe344056af14.1731684329.git.josef@toxicpanda.com
Stable-dep-of: db1856ea9196 ("binfmt_misc: restore write access when removing an entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -179,6 +179,12 @@ typedef int (dio_iodone_t)(struct kiocb
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
 
 /*
+ * fsnotify pre-content events do not exist in this kernel, so a file is never
+ * watched by a pre-content event listener.
+ */
+#define FMODE_FSNOTIFY_HSM(mode)	0
+
+/*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
  */


