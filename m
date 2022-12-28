Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2211C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D130C433F0;
	Wed, 28 Dec 2022 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244402;
	bh=ysI6Yb/OMNb8xwQASwMNiKfVXdjs+etqZlgyn2qb+MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uVsur+/eMiNP7QqYIa1gU4fU8C0kS/qFVDNVbBiXXda0kRItte+IiZLFcXlDt0Ou
	 RLUL8lskrYYyGJH1/Il9SvpqT/DUZg1kG0PABm4Iig1rZHZi3jsr7lyaaM6bv5acbJ
	 47VtxYJbNg3oPNSq0o/vrIiGgipIVOOx09Tp+mkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0704/1073] tracing/user_events: Fix call print_fmt leak
Date: Wed, 28 Dec 2022 15:38:12 +0100
Message-Id: <20221228144347.154176363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index a6621c52ce45..b885b6934893 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1127,6 +1127,7 @@ static int user_event_parse(char *name, char *args, char *flags,
 put_user:
 	user_event_destroy_fields(user);
 	user_event_destroy_validators(user);
+	kfree(user->call.print_fmt);
 	kfree(user);
 	return ret;
 }
-- 
2.35.1



