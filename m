Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859A22F9982;
	Tue, 26 Aug 2025 11:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207062; cv=none; b=K6HcgoPzGxRJRO9yGggdfJfZOY5za1irx6aAm7CvwRaOKKE5kyN+MuYDonJaN4eCZKMYk2SbgOqNkMnuG72vopyw1iQYr4UVrYldnH6IM+iZ5v6vF+yyajF1uTFW4f+yQtXnG68fUnGtHoRYx/AsWuObLNhOxxGN9csIYUl2AA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207062; c=relaxed/simple;
	bh=6q/TKRakhhD3RQKdPDwX4BCMX+RSW7f0di/MuVzpY+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0sDZYQLzypgiDY0+cjC0FTsKdhfUTKT1YmubmuIw/Iprl8abxR0BkTRuiX+Lmdi+6ytJt4rM//Wy6xaGy198j4eLa7NU5pXIUgfC9rDNsWKAe8G0cmXx9tzvmcwui/ZmYKLsbnj/2TYuGqzBMuAWFixPJkqO6bU2VoGobayI98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLHs2YQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLHs2YQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E80CC4CEF4;
	Tue, 26 Aug 2025 11:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207062;
	bh=6q/TKRakhhD3RQKdPDwX4BCMX+RSW7f0di/MuVzpY+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLHs2YQ2ppCO7RHa8r/T2lmB2s1POayhEAs5plg+1TDV1gv6pmghrspc8m7UG+GY+
	 hamDl6cfAkHVUaThIYwu4RuvNqDI9zdIiMguRSBz+nIyrJHemw4OiOuiOq0U3Ki1jB
	 W8zD4Fk6EzCQ8bbPxImQMkqklLjukfNzvohX9Zi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.16 036/457] tracing: fprobe-event: Sanitize wildcard for fprobe event name
Date: Tue, 26 Aug 2025 13:05:20 +0200
Message-ID: <20250826110938.237136264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ec879e1a0be8007aa232ffedcf6a6445dfc1a3d7 upstream.

Fprobe event accepts wildcards for the target functions, but unless user
specifies its event name, it makes an event with the wildcards.

  /sys/kernel/tracing # echo 'f mutex*' >> dynamic_events
  /sys/kernel/tracing # cat dynamic_events
  f:fprobes/mutex*__entry mutex*
  /sys/kernel/tracing # ls events/fprobes/
  enable         filter         mutex*__entry

To fix this, replace the wildcard ('*') with an underscore.

Link: https://lore.kernel.org/all/175535345114.282990.12294108192847938710.stgit@devnote2/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2204,7 +2204,7 @@ static inline bool is_good_system_name(c
 static inline void sanitize_event_name(char *name)
 {
 	while (*name++ != '\0')
-		if (*name == ':' || *name == '.')
+		if (*name == ':' || *name == '.' || *name == '*')
 			*name = '_';
 }
 


