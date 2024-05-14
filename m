Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F306612A151;
	Tue, 14 May 2024 10:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683866; cv=none; b=NnXvdXhMg3fGTpsEX45laKxY5J+IfPT1mNH53jMdiJnbdRJ0RrR1YASS2m1tx0vcRKXESR83CgqhAcNnJI1wIUNjKqsw5V4VGDqxaxNwAHZJkXTHAq9MHG60L6T5UqwI1vd17zDwj67u4gHVIBAdfsPNrpiKAyiI0ihAjLn0450=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683866; c=relaxed/simple;
	bh=7nrJid9sDlV52BOPv1UEuXPhl4tUK9XbgkzInPiMvIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EujcDEZhsHZp1L6L+1JHTBHNIkl6uZhkn4qQ36UuRG+udSUPQex0CuCl0SqdFOFA8i+mDIbfge/lQJFsl97BGDoqQI9GKEpGAoypYIfZALrFCtRlMt5VP1il4B/cfZgp6ypyb30TbQzF+PT6y6ypTgpR12OATj12p1P9adWuKBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shruv1Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shruv1Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5A3C2BD10;
	Tue, 14 May 2024 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683865;
	bh=7nrJid9sDlV52BOPv1UEuXPhl4tUK9XbgkzInPiMvIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Shruv1SdIEUj3ATOoItGejYdovl30CKn3SHQijPN/DzaUN95WgA4gq9OzYjGPdPUa
	 XvzEXw6o5eEUn8qEoGz5FuM6H/Mst46VhEhyRkNMvKkJF/ioFOJMlh0rBiWnI3CV23
	 w7wbJ6XOcTDUG5JeNFH4uLQ7KnYdDfyWutia6T5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 6.8 287/336] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:18:11 +0200
Message-ID: <20240514101049.453413726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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
@@ -302,7 +302,11 @@ static int ddebug_tokenize(char *buf, ch
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


