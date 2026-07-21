Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D459E3EEAC7;
	Tue, 21 Jul 2026 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660900; cv=none; b=pY1nydslh7o2YO7HYCrPsz+j2EsAtdRkerdDguYL4PwjeW4uLRanBd1JtXpPNKEHzQ9bbMNk23tKLggg2Gnx3OmyCfOtC/K52UE8gCfwhGO3oFMc5HpmeCBcvtdCbZ8blNeVB+DlkhEx8AOFUq4nsxsRqc8b9cOi71kHbVj766s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660900; c=relaxed/simple;
	bh=hVzZtbrDHeXGCRnrJBmLHzJdgQVV/gu+n/g7thIYkr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWXGBkaLZHpERWOqvg5WMwgG0Clm2S6IZ9j61B0ES+jVhmyTkixEJ3VJGscYJl9aXc6tZcfTclJl2ovSBqlXoIQ34GsW/cv8WfE4IUQgAwwDRiD5O381lccdk25N08zRmrK9a4okPLfFwI/slEd9JHA/scbYm1QCAhRXKYaBOeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We7kd8MG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We7kd8MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4772D1F000E9;
	Tue, 21 Jul 2026 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660898;
	bh=oeTu0dZW90YXZNuXJ5MqWJrMqMUCdfK4k4HFQoF0qss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We7kd8MGgjzzO6oSQVkb6VmGUiH8eyz2DOXTXdPQs3pppXpTSfQhSUUNsFLs1KJY+
	 sJx9YxPqRwhj5B+KkTY59tZ5Gw5Ok2pA2L/RsIxguP5NFPh2HyO/ymR0UHMHbslMx3
	 XgLuKD06sG8NIKNQ4BYsPvUzxzZ8TihTcdLBSf4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1110/2077] selftests/ftrace: Fix trace_marker_raw test on 64K page kernels
Date: Tue, 21 Jul 2026 17:13:03 +0200
Message-ID: <20260721152619.003605882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 65f26d15f7db80b0a3f995c518cdddb50e6dea99 ]

On ARM64 kernels with 64K pages, the trace_marker_raw test fails because
bash's printf builtin uses stdio buffering which splits output into
multiple small write() calls to the tracefs file. Since each individual
write is within TRACE_MARKER_MAX_SIZE (4096), they all succeed, causing
the "too big" write test to incorrectly pass.

Fix by writing through dd with iflag=fullblock to guarantee a single
atomic write() syscall to trace_marker_raw.

Link: https://lore.kernel.org/r/20260601023251.1916483-1-dtcccc@linux.alibaba.com
Fixes: 37f46601383a ("selftests/tracing: Add basic test for trace_marker_raw file")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/00basic/trace_marker_raw.tc      | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc b/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
index 8e905d4fe6dd22..f985ff391463a7 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
@@ -36,15 +36,23 @@ make_str() {
 
 	data=`printf -- 'X%.0s' $(seq $cnt)`
 
-	printf "${val}${data}"
+	# Return escape-sequence text (e.g. "\003\000..."); the caller
+	# converts to binary. Shell command substitution strips NUL bytes,
+	# so the binary form cannot survive being captured into a variable.
+	printf '%s' "${val}${data}"
 }
 
 write_buffer() {
 	id=$1
 	size=$2
 
-	# write the string into the raw marker
-	make_str $id $size > trace_marker_raw
+	str=`make_str $id $size`
+	len=`printf "$str" | wc -c`
+	# Pipe through dd to ensure a single atomic write() syscall
+	# on architectures with 64K pages, where shell's printf builtin
+	# uses stdio buffering which may split the output into multiple
+	# writes.
+	printf "$str" | dd of=trace_marker_raw bs=$len iflag=fullblock
 }
 
 
-- 
2.53.0



