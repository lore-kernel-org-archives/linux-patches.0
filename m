Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCCB1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E75CC433D2;
	Wed, 28 Dec 2022 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244732;
	bh=mN7b1bBfSuTcDQqVpqek5Dy9LYiuRHhhIF4+xO9/b+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvfhjMma6Qt3g6SC2x358IW9iR/31G1z9HnUFi+6NKEbqXMjIw+7dp0wL6MATCzBP
	 4Rpl6xZmEFnQf/iRPiWZX1Y+c+vdTJIgELclUTi1YDwDZ56noGfsRTvVoQKcwZVZQq
	 PLc29/q9YGw91AIVNGaac8NRAE6MpuwnDTIqFLTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0727/1146] tracing/user_events: Fix call print_fmt leak
Date: Wed, 28 Dec 2022 15:37:46 +0100
Message-Id: <20221228144349.891986592@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 4bded7af8b9af6e97514b0521004f90267905aef ]

If user_event_trace_register() fails within user_event_parse() the
call's print_fmt member is not freed. Add kfree call to fix this.

Link: https://lkml.kernel.org/r/20221123183248.554-1-beaub@linux.microsoft.com

Fixes: aa3b2b4c6692 ("user_events: Add print_fmt generation support for basic types")
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 539b08ae7020..9cb53182bb31 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1359,6 +1359,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
 put_user:
 	user_event_destroy_fields(user);
 	user_event_destroy_validators(user);
+	kfree(user->call.print_fmt);
 	kfree(user);
 	return ret;
 }
-- 
2.35.1



