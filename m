Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598BE3905E6;
	Sat, 12 Sep 2026 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230520; cv=none; b=cAduJx+M4DdqxnsDk/g+ymPOCcJG5SykNqxwf4i1NjwkZzJTZSLCsITs5fCopHmVhGBS/BhEuv4LR4ZUOwKRupeUzyh6oIT1Y1U9ERG6kiBncQVraPPdtD7rEDGQQVkzufv96ikZMrgne3yM7h76Ab8gJMqYvsEnwC01Eik8f9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230520; c=relaxed/simple;
	bh=0CJPPgDrEAxhir7Ki4bw7qpqps2JaNC1AYhkjkB3UEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im0cEUFHkC3APNKBzbBX+b9ga1nswhrZL1Lftxo6p+c475rK6ieThKI5NQ/gvBPW4FfEf4veERMFOLcwQIFICHCP7TREQDh59+na2kMS5989zVHPWGGoXGIFT+doDvCT0ZDC6XArFjMyUAQ30F87U9IQoDUpUNs0fpC1D59HBjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFurtF7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFurtF7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260361F000FF;
	Sat, 12 Sep 2026 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230516;
	bh=xlavSSFNTxDhUeTUi74R2sdbTwZf+CaGov8v/Iij8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFurtF7f7jBAL4JXcGiIm2uDJ7cZr1qd/QkSbdpze18E/GXwv4KyvGr/sCwRbAUwE
	 bUpRpEPxdM8SI5XJuiyUL+wB4pS5Ie3V1bhjbTuxa8Cujt/Kpj8JqKEIHN5IpCUWY5
	 kJTyDZbX0AuxrI6kfz6LFzIpQuPyBqnqVnJB0WTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0810/1191] perf machine: Guard against NULL strlist in machines__findnew()
Date: Sat, 12 Sep 2026 08:58:58 +0200
Message-ID: <20260912065606.463294542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9cd52f50ea7ac..6214bbfa5dec3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -369,9 +369,10 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



