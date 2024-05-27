Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CE1168C4;
	Mon, 27 May 2024 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837488; cv=none; b=X/+qY3kA3tglZsBW9LGj9IOrHthH3TOar2kqUheYlt3GDneaicSfG1Y4LrPfR6LLhz8fFJGUfeIvAhWoWZ71fMJJyXyb2C8hX6yN6nzAbb1a86LyaPdsY3yy7RgCItuMSuzqHmC7hqrcYA6f7T76cnefGtRVHxjBISsJXxfhkEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837488; c=relaxed/simple;
	bh=jBd7MlCeFRsPxH1nPnYK2tBTtabE6cVJmF+Lgi9F4OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqjq79mw/4zmqzEt30bPwtmiandhnYANne8ZS2iLFZPlCW9cFQkYZRH74wtdnVNOGXExZsCeMUpVpX+5QuU/5bAlToE3W/EOP4fJORcXooUFrqvHQdxoFwjQoMsUiJS+QFyfPcdFYKt8CpD/LALYvAiQvZcr+6muEswZZPW6tPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b82S3VTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b82S3VTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0F6C2BBFC;
	Mon, 27 May 2024 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837488;
	bh=jBd7MlCeFRsPxH1nPnYK2tBTtabE6cVJmF+Lgi9F4OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b82S3VTg7Vo33l1bYyAwbGj1aohvl5aFCfXaIxwuSIvHWfjAyu2ujXNILHkZ/DPBd
	 3MtzWeJU1++3cAiTa+/Ojrwqk86rBoraDYoBAbuSZRIAtRay61294bEmbXPRa2ReEt
	 pruasCOIk+U1d4iG6dg/tbyydXOTRkIhvkCO4OF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.8 003/493] selftests/ftrace: Fix BTFARG testcase to check fprobe is enabled correctly
Date: Mon, 27 May 2024 20:50:05 +0200
Message-ID: <20240527185626.882185105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


