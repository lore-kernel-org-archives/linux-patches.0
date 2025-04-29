Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A02517A4;
	Tue, 29 Apr 2025 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948533; cv=none; b=ZTSuKR9DPVGgSeb5i693YsDC+HNSKb4mCl7HE9Sf8WLQuDLlJvL9K/XnjKEi5RYM4oBuMl2hDYzW8pH13A3A89/BS2QtscXJdkh9udcFQp/Kj1bxxrwKy6MPU62JMGrfBLnk9J2xtpggrEx/IoWa4HCROa2XJNMgA50GJZPsRok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948533; c=relaxed/simple;
	bh=lXxiSrO4vkGs4m+r6FYSQElGqAVEW3ZaIoNfPyH95g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K40ap+n51VKFBo1afZXdLAHaTbqg5nH1MW3/5MhROa+ejlEQfojdqy+dqZmA71Yt5mt7BzVAJSW8y/CPbOotcZyoulDdqnj54o1cEDQio0V0TmiWxzVwo6T/8wfuGg2v+JiaoA36Jpwm7ZOcaADzD5Etn2h3yYHYIAN5C0KOZB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC2ezJQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC2ezJQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D88C4CEE3;
	Tue, 29 Apr 2025 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948533;
	bh=lXxiSrO4vkGs4m+r6FYSQElGqAVEW3ZaIoNfPyH95g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lC2ezJQlrobCctu8Vz6xLq6CgOSFWv9eq7H4H+jIar9VHvORm3w138Xgji6Rclllp
	 k2y+YpKIliGFPV+mb0uH1LtnflIPO2eUDdyHhenoieTyu9TAJCly3RIa7qENYaYVNi
	 KoGgPhagKyaRQ9iF5boj5LtDak3o9N/xzIZ2iDio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/373] tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER
Date: Tue, 29 Apr 2025 18:38:34 +0200
Message-ID: <20250429161124.658336577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 54a035b079d38..e9d40f9fb09ba 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -763,7 +763,9 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
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



