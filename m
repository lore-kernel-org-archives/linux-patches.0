Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55225415F38;
	Tue, 21 Jul 2026 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657111; cv=none; b=qVVnZlyTZs/bteOcszUuTN4Um8bvwXpwpDl1kQwLgd+CRBkiLY/nNonwow4rn3cWpGyP04jK5UsvDRHAabftqSj/gJprTBWtItGCs9SqWGx3m6JXhZZQGCqwMinHMmk4qVz9SLIxYgrh2JA7SxAan2vDJQ8PwG1/ildV9BVAW8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657111; c=relaxed/simple;
	bh=ogbh43wwtsjw3RDG8LUE3FohGp70t8+YZjSRiYEQZY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mizi09oi9dVT7+mcobtgnhVoeiI/BVzRJP8ndQP/Qla0ovE6Q6Wp6FmX8bjz2wVDr6tnGpppbSBNf+Uz9haX/TYjDTTgFhq3u756JxKlIpM0+L7r0jKDCE4nFejgya5kxvNzsfeRcjAY71Pw3OiXCzxHl0hoZD0hbzb2SNDbk40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6VXbzme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6VXbzme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6A41F000E9;
	Tue, 21 Jul 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657110;
	bh=YRWgpqbTn2vwDxTZmabQoRhsTq8BWrQULFYMSwIWWp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6VXbzmeUrAHaOYhTvYiXGvqOtVlqOGxCkM9+xQwn26KxOpxz0CjP8voLYJF6e59Z
	 vYVoOHFWT4kNf2NbqLlYv9C1m2ERJDFaSjBjAfDdPRClnF5OzDFRHOo+WqKTu2ucKx
	 EgWJgvxuyj7f7Ib43dhhFA+t2tMM6tbFBeByDils=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0640/1611] perf tools: Add bounds check to cpu__get_node()
Date: Tue, 21 Jul 2026 17:12:36 +0200
Message-ID: <20260721152529.786055002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1e7921d7227de5da0dfc167943092c823ec7e49b ]

cpu__get_node() accesses cpunode_map[cpu.cpu] without checking against
max_cpu_num, the allocation size of cpunode_map.  Callers such as
builtin-kmem.c:evsel__process_alloc_event() pass sample->cpu from
perf.data events, which may exceed the host's CPU count when analyzing
cross-machine recordings.

Add a bounds check against max_cpu_num before indexing, returning -1
for out-of-range values.  This is a central fix that protects all
callers.

Fixes: 86895b480a2f ("perf stat: Add --per-node agregation support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 89570397a4b350..0b419783c9dd08 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -548,6 +548,10 @@ int cpu__get_node(struct perf_cpu cpu)
 		return -1;
 	}
 
+	/* cpunode_map allocated for max_cpu_num entries; input may be untrusted */
+	if (cpu.cpu < 0 || cpu.cpu >= max_cpu_num.cpu)
+		return -1;
+
 	return cpunode_map[cpu.cpu];
 }
 
-- 
2.53.0



