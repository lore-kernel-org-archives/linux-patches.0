Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B8F9D4;
	Tue, 14 May 2024 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687942; cv=none; b=nHB08IU/XRmW2VSt2tEjOv76adhGiR8PTQdUwyMhivcIGsv1g7cxP88eI9KgUHppt4lNguUjoJa2hRI0so4BIPFrZBKiW+c5bQKxAYYV8T8skYFq1xgXaiMYB7ILPv394eccRPI3z3gbHpnDjBgPvcAY1SnbSP5BFL6CPzh3byY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687942; c=relaxed/simple;
	bh=Uxav+EQhhuJvxMRbWIjvMY4HYGma2ap1BL8t7OudQZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8FSV6WE1YfvDX8eI/vGrWsCRjL9j7LApPfi9dGTvXTJgok0G+XKFlakNJRQhln/oqfMw5d7CDkEpnwLrcPJx8Y0dS8fEEz7ixLirpquBMty2XsDG9Evht356M/Y+VOfFsOUP4P5REcm8/i9VfZMbCoUA9OoNaQmIxRkvtXixpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbD9tOT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbD9tOT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA01EC2BD10;
	Tue, 14 May 2024 11:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687942;
	bh=Uxav+EQhhuJvxMRbWIjvMY4HYGma2ap1BL8t7OudQZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbD9tOT99WEGfQv+xGxnRPagDrsKMrw3JvKFysUborHj4l0KCpYzsKrbfpd8hwj4S
	 EouJkr+1ZSVIuWqnTi9dgS7y41j8Qir6HyLtJPGqEcATTH38xiRlfVgG3OT6DacVfn
	 /HncbrOhRgFGUZkId71XNhktstpdSTG8K8ysmXHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 5.15 159/168] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:20:57 +0200
Message-ID: <20240514101012.761201707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


