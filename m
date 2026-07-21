Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F027B46D091;
	Tue, 21 Jul 2026 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657135; cv=none; b=ut3nSVKQ6ozCT50IV5xCpOg3FsUENqLA49hKC3wARDvB75vfDMTCWBVc/E/I4xkltsQxKoXgXMOn9gr53HpqLNXkGdWuCd2peOz5dziETuQolw3G9MAL/Qb7MIirYKbmFqJUapI/0j6UjSJINy97kJ1hv/iSctj7hGrHEwEg7G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657135; c=relaxed/simple;
	bh=UvPWRnk++1H9BcUFLgF/Tj1y4uuOGqUXM3pgN4xpc/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqtUo6BluNlVoQ9N1WWtIPDXqydbDyc7laQCxSxFFfcxSZOMtmQy2dl1AkP3yxvOuPc8LyyEbonFcSWGdEBpL23cC+8O+g6ET8OAVIj2v2EWb1m/jC0o74SJ5o68HWdfTUeO0aoJjJAAsNsDgfeT/xKSsOGTOtmg6Sq2ezbQejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA3CzMh4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA3CzMh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C4D1F00A3D;
	Tue, 21 Jul 2026 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657133;
	bh=ih0xHjrgiwWqq8QB5A2UlH1qaLcROd+BHVpqML8d+ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA3CzMh4ON43OVr2AWTcm4LU/6YiNXaJAKbqIsd3ycUwYGFJ0N2kwJnhBSIvnfHoB
	 9xz5u9uT0hXrPYWDJkSYagiFJWAs41EBEUwb7Bz9IZwbwlp9XbxNqwbDFZJOi9nGAj
	 qtccsZYgSpLGKcyXuy3/kPx2w/foVmM4VPa+A4LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0648/1611] perf sched: Use thread__put() in free_idle_threads()
Date: Tue, 21 Jul 2026 17:12:44 +0200
Message-ID: <20260721152529.966293966@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 34e974ef49891b..e93606446cc3c6 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2474,7 +2474,7 @@ static void free_idle_threads(void)
 			if (itr)
 				thread__put(itr->last_thread);
 
-			thread__delete(idle);
+			thread__put(idle);
 		}
 	}
 
-- 
2.53.0



