Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FBE1DA3D;
	Tue,  3 Dec 2024 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239174; cv=none; b=pLKK+dWPyxAL23hsrlmIZ6ig/ishMxCo0NA4zDNPV9wv0JuSACYBPfkSvs9p/PX8ECVvtjd0lZIbgZTRnAKHV2P/jaVorBPAp8zYgVIn6cDVRlH+1ez5OLUim7+GnKEzqZipJAkpxxeGoPQfmqTzqNdlSAfZFC9zTYqip+9VRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239174; c=relaxed/simple;
	bh=scPZ8OHMzNUUtmNvnxMPO23mr9FIBJf3KvHEAoNosVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3iKkI1c7JGMslwhZgGeO7X2kRYZ05qrEMrAD/JkX7LD8yCRugH6/GqCulrV7abXdTi0e46yGh6ZZyxDrZ6r154Q9HtkE61ya9VwS7wjpfcQxCy60q/nr0gBcBA0xcNdYkexxk64Hh76bsLo3ZpGKPJNtUvNylY4YnQ04SFQ0es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrhC/MhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrhC/MhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E20C4CECF;
	Tue,  3 Dec 2024 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239174;
	bh=scPZ8OHMzNUUtmNvnxMPO23mr9FIBJf3KvHEAoNosVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrhC/MhRQdvd1PKD2R1bnaGu8HxJXuP7bKsYj+AVNYSZ+j0IWdg9uIlNfRIBz1hkY
	 Hl5UWB0/vsUOfsF0WtHV8sIyJpDzfem7U4KU5pmmcX9sLfP3LDRBktVySqW3lX5F7/
	 RHdi7pIfyGSNn8yEpVUygzPxdpBGrMfZFB5uB+zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 525/817] perf trace: avoid garbage when not printing a trace events arguments
Date: Tue,  3 Dec 2024 15:41:37 +0100
Message-ID: <20241203144016.389603888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Peterson <benjamin@engflow.com>

[ Upstream commit 5fb8e56542a3cf469fdf25d77f50e21cbff3ae7e ]

trace__fprintf_tp_fields may not print any tracepoint arguments. E.g., if the
argument values are all zero. Previously, this would result in a totally
uninitialized buffer being passed to fprintf, which could lead to garbage on the
console. Fix the problem by passing the number of initialized bytes fprintf.

Fixes: f11b2803bb88 ("perf trace: Allow choosing how to augment the tracepoint arguments")
Signed-off-by: Benjamin Peterson <benjamin@engflow.com>
Tested-by: Howard Chu <howardchu95@gmail.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20241103204816.7834-1-benjamin@engflow.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 19db23f78b199..5298118ffb15f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2802,7 +2802,7 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct evsel *evsel,
 		printed += syscall_arg_fmt__scnprintf_val(arg, bf + printed, size - printed, &syscall_arg, val);
 	}
 
-	return printed + fprintf(trace->output, "%s", bf);
+	return printed + fprintf(trace->output, "%.*s", (int)printed, bf);
 }
 
 static int trace__event_handler(struct trace *trace, struct evsel *evsel,
-- 
2.43.0



