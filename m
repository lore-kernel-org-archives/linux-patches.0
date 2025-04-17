Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5FF3594D;
	Thu, 17 Apr 2025 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915412; cv=none; b=NlhIZaYw46jkJMCe0/cdb9F2Bi68s6MeCo2HjOUu/6oqVN1tpaXc6bhRZkeDabZSWD/+OxXLAuDMqPV7uTFtXV8BneVChzgeb2BLh+63XaCshchj22aA5I5kCpZ2gVLMARF4ju9nGROQ7X6kcAtm1ZkjGhROc5bBrAChlZk7048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915412; c=relaxed/simple;
	bh=v3xE9U8Ps8oovsdvcW9PlNb+VeoZIlxXd/S5JXo3dcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE4gBLEvRP5TEXfX3KharEpF3IU2niyUJSftxbzDYuOuMQLFUjPid0LHgzuyunp/Bk9vwkfgzMj5n/CcDkq5Cjj3SxGcy1A3+snTOyaxpwFDWixE4lgmkIGa5pRYkWc3G5wqb/dAnUrkrpBGUypzbSGGZ+SYy0qkdYKsqfJM4+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3tEUDDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3tEUDDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE6C4CEE4;
	Thu, 17 Apr 2025 18:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915412;
	bh=v3xE9U8Ps8oovsdvcW9PlNb+VeoZIlxXd/S5JXo3dcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3tEUDDyTR77FBhrvnD0427z3PkAFPEZNWW4FiSgthIhSbUauFnSKeEvStE1k3iOQ
	 VRaktm4Hw75YY7Smgm6mql3vdN9YFmgJul1bIUonH59PSgis8+N3CBDiz9f9i5uBC/
	 CafHCLOCRT/beLpRuTT5AkaQ/3u0kQh9GBnPGpFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/393] tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER
Date: Thu, 17 Apr 2025 19:48:47 +0200
Message-ID: <20250417175112.342590023@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Paoloni <gpaoloni@redhat.com>

[ Upstream commit 0c588ac0ca6c22b774d9ad4a6594681fdfa57d9d ]

When __ftrace_event_enable_disable invokes the class callback to
unregister the event, the return value is not reported up to the
caller, hence leading to event unregister failures being silently
ignored.

This patch assigns the ret variable to the invocation of the
event unregister callback, so that its return value is stored
and reported to the caller, and it raises a warning in case
of error.

Link: https://lore.kernel.org/20250321170821.101403-1-gpaoloni@redhat.com
Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29eba68e07859..11dea25ef880a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -790,7 +790,9 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 				clear_bit(EVENT_FILE_FL_RECORDED_TGID_BIT, &file->flags);
 			}
 
-			call->class->reg(call, TRACE_REG_UNREGISTER, file);
+			ret = call->class->reg(call, TRACE_REG_UNREGISTER, file);
+
+			WARN_ON_ONCE(ret);
 		}
 		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */
 		if (file->flags & EVENT_FILE_FL_SOFT_MODE)
-- 
2.39.5



