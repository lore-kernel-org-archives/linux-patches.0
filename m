Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02903546E1;
	Sat, 12 Sep 2026 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209277; cv=none; b=ujBCKD63dPrNftoMopMSadjo4N0JjQpgonjz+k0u8zdPGn9IrgzuYOoY5qI9KG4VoGC3U43z0bkAYjSXNnPwUIlCsjH6UfJIFmG81tpRObi+sqHxqX4kz1m+sthnvBj1qCdgC4DQiJmyZrlpgIGcgsc2DlhXrfoJvb3QJxZCJdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209277; c=relaxed/simple;
	bh=hU6nd46aqwvE+f5bz0RTKoXj2FI2frhB/s3QX5mo6ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkAMBjRYXZHkzvtv+KLnDqAjdoDqCFXd32JqutSHAPmrTND4NHax/v+42X88IzHb7srImlGSgpZNI1Ru0J92cwH0fyDJfMyov2R0/b+ensYckF5XTQCR9W6YHMLjF1TGWxDTLpBsaLtAhjhYXc/9F7PDBtXu+O19wvTs7G39zwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki9Ha1jz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki9Ha1jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DF31F000FF;
	Sat, 12 Sep 2026 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209275;
	bh=pBsrqmDWqBzrpKdOUH185xwGhrQ2HTyufonuGj2r68I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ki9Ha1jzr6kJv4Wyn57+FvBQCg8hL7UxnpEwlJl3nl+F6DqaxH+Xeq3NjYlJfJgrs
	 cWlpFgqsJwdNDZVLtbpe97ksbSddvi9LBpjDFrF+noL0/Yqsa9+/SaBAKVZ2D228T9
	 clt0ZMu4r9a3IzNwyLDVhGh7E7CSmEKooFER7dW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0781/1518] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 08:49:10 +0200
Message-ID: <20260912065641.104469713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 8b6869582b076..25591f9969e15 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -334,9 +334,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



