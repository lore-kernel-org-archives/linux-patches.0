Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A4B1C5799;
	Sat, 12 Sep 2026 18:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239387; cv=none; b=hpdm6H3L9OxbjXV9dGUv5sd/ME6FZIcmYZa3ggK5+USXgCdP6Ha5FnklAr5W0bAHEOFckkG0rRudgGLOW/jrMarGTINXfeQyxL+elXRbqPIdiRNLIHCAJA8O5hjMIBzjlWtsrdSkaIRS1alt3QNheZ9JhwTBg4CbUNZz03jtzuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239387; c=relaxed/simple;
	bh=fbbt79Knu+POZCjBcabIudTfyCyg52nDhcd4Z317i44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg43XK6Jl+gjJj+rE/LyUG1eKzonris1CaYFNjta5vMX0qbxISIGcXJCozDhrH/OlHCJbRc7OPOLygrCiS8Qr4IbSCPSeTYAbSleuWRJsBj8r0sip6CszEdfjAost5hfw7X6zMn+iKDoK0DSFMld9DbhTNalAklhu3RcLD/kHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+tL/JWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+tL/JWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFBF1F000FF;
	Sat, 12 Sep 2026 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239386;
	bh=orccrBharHrRytkAUeuZ6fYk/neiCXnPUGYh+BKV+dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+tL/JWyP1xFhH44x+/f1KlrmJRiohBKdYGdvCHqLuTXgNYnWJIZU8fZvM0oSWji1
	 aRz9GZ4IllimRi5Jyjg7faDFYpwndqlu2ESNM4o769eICKLPiFIaXRdjIMu60RSfz+
	 wPbyO8FT2XnmS/OyUE4nwtXHpqGmMzbwGIJx7VCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 654/935] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 09:01:24 +0200
Message-ID: <20260912065541.843368145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0df9d24b2cb4..16df0e96c9ed8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -355,9 +355,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



