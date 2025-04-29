Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAD224113C;
	Tue, 29 Apr 2025 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945276; cv=none; b=AzAgc8ac0XEb+c3pgmr09AKk6wUMtvS29DN+sn23CQ9Bt8DDl2rwmCw12whUsfFC3B+CRzGnrrpjUbP2OBfc9PBD8ZcmtaZvtZUYetZbHMY0CGgIkPL7Z5lQb3nwjmLFHJNDZ520oXKmXROwm3pRkTngzxd3qvTuimIKO/bxmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945276; c=relaxed/simple;
	bh=0xmQUzT+rB9SS2SDGiQOS7khsXZiCCAVfQNLod2Z3Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdO1qgxSpMMzxJHSsG8stMQOEr20hnLGVx7Roqc8NDqccZPa2gODofxhkiYH//Tm/3uzCk8Fh0naqRFKB581KXIu3VELX5XNwNFN3jepJaDDOF308QBsVt8SL/wWGe/RorUpzcPKscGN+GylX7RM7DtG8T1zvxb2zfcaaC6Cnrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZb/th3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZb/th3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B15C4CEE3;
	Tue, 29 Apr 2025 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945275;
	bh=0xmQUzT+rB9SS2SDGiQOS7khsXZiCCAVfQNLod2Z3Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZb/th3JyIPzX+ekKQpNUbYYaxAw4uCwAc3qRp7/JhEIqHyYCO3mkS7W+zFgSmk3z
	 zgEf79vbeZR6jAT1/y95Nin9NrdFzOa8oVEa0uo14wA2dGtnXoKATun4tbzqLf7lvi
	 DpJnhqXCGSVZ7XWWRA26zLmg9fZnzsvXqdOetADU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/179] tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER
Date: Tue, 29 Apr 2025 18:39:29 +0200
Message-ID: <20250429161050.553222349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 958789fe4cef7..77df1e28fa329 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -405,7 +405,9 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
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



