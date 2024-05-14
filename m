Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAE73BBF2;
	Tue, 14 May 2024 11:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687465; cv=none; b=nLCMgVemgiHgy80dFRVBESNvGma6SLwWEhwYFBwB5fDBu5qSQjH/4D1pbDf7PMuP9FgZfTKcZc6VUKQ6+HiCf3KZb4FcQlZgcSKMg9TdFrMAlMO2YlIPkPDo645dDmWpk05x7vStDG1JibuieN/ssllFawW2F7tr6rSpoDQW5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687465; c=relaxed/simple;
	bh=3aLsSyxqIwkJpC+46PQ46z01Kid4eTgcrS8xiA99PBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIqMlae4j78mwtuXaquvUH+D7/JsiiQDMocg0h0R65jyFdar3Ft9jLTytM0fBLtvqw9jqtwLSqpR9rKswCokgmvCfLOJVL+DyqY67A7v54AOggXa0gXrBu9o++APHXoVQPUnUIt19up4fZRxqMYS+ygFbc+Mfw508L43qHUMAvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dBSJexj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dBSJexj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A27C2BD10;
	Tue, 14 May 2024 11:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687465;
	bh=3aLsSyxqIwkJpC+46PQ46z01Kid4eTgcrS8xiA99PBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dBSJexjiZQ17Xl0drnMWdwouYuhZrMwf98kHDlkrvzzgoACqQj3volbSF9o9ZSZU
	 UpcIyexJG8CT9G+/FfYHKNfzAN4ygmzbtxWd2gCAjNbb2DGIRaThvukuCKvZn3FPOh
	 2DpGQNIzidHzUGGQ10ZNvUgAuDCwEHZ+fNkJC02M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 5.10 106/111] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:20:44 +0200
Message-ID: <20240514101001.161240751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -260,7 +260,11 @@ static int ddebug_tokenize(char *buf, ch
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


