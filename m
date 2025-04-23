Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAA5283C81;
	Wed, 23 Apr 2025 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420474; cv=none; b=UNUk9X2X8CiMxyUhFmQE10gEmB76h+7IMWWIlGhvavZ3qqDPTDsugeVKpvEpZ+6Q36pNaAb8DpSKZ7/S7IxCqoiWJS3BBpEYIDy5t1OxeFINm6t98V7jAfRL5hli9G038jCpLODM/CY20UpQQ60vt/RFKpG0zOt+FEmK70V6hEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420474; c=relaxed/simple;
	bh=KSIbZKPc3SCj9Kni3nqpTZ7j/oixb7MFxA6sFWqR4WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y028t0z5X0hb9dQaaM48Y4EzkU+b9JhSnNsE4oWMkDl1QQFlSqxhCERDL0DAdFRFXPf9c6Kuryjn711fyFmFe3As+ndJP1uOwgCr/pMNVVU2JWoRqYdcLpUp4ZFW5gquZsoJ1FvHczQi6Gekj62hiZArNybvRBQ85U/RsDz2dbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGf7JiIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGf7JiIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5FEC4CEE3;
	Wed, 23 Apr 2025 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420474;
	bh=KSIbZKPc3SCj9Kni3nqpTZ7j/oixb7MFxA6sFWqR4WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGf7JiIq8o54Qpi/1TDVbiy+l9WXsoKeG9bkzH0esciVnL0ayLC5uNQJzFlzgpH1X
	 LwESW+8vp78RkSJ+huMXSjAhVHAi25vCxrwET1HLeGrPqGtMdnYxU+B8Ynx214gIFK
	 YNbJ6Kix7Tt0Qp4IIq9QGb/sJGrpNLfnkrkWf4WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/291] tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER
Date: Wed, 23 Apr 2025 16:40:39 +0200
Message-ID: <20250423142626.433965070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 94bb5f9251b13..ed0d0c8a2b4bb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -776,7 +776,9 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
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



