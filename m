Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A522B8DF;
	Tue, 21 Jul 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660352; cv=none; b=st5rv/5bgxig/HFeGWwTz7TdTavyKonq05Sz/4qIg4xdwnN/F7yydHBr4ar4EXDB8dngh1CubWYwzfTTujq0yDVrehXisbrt4dY+CDjrc32t4MO3B/CdZx1yogSV5jGs/iMDMlU5P/BM0VJblg30cR/qaRvuBz6sKHtcbm81KRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660352; c=relaxed/simple;
	bh=1/1pfQEv4iiqmKILEFMIa0DPzoaDV6lcUbQHCeioGF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoBCXDCXKOkycvUgIKA/jKdLOcqEH6PQZa1i5ecXhl2sg00iksZIewFcRDFWvrF2u8LyjGVNo4wmQAQ/wphjJnx/DR+YdPSgDAYOzrGAW3Ceurso3vOK2C16e5sZS7UxpMCmDs+Ui71DSY4KM933+sZ4dsGOfhvMhyDCP4ZwWMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6klZFEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6klZFEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62B71F00ACA;
	Tue, 21 Jul 2026 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660348;
	bh=SFbL6MSmmk0iWB9JuayD7TsFaTjq2RuSkGmJEnvrcNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6klZFEzq8cihXHc1LvZdn98lC+3HcsJIoauNRKadZ5q5rO6xMluIRQ4RtsV4JFKn
	 EbRhP+AncwIVb8D9HSvYCKpEJXlRdyG0PGPfBamf96aF7IbXjoFqG5INkhQOfqeyMY
	 RXmbo+QeNDDzmzhMzvPYmHHS7ffaFYjiIrdeWG4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0946/2077] perf sched: Use thread__put() in free_idle_threads()
Date: Tue, 21 Jul 2026 17:10:19 +0200
Message-ID: <20260721152615.131262286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a99d6394cd48fed75b1d24733d5afe6837a61a3f ]

free_idle_threads() calls thread__delete() directly instead of
thread__put(), bypassing the reference counting lifecycle.  Under
REFCNT_CHECKING builds, this leaks the pointer handle since
thread__delete() frees the object without going through the refcount
wrapper.

The idle threads are created via thread__new() (refcount=1) in
get_idle_thread().  Callers get additional references via thread__get()
which they release with thread__put().  free_idle_threads() drops the
base reference — thread__put() is the correct call, matching the
thread__new() acquisition.

Fixes: 49394a2a24c7 ("perf sched timehist: Introduce timehist command")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7222fe428e7fa7..3646b0eaf44438 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2481,7 +2481,7 @@ static void free_idle_threads(void)
 			if (itr)
 				thread__put(itr->last_thread);
 
-			thread__delete(idle);
+			thread__put(idle);
 		}
 	}
 
-- 
2.53.0



