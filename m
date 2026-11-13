Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590787;
	b=vsAQcDKQ9WkjdiCPi7QCurc8iCc1qYjZnC1mKxmq8j09aJqVLOevcibBg61acMRUVxPA
	 p2PgZ4iBKN2KziQdQNdJTyY6kBOFPS2rwS4YdU3RPuaO2nsDAhTDkZTqmzGxh8ui7IR7y
	 nm5JIMySEU8qwS4VC3/qeKoPaEEPG2EgGSMF5nx2NinaSYCtx2R0Apr6qZcC7tpKLEANM
	 QvxfopVLZjm0o9CBLx7d6/LCbirPSRf6caXXbi16+zjTxNAmr9xx0oozkOvo/duwfv5g3
	 xAf/3AURBcQIRhlflNWBA+mQ9KA+LZ3VcCaNdp6FwvgtWBkaSto2jhOlwaWiovH5t5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7t2KdZ6NExDbv/R+plzmvBB16JIS91ek4VRLMuTE39w=;
	b=nYe6ersQAmgO8EuVzvrJzwYZouXNDIjujbv/ZMxfNGVIMpRHXJVke59aIG8asWPARgHM
	 c9CQLT31jKQaRhUW8k6C29HIZLMHUcntXrCe17Iy6R+oQX2pJOD82R/uxU+shfFxtSBmM
	 +vg0az4I55DeaggX8jxag0hTKXDZgB33tLQ9qr0j3hnzUbe4mKYNMfDXmFwOo+69Vy0cO
	 tJatLFtyn5aoWsvYDXIOPRYhta+bokKAPD/GtFZD0ugeb+bJJVZKpBqcjjGpz9d0FSEKj
	 RlY2rUpO7hVsgQpyWFt5kqmsoEiKII7mOqkm8SQorzYESMvxcDYHsJvpsyLt+rwPc7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNKJeYWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6B9606E20F;
	Fri, 13 Nov 2026 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNKJeYWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC9A1F000C5;
	Fri, 13 Nov 2026 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590787;
	bh=7t2KdZ6NExDbv/R+plzmvBB16JIS91ek4VRLMuTE39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNKJeYWTjt1vKrj6NEUzBGmNqgC5+tJryr9HbiHF6pXFbzvC1Fben18WkDP0DqRiZ
	 RH95ShXzvFpT3KwH/JrI0bSAeavC5H1hZKDGrmcR/JA8ivUxoeVsLiWeqYM1NaMCFk
	 Wx/HPMdlMcBla0MqlAA0NZtzrrhfiZANdDJS1W6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 680/686] perf python: Free the parse error entries when parsing fails
Date: Fri, 13 Nov 2026 10:53:33 -0500
Message-ID: <20261113153844.688411414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 39e0022c89abcdc1a811dfc0aeec2a2b9010b660 ]

pyrf__parse_events() prints the entries parse_events_error__print()
receives with the details of a failed parse, but returns without freeing
them, leaking whatever parse_events_error__handle() allocated, so call
parse_events_error__exit() on both paths, as the other parse_events()
callers do.

The perf test attr core PMU probe takes this failure path on machines
without a core PMU, where the leak then happens on every test run.

Fixes: f081defccd93 ("perf python: Add parse_events function")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/sashiko-outbox-173525@kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: adjusted context for a stack-allocated event list using evlist__exit() instead of evlist__put() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a65a4d9f8cc83..2fa9670bc51f0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -2075,9 +2075,11 @@ static PyObject *pyrf__parse_events(PyObject *self, PyObject *args)
 	evlist__init(&evlist, cpus, threads);
 	if (parse_events(&evlist, input, &err)) {
 		parse_events_error__print(&err, input);
+		parse_events_error__exit(&err);
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
+	parse_events_error__exit(&err);
 	result = pyrf_evlist__from_evlist(&evlist);
 	evlist__exit(&evlist);
 	return result;
-- 
2.53.0



