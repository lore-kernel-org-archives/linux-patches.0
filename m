Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC4222D68;
	Thu, 12 Dec 2024 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019719; cv=none; b=Zdtdcrg9i2UdMa/mrgBUH6ZEzx4+SXp8JtM5r/5DF2N6EtqtxUyVfcVwqhVRmUyIzyt4nVif+BPPhtgjvE4wD2A2G11qY8t4iVNMK7b8/8MPrYn05IZiNj7kp39GERr9h+GYK4qp9qqRPuU9leTDOg6bhL5CdmkFJ+BifMeWWHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019719; c=relaxed/simple;
	bh=kZAMC5RUd94aDpsjk+1V+ARTucZTwY+mkXFmx690/rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJymjldxeUSHbIRUWU3OOVF9PPvaerYGvMf6O9WdKE2ss7X6vzGcHDn87K94sudBF3rKtf70gsVToaQLADcoqB97YdrQ6k5OjDr5Wd5k3ryPsWQS7j7SzLIdx29n6fbRRdU9K4ae/Ge/cFpgzETEyBQ+UymdS90hZMY/Nib0374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTYCD9lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTYCD9lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04B0C4CECE;
	Thu, 12 Dec 2024 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019719;
	bh=kZAMC5RUd94aDpsjk+1V+ARTucZTwY+mkXFmx690/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTYCD9lcznFbSh1KpJFROuGf4HRCa0ErviwtIBZlXhF4VvenrXHUXNrgXKWEoXO1S
	 RWTch7+1xfyCQkeD2JHLi3mSGJt+3jALM913ViD7JvWR3/5kYy6FPxzhSObNZeLyGZ
	 vxbrLTpcIygzN2RUiRbavGDKnJtVNlF8YBfgBYZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/772] perf trace: avoid garbage when not printing a trace events arguments
Date: Thu, 12 Dec 2024 15:53:44 +0100
Message-ID: <20241212144401.437433409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93dab6423a048..9aafa332828f8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2770,7 +2770,7 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct evsel *evsel,
 		printed += syscall_arg_fmt__scnprintf_val(arg, bf + printed, size - printed, &syscall_arg, val);
 	}
 
-	return printed + fprintf(trace->output, "%s", bf);
+	return printed + fprintf(trace->output, "%.*s", (int)printed, bf);
 }
 
 static int trace__event_handler(struct trace *trace, struct evsel *evsel,
-- 
2.43.0



