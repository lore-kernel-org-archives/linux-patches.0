Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B452D60A;
	Tue, 14 May 2024 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686897; cv=none; b=NRv+CVqt57tr8QNKnl5kaJmKMu3TV6c56dlSxw5AM1WeHc58SwhEItzTe9iFTLxqEo6/VS0D7k8zecRVQJQOu/bBfrBOdRYX46z3/szrOHOrsETIfYuhnGnkyhpuTKjNujYGCc4e7LqJhwjGE/faRehIvC2+AkKFZAjMBpJqtQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686897; c=relaxed/simple;
	bh=Uon0DQbhFYKMy2P6sTexKOeZnx9DZNDMhvUGPM9fK4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEQjRiyEpo1N7H46LI2JXDSQFDBMWZrcMixPmKdbr1OlBJnyWjn73vXVzD3ENYexlrdICVoVy9TT81KvmU6j4AdayjXvt9Nyew4zt6piEe6AQ0jTDnhPONTGzAn+bqnQtpic3YmP5Jrs7VLRQ1nku1YQQwiCqSJGEZSUtyHFqIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7BHYZb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7BHYZb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02AC2BD10;
	Tue, 14 May 2024 11:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686897;
	bh=Uon0DQbhFYKMy2P6sTexKOeZnx9DZNDMhvUGPM9fK4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7BHYZb2PI8h9IfbX07UKdRH8EKGdYCy6M/oRu3IX/NY86Ld0KqCsZ6yJVYrjT79e
	 pWx72A8Q07Vs/jS9l3K67hrx1aJwvrSMM+lg3lcpPoQlfvoZlvRTByDn+Ws6qUEN+M
	 lNO9IfovKhxrhNnQuOxgPDNuuvnMtTJBSk4MSVH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 4.19 60/63] dyndbg: fix old BUG_ON in >control parser
Date: Tue, 14 May 2024 12:20:21 +0200
Message-ID: <20240514100950.275077003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -242,7 +242,11 @@ static int ddebug_tokenize(char *buf, ch
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


