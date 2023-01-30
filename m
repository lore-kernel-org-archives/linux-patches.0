Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935BD3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11650C433EF;
	Mon, 30 Jan 2023 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088796;
	bh=ezzE3+CW8K03nv60S3Y5tB/PV/lTwsGqG3OO2IAdH58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS7jyKeEeAdENhW+hZSwJp3yzOadTx2RC6+ZTjvPjKcUPk6QgRIbcpmnGOPz/CMM9
	 7N07Fv5g0iLnfAQPszTjDVUHfSxCOAzyGreSQVEzgJu6+gK+RJAFCRDz5MpzoBcCbY
	 nJd2lGkKiD3Vmg3rgJ8SKwUN7fKs+9SzYCW/3IJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 5.10 138/143] Revert "selftests/ftrace: Update synthetic event syntax errors"
Date: Mon, 30 Jan 2023 14:53:15 +0100
Message-Id: <20230130134312.537877225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yejian <zhengyejian1@huawei.com>

This reverts commit 31c2e369b5335d70e913afee3ae11e54d61afef2 which is commit
b5734e997e1117afb479ffda500e36fa91aea3e8 upstream.

The reverted commit belongs to patchset which updated synthetic event
command parsing and testcase 'trigger-synthetic_event_syntax_errors.tc'
Link: https://lore.kernel.org/all/20210211020950.102294806@goodmis.org/

However this testcase update was backported alone without feature
update, which makes the testcase cannot pass on stable branch.

Revert this commit to make the testcase correct.

Fixes: 31c2e369b533 ("selftests/ftrace: Update synthetic event syntax errors")
Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc |   35 ++--------
 1 file changed, 8 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,38 +1,19 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
+# requires: synthetic_events error_log
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
 }
 
-check_dyn_error() { # command-with-error-pos-by-^
-    ftrace_errlog_check 'synthetic_events' "$1" 'dynamic_events'
-}
-
 check_error 'myevent ^chr arg'			# INVALID_TYPE
-check_error 'myevent ^unsigned arg'		# INCOMPLETE_TYPE
-
-check_error 'myevent char ^str]; int v'		# BAD_NAME
-check_error '^mye-vent char str[]'		# BAD_NAME
-check_error 'myevent char ^st-r[]'		# BAD_NAME
-
-check_error 'myevent char str;^[]'		# INVALID_FIELD
-check_error 'myevent char str; ^int'		# INVALID_FIELD
-
-check_error 'myevent char ^str[; int v'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[kdjdk]'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[257]'		# INVALID_ARRAY_SPEC
-
-check_error '^mye;vent char str[]'		# INVALID_CMD
-check_error '^myevent ; char str[]'		# INVALID_CMD
-check_error '^myevent; char str[]'		# INVALID_CMD
-check_error '^myevent ;char str[]'		# INVALID_CMD
-check_error '^; char str[]'			# INVALID_CMD
-check_error '^;myevent char str[]'		# INVALID_CMD
-check_error '^myevent'				# INVALID_CMD
-
-check_dyn_error '^s:junk/myevent char str['	# INVALID_DYN_CMD
+check_error 'myevent ^char str[];; int v'	# INVALID_TYPE
+check_error 'myevent char ^str]; int v'		# INVALID_NAME
+check_error 'myevent char ^str;[]'		# INVALID_NAME
+check_error 'myevent ^char str[; int v'		# INVALID_TYPE
+check_error '^mye;vent char str[]'		# BAD_NAME
+check_error 'myevent char str[]; ^int'		# INVALID_FIELD
+check_error '^myevent'				# INCOMPLETE_CMD
 
 exit 0


