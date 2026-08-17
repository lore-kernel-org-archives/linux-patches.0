Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B8343CE64;
	Mon, 17 Aug 2026 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978567; cv=none; b=TmtFL+cQbWgO3InL/IDAI7NNEXgoWlLurVe7nkLiPEbVkm++D5T4zgwBb6/XqyNLA7Vr/RcQ03Tep43K6nPdo9a3z5gb8uRV4cINVC9TPNLUA8rCOxaotgiSCiSz7iOn9zp5kB7zyAE1iZvx0d8uYDuPgrOl0EyZ3gM+3Uw8aHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978567; c=relaxed/simple;
	bh=gi9vZBuvnKFa4ika4ZxKXU8fqGKLJntxnQYNN8PXeOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT78RzVWVpVtncGUUFBUV9b95TPx9vzsW/Ucr2xE9Rnb9YVORbWOSJ8PUwxlPrvt1HxnWa8BXfsC5Q9gvLFe32rnQ7w55BxR1ITQurQxEPKQY6uojgTwa4BnlgdujiMPVt76UkMp+j4d/gdagtCkn4TgtosMMruXXnA33m1NfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrZo3Aa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrZo3Aa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425021F000E9;
	Mon, 17 Aug 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978566;
	bh=ne4g3YKVHcVkuh7w/hCMFu4LS+iabHBoOaKXLrIPJ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrZo3Aa7yYWMkIabhpz/kkjX0kJvItEYvPDjTQlgEdpcsTfDD9CTHC0oyydExc/Br
	 beR3yJn45BOqI+oHz60GcORFSoUbht4YDFnU6l1qXN6g1zuwSSDF5OtfNebjkkm0sf
	 muaGf7aEVSwFxIY/QuY3DYazsu0dwGyGn/K6xoiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/156] selftests/ftrace: refactor eprobes test to fix argument checks
Date: Mon, 17 Aug 2026 15:32:56 +0200
Message-ID: <20260817132536.250267636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 6e3abef2a27e7402a94111c9eff85d887e64a309 ]

The add/remove eprobe test installs an eprobe for the openat syscall and
runs ls. It checks the filenames that were opened by ls against a
whitelist and a blacklist.

Commit 206b25c09080 ("tracing: eprobe: read the complete FILTER_PTR_STRING
pointer") fixed access to some string fields in eprobes. This triggers
test failures as the blacklist does not allow relative paths for the
openat parameters.

What makes this test unstable is the fact that the openat calls vary a
lot between different systems.

Refactor the test to make it more robust. "cd <directory>" will issue a
chdir syscall with the target directory as parameter. Set an eprobe on
the sys_enter_chdir event and filter for the exact directory name. Allow
(fault) as fallback.

Link: https://lore.kernel.org/all/20260804194705.760893-1-martin@kaiser.cx/

Fixes: 206b25c09080 ("tracing: eprobe: read the complete FILTER_PTR_STRING pointer")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202607151010.b68428e1-lkp@intel.com
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc  | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
index c300eb0202620..e2322693d0c32 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
@@ -1,16 +1,16 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Generic dynamic event - add/remove eprobe events
-# requires: dynamic_events events/syscalls/sys_enter_openat "<attached-group>.<attached-event> [<args>]":README
+# requires: dynamic_events events/syscalls/sys_enter_chdir "<attached-group>.<attached-event> [<args>]":README
 
 echo 0 > events/enable
 
 clear_dynamic_events
 
 SYSTEM="syscalls"
-EVENT="sys_enter_openat"
+EVENT="sys_enter_chdir"
 FIELD="filename"
-EPROBE="eprobe_open"
+EPROBE="eprobe_chdir"
 OPTIONS="file=+0(\$filename):ustring"
 echo "e:$EPROBE $SYSTEM/$EVENT $OPTIONS" >> dynamic_events
 
@@ -18,20 +18,14 @@ grep -q "$EPROBE" dynamic_events
 test -d events/eprobes/$EPROBE
 
 echo 1 > events/eprobes/$EPROBE/enable
-ls
+cd /sys/kernel/tracing
 echo 0 > events/eprobes/$EPROBE/enable
 
-content=`grep '^ *ls-' trace | grep 'file='`
-nocontent=`grep '^ *ls-' trace | grep 'file=' | grep -v -e '"/' -e '"."' -e '(fault)' ` || true
-
+content=`grep -e 'file="/sys/kernel/tracing"\|(fault)' trace`
 if [ -z "$content" ]; then
 	exit_fail
 fi
 
-if [ ! -z "$nocontent" ]; then
-	exit_fail
-fi
-
 echo "-:$EPROBE" >> dynamic_events
 
 ! grep -q "$EPROBE" dynamic_events
-- 
2.53.0



