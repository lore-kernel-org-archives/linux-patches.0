Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D115012E1E2;
	Tue, 14 May 2024 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686725; cv=none; b=b3DYlkT5ynxwAIiSaaVVfeCYYQNq40IzG8MZAS2KLrPb+SQroN/RvflSsi8gwOf3rAYWmCwURTm6+5UTl2B9wsiz1HkQLjaKH64aLpXBzH6OsOk7wFjJAEQUkqlN33w3Y8VebbHjX/sJNDPoaY5u5LLlMDK3xXry2Zt0nvEGjFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686725; c=relaxed/simple;
	bh=nh0FtlXWh8jzGSfxTdQfOrHrgdSJHSDoWa2xkBnGXvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIqmTF5P/Ug/M6q/v59yu3FqSDGo5j62+O9f9imXOUUDI+FCn4KNPFVqhqGB3agg/Y50qZ0NuIf526hwHJGbO/qf4W6LGQQsJoJe5pfU1qmlUR1tnEMsktzio/ktSEguA7H0WB+vp99TcWudBP5VNjBdHkSU/TioQpkEm1sEc64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDQSb3ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDQSb3ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5958CC2BD10;
	Tue, 14 May 2024 11:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686725;
	bh=nh0FtlXWh8jzGSfxTdQfOrHrgdSJHSDoWa2xkBnGXvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDQSb3ba3GtTtp2S7u3TmjF9fLDPT6KYrj91c3dlpbz/gK4XmirbRyQ+Nl1BjN1BH
	 epactkmyI+0eswGHGnwfte/i1rH8QV9Wppd9b6HkpPtywLMbW3VlZ94K5AmNwtekpx
	 HjxeKFsEgYVNlXeB4HibXZDEmaMD4xwoI+lQbIcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 6.1 217/236] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:19:39 +0200
Message-ID: <20240514101028.596335008@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Cromie <jim.cromie@gmail.com>

commit 00e7d3bea2ce7dac7bee1cf501fb071fd0ea8f6c upstream.

Fix a BUG_ON from 2009.  Even if it looks "unreachable" (I didn't
really look), lets make sure by removing it, doing pr_err and return
-EINVAL instead.

Cc: stable <stable@kernel.org>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20240429193145.66543-2-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_debug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -301,7 +301,11 @@ static int ddebug_tokenize(char *buf, ch
 		} else {
 			for (end = buf; *end && !isspace(*end); end++)
 				;
-			BUG_ON(end == buf);
+			if (end == buf) {
+				pr_err("parse err after word:%d=%s\n", nwords,
+				       nwords ? words[nwords - 1] : "<none>");
+				return -EINVAL;
+			}
 		}
 
 		/* `buf' is start of word, `end' is one past its end */


