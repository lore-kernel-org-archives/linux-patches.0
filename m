Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB339061C;
	Sat, 12 Sep 2026 19:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243011; cv=none; b=FgBAPNi940oqKcHqQXhTOrXZBhwe/MCSFqyv91z3P160f/atXxaMqZrT29NhG+qGo9XlQ39zL7V8OFH3x4AKaNJVbXk21XSdkJevM/NmXeMx2FhHrJop/vCH3UyOzjtEdphfzSaGmUzqmu41bDsXrc/Vrh1viKSpXIuKmAM18RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243011; c=relaxed/simple;
	bh=JQ/X/UrhqosXxrBMGlnNMgG6cTjUcK8IZFkOAn8wXjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kukYYCUDdPQG3LIa1xDe/9G2Ghoy3tqvBWXXZsKIm/NijlDF7tABVNx0q0hfd7KE+gdkWK8ZcONjwQBa4seD6EMgWw8yYKpVVXRsxuu8Jbs+Qa+b0rlaCsN9vJYdnUEgQuw6kcO8t6aCzh+bowB7Y+XLJDk9ZlP6jFKM0Q3nqSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVtB27vP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVtB27vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AD61F00893;
	Sat, 12 Sep 2026 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243010;
	bh=OeHsMnF9oi2JqaH3K8G3Hvyf+YmzwX2th1JX+er5DPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVtB27vPwsXnJ/uYNvVlRoLx0AW+bGIxrGJNoXSw0bBLAnf/bZ5/k+4/kIfsQUgUp
	 crOebXzw3LAYmBdqkppdEb0lEaGUlXkEgps7LxwgovHn/Tyx8V05e4NnuN5kqOWSZC
	 pSaAoQIhLoV4UlnULG6c8x3e8QQz9+/V9k9spZf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 562/798] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 09:03:10 +0200
Message-ID: <20260912065530.008382667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e27b96d0a34e1dc87affecf221a99fee8f6c5afc ]

The static 'seen' strlist caches guestmount paths that have already
been reported as inaccessible, to avoid repeating the error message.
If strlist__new() fails (OOM), 'seen' stays NULL and the next call
dereferences it via strlist__has_entry() and strlist__add().

Guard both calls so that on allocation failure the error message is
still printed (just not deduplicated) instead of crashing.

Fixes: c80c3c269011 ("perf kvm: Limit repetitive guestmount message to once per directory")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index eec926c313b13..51f618debbaf4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -354,9 +354,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 			if (!seen)
 				seen = strlist__new(NULL, NULL);
 
-			if (!strlist__has_entry(seen, path)) {
+			if (!seen || !strlist__has_entry(seen, path)) {
 				pr_err("Can't access file %s\n", path);
-				strlist__add(seen, path);
+				if (seen)
+					strlist__add(seen, path);
 			}
 			machine = NULL;
 			goto out;
-- 
2.53.0



