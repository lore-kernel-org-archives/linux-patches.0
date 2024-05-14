Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F12D2D60A;
	Tue, 14 May 2024 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687135; cv=none; b=IyGnq2/ObfvCW+ieShMB5GMTZDIcqg1g8CXqkp3mtSVi3OfgZs41u+pVp8iIc59lUUfPwy7QCNIvZdwsxoyg+FJ+FB76WG2eh3YHiRpbmilR0bdBXa8NAyFsIu1hcrFQy+WGO1fYLHcyuWmYFlmxx4ieOf4f7cl51efQEfM/a5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687135; c=relaxed/simple;
	bh=MJQ1x0LHfHJx6gdox1ywThqcujcwhjJS19GSS/nDzvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUd9Y3uJ/u3sVH+ZotSquCAWykGjSCmtMe10x3Jch0hwMUyOhggb44PAQMFAJjqKqHHswOLrG63SKURk+Pwi5jx7/XKJnFcOXUXv4Mc+ZOPpc6SjI2JsJ3oqu5whrIXdqr4/M/IdcAF0sIZ6Ue/VzFG/B1VbcRd/YO7Hb+p6PVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iKnZRXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iKnZRXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802ECC2BD10;
	Tue, 14 May 2024 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687134;
	bh=MJQ1x0LHfHJx6gdox1ywThqcujcwhjJS19GSS/nDzvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iKnZRXmHEyzONEDzjIDDeO8LAdULvY31JnQ/Kxo0HcUV0lXCtEYdEBXmvUPE2WWX
	 SoKDRGC+qMejSvPY4QDDwq8HM3k3Jpc2q3WhgQkDzdvZpMBlwd2nI7+UM357gGLjo+
	 4XZZYFiZWj6j2hZGgyxqWqZskxzBDHVqNxBj5hlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 5.4 77/84] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:20:28 +0200
Message-ID: <20240514100954.578318931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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
@@ -244,7 +244,11 @@ static int ddebug_tokenize(char *buf, ch
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


