Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CBC15FA96;
	Mon, 27 May 2024 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836350; cv=none; b=OpYgXSP7VgF32AlknnwR/QZBCS7iG3XGiSq0sOjvNjTt5qz36J2islD9O1p8xWn8OVRpqA5u482QAaqEgYltuoLy697KDMcVCsmUd3jIpGAJFOSfZLST3VGHbPWW3wL9in34ueAQjLHLtm+FEgobOW/hgP4l5x/w4+/4UMEt9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836350; c=relaxed/simple;
	bh=DzvQoUo8gT2P8wgRbSBI2/3Ps03luKe4oMe86CuAC3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pameKZkMdiroGRJbYs12r1kj3Xx+SwFF1XKd2zhAi/nzUR2QCiP3YytJDjydxiPnT6s5DRZ4iolHl/em3viAP0uEXIC13tVxowUpGOwjY+uCSiSVlLa0ppYb2SB5gOo06doZLGez2Qvb27gbPgbRS7lQac+CkERs1Td8EtotsRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN454au0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN454au0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B72C2BBFC;
	Mon, 27 May 2024 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836350;
	bh=DzvQoUo8gT2P8wgRbSBI2/3Ps03luKe4oMe86CuAC3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bN454au06lVLWF43XY4inlkQhLtvymLJgZ3onJHQ7WihExgfyOd0+CDCpe9JMKwzK
	 PKSlIOvuitRD00j/0jHktk46ejs62dlF4sZzG0DYRcgcb7XxUb0zYKcwQ8AKa+kfVv
	 DMwWR86vLha+e57LlE9noNDewpbp28/NyBmQwXoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.9 002/427] selftests/ftrace: Fix BTFARG testcase to check fprobe is enabled correctly
Date: Mon, 27 May 2024 20:50:49 +0200
Message-ID: <20240527185601.971914836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 2fd3ef1b9265eda7f53b9506f1ebfb67eb6435a2 upstream.

Since the dynevent/add_remove_btfarg.tc test case forgets to ensure that
fprobe is enabled for some structure field access tests which uses the
fprobe, it fails if CONFIG_FPROBE=n or CONFIG_FPROBE_EVENTS=n.
Fixes it to ensure the fprobe events are supported.

Fixes: d892d3d3d885 ("selftests/ftrace: Add BTF fields access testcases")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc
@@ -53,7 +53,7 @@ fi
 
 echo > dynamic_events
 
-if [ "$FIELDS" ] ; then
+if [ "$FIELDS" -a "$FPROBES" ] ; then
 echo "t:tpevent ${TP2} obj_size=s->object_size" >> dynamic_events
 echo "f:fpevent ${TP3}%return path=\$retval->name:string" >> dynamic_events
 echo "t:tpevent2 ${TP4} p->se.group_node.next->prev" >> dynamic_events


