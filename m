Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99512F5B9;
	Tue, 14 May 2024 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685860; cv=none; b=KYPSh1syA8NR/S3Z6T6wBcF+zoxqtU0kcwTOPLHFxRf0rFE2ngAeGmHVe5CyJNJLr20p/a7Ub1pOMCm2QqqANlGdgazXecgy6DxCmeawDzKSTJlWBbTfZgNPetG1iuZCDnHJgpRRiUhUrmt8Y3KlxtJlBiIl1u2txI98KLwTqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685860; c=relaxed/simple;
	bh=YZ0DBGMP9GZPTQgtwRK77ZKNevaESDRQ46ewDAc7XB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEEYVQuMC0ibd3VwShUK0hqKo+lFV/IK0eCsxaLZne9xwGUeJ6yPjVOEGQz+K3PCY4PO7KOdZN8Wz+MVx3flc120Ti3/bd61eFY29Pnw/BJkvmydk07x90XldWU340bQW6wSoBcttluwV1rxt5zeHxRWkM1HLBU0LLgIk4n+rDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1N/JPJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1N/JPJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9AAC2BD10;
	Tue, 14 May 2024 11:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685860;
	bh=YZ0DBGMP9GZPTQgtwRK77ZKNevaESDRQ46ewDAc7XB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1N/JPJ3DnjXjCz9eYVWEiS5bR9k23sC5bNViwq6QnK57uW/OtRQ/aDzWrz2se8yY
	 /Ced+RgIsSsQ+uXkFWWhFwEpcXubcoR1OMJqIwvEeN2zJ/bLRDFk4mSa1MXT+NwnzM
	 RUhQmXSIxhUenNMmVG48XraDMwiTV9wcsVanHnVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 6.6 261/301] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:18:52 +0200
Message-ID: <20240514101042.110526536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


