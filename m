Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015772;
	b=et9s1cSGZTT+JHR20AO1SuZ1S30ITJvHjck7NiOm5WjlxJW/dbwp+LNcK1fc7azad8l+
	 Ra+CMXtUqeTqEGZhYDqGL5zF1SRt7FrSQ2DhBIo4zX+4MScpkckx0I5J26r9RiaAQVEyn
	 RMFLEC3T6vK9qR13Zu5i2nMpO7Tn3Q2gNqfA84g79NLNzviAy+Oj62NirZsUBjiPkQVUC
	 BFwZLDhSZzhteBvLmBIn4ekPkll/Bq9tzDiURvDl00I2u6K/DF9rkKpp7YsBAGxtwrSe4
	 nC8xd17xFEGOHYfUoTRZlHoAknbM7BgERJac5b2SfiihqMHSDxkeAvwXelQEUet062g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3J8ELjKd3jXaHUWmP82vKK0jr40clYmFIbTEpyOReBE=;
	b=RyJDoU+aAXQNdIH9UQjEznx3k6MrzAAZPWECZn1jlwp5M70r5+kBmd479dEvliWig2KD
	 WoXsOnLVXhPSU+jHLsjYN0lZnbI8JKnPU9BigJbdqt+d9/ymxfQbvhXkKEr+Uc+BaQC32
	 pdkwnsRmsuR7cj8edpcWfPcqo3uaihveM4vIe6i5VomConDy7A8MB7eJyoYYQhsz/MBZt
	 6HJja3W1QiIYKwrmYRN7T1uFYL/xBU6efoP1KtCX8X7EHSmMoFJHOvSzquupN5tImMADB
	 b2gXbVX+hV5KS2+uHrimPXZH0IrFJpxn2uglbkecVtSyYCxud61rz89ui5Pv4nK779A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS4h+DrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DF1606A31C;
	Wed, 18 Nov 2026 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS4h+DrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51D61F000C4;
	Wed, 18 Nov 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015772;
	bh=3J8ELjKd3jXaHUWmP82vKK0jr40clYmFIbTEpyOReBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS4h+DrFQtRWr3D761YBSRXlhXlNQq+T3vQTENfMOdKWYurBwzQWAEjo7KYVhNHsk
	 GAn2NRB1GW4Kit8YNp8cInAoAjwcEyDzXzhOIT2OYiZmHAI2fk6CwjNmyHe5833yYF
	 1d9vMssP9Bh/17sUbkjkFdtXrSbFZHNGc+Z7iOEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0290/2651] perf stat: Avoid uninitialized memory read on error
Date: Wed, 18 Nov 2026 15:25:30 +0100
Message-ID: <20261118150258.346548013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 93fd7adf1a47c61ef81b33c8fdd9cb4e4ea0bdcb ]

If has_supported_counters fails then msg was passed to ui__error
regardless of whether an error was written into msg leading to reading
uninitialized memory. Avoid this by always terminating msg at
initialization.

Opportunistically reduce the scope of msg to make its use clearer.

Fixes: c9a8c343ef2f ("perf stat: When no events, don't report an error if there is none")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20260908220720.564614-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c50cf230f16ed..37752d6bfef45 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -777,7 +777,6 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	int interval = stat_config.interval;
 	int times = stat_config.times;
 	int timeout = stat_config.timeout;
-	char msg[BUFSIZ];
 	unsigned long long t0, t1;
 	struct evsel *counter;
 	size_t l;
@@ -908,6 +907,9 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 	}
 	if (!has_supported_counters && !stat_config.null_run) {
+		char msg[BUFSIZ];
+
+		msg[0] = '\0';
 		if (open_err) {
 			evsel__open_strerror(evlist__first(evsel_list), &target, open_err,
 					     msg, sizeof(msg));
-- 
2.53.0



