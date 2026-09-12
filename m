Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777B19E7F7;
	Sat, 12 Sep 2026 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201093; cv=none; b=h7FR/cPObLdxeotCMvlIYBI0qil1dYActFaFa/fkL7D90SewxKvi6cX2bZNvRdhTdauNFhr69lOFFQPssycamdXjx+frQGdMQwYMUiLRGSxE9Z9T2s+bS6zOz9EKOrhxep9nrig0RNYrb6pj4vQfslNIhunJFABUeHZOKBkioOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201093; c=relaxed/simple;
	bh=XnHlgNsw5EopHc2jVBnZkn2uQAHYwx52yRk50Fp4J0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K40j3wHvB+MfSRAdE+IAfpSduJ7XLKW8Qif+XKioXk4zNoxWHTTM2nckYF3KLBG02wpEVXZgvcY1cweR7U/7NiaRMqdJ36HMSdNq3TycEOu8RusmLp1+cbSYawbBHbEtuu2Nd6HSopxYK/vXoPGSfdpTZ0ujHsEulHNmQ8xWqY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uzl/UCVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uzl/UCVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A971F000FF;
	Sat, 12 Sep 2026 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201092;
	bh=k8/CQIOkocQJ8KlrD6R3lKkCU5yIvgWTQyQouGY1sNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uzl/UCVoPkVHL6VAt6pJbeYQoyD+NJ1ckwqfXe8NJiA0oknq9aFb7r9PJXc3PzXnk
	 jQmOJzMU2/O6UC3cK4Ivwo2CGil2kb5N/rPMhdT9Ba1V8NoqI0Li7VSJlJuVWB0aPC
	 3HFWYmtaKkmG1y4aqf8OG64KsJl/b5Nbv4YaX5Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0926/1815] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 08:44:36 +0200
Message-ID: <20260912065710.679610532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8b213482e5648..baf855e596c26 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -340,9 +340,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



