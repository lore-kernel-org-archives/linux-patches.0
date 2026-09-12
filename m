Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0323385A5;
	Sat, 12 Sep 2026 12:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216906; cv=none; b=UUl0FY03YkcuwqDyj/1PRsr7fcKdE7zx5DzFsc5c4ZY597fZbVL/PbPTnXSKQujxC0K2y2e/qPaYY7RZyUv/TeM7s4PhLQgzSgZ7hizOa8JxdpwbxWS9WdhJUml2Ldn8gPME0jR2SQDjXp73QAveyQLVz3T8ane5EZItfMPJFLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216906; c=relaxed/simple;
	bh=u/olODf6/3VWfohngyofFA74734+PtFwZN+4yEeyS+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzsELkXjW/eJqEwfJ8ATHQ9g+h/CnlDdESUcQ6RvmJX92zNjfApia5fcsHHJkqiGWjh4M68d3IqB5UKqDJCV+QHi+Dfq1lgqTLeUx/yURZdRvvpNSH1xYjjpk9VYbnUg5tyAUyU7YJJGSBGIjoC8FKG58ycjEEH6pR0RTzwE23M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUCiFhRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUCiFhRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2953C1F000FF;
	Sat, 12 Sep 2026 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216905;
	bh=1IeRXHYAJo5aarQEll5N6ums8jtrIKKGeEwSIwbUVHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUCiFhRr/BFgOIBCP8E6mCKocgRNb5mVNvr/7M4Mcs+gK+fAlIt+9GukunTylna0i
	 6Xmu6opJNBQbzQ7VeC6KzK0AH0qyUsgSpna3Ffpb0zNvRxtzmiYMDQU+WXUKgvKkjD
	 6tZeufvqr641qIeephACRexx0rcobxh5QBIyE3vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0830/1376] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 08:54:16 +0200
Message-ID: <20260912065626.042270085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8341737172279..9bd5dd9ddc81c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -296,9 +296,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



