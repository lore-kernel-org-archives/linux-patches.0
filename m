Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3886038C2B8;
	Sat, 12 Sep 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224420; cv=none; b=UKWgypyUeNvbdY1CKE6BwyDKlDcAAsh3ikplVoM4GOvrszGJITWTnZKO3wrC5pAYJZ/FDoTj6yr8L2AgAOyF/Pk/b2OmUzfahmm4UFevXYTDXm+9VIoExMGkvnqh+lOE/v5EW5z0J5m4h8i36H538n/Cuxh0GcWfUGki8UZQHeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224420; c=relaxed/simple;
	bh=9Q0ycrnNTe67J617L4l7tHhnecL647s8gOAa2ZTbFdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB0GkhQ4Nqea0O2vi3VQE7VAcWkys/7RZYnngbFWLnHmQauKqWJJAzYr0fZQsdKQpj/pN3h8j90bR5Mp8SMyOSjf1nj6FyjujVVwwIDwyqyCXow3AhdmQyf6TB+aca++oaGooTr24NdNein4wAYYNJNb33Z7hj0ScLXeqL6A8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foT21ecL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foT21ecL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCA21F000FF;
	Sat, 12 Sep 2026 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224418;
	bh=w7qIsRJJp3AkuK4by18UlRQjXgJtyuE/9le48T1TZSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=foT21ecLiMwYaQBvH7VW4G4KpubPhEXyPOD+fV0sdqH9F0zO9NG80q3FDlcGMG+CJ
	 TjljZ4cGzwZ8Rss4/QzhKBSQN2LJDAz8YEQ9wCVPKw82Fj42HcYimZaFD+zow4pNMR
	 khV9ZnIy2oLV8VgGijeF6pRDioXMcWkTVSwcm3m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0988/1424] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065629.442799102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7da4de13951c9..2fd5bc6cdf546 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -376,9 +376,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



