Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C135DA40;
	Tue, 21 Jul 2026 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662639; cv=none; b=n7gxURAJHfocG3C8wKvgFkoMxWcj4ClGBuWfr2/Jtm7Z3yT2c3hL/L47gmEFvqx1OVZOxmX5CW/TEHxR+70g56p7o5S+118uI6jp03SMtamF4ozdtwkUr/pGj7t1j2tfb20dEaCv+UiigRR4GtBKPV8Xa8H5F3n+eOX1+MG7Zfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662639; c=relaxed/simple;
	bh=Jd8rzdHB4tMuIUpRpZvfdH1tSPJSn9CrDQHihM0g2/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ppk/Jxuvv/vFwSqTCVGup0kA7lgggRAbhfkzjT7f186kNmOY4MdfoYe8GoO0AvzQAmi1n++rIzz31E3+8bxjQNm7ZIs/c3S3zGTnYIvhSPn7v+3eFIrg3VpG19xtSr5fQewZDc0RwXKt3oj8ZzEghS5e9r+V/VyAfoDIL4kKLPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMbVb+KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMbVb+KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D44F1F000E9;
	Tue, 21 Jul 2026 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662636;
	bh=Rd98SiXMwZWCyJeWeRFMkKWfpMDYTde3Thciw9dTrGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMbVb+KMQuSVV8X1KTk5YLH7QZr/+KoZHaRMUjptBquuqzhuISsJVk/LwQBKC8PgL
	 hTzBLtR5TSYSwBjI0Y0QCZIjEbbe6eMbieQzbZGvGK/MLN7jGopH9brUeFQ3StXzhG
	 Sn1ZqxYsWz7GwyzfcvmofnqDhyumjgFc/I4cJkjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0521/1276] perf tools: Fix thread__set_comm_from_proc() on empty comm file
Date: Tue, 21 Jul 2026 17:16:04 +0200
Message-ID: <20260721152457.774129451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 31d596054550f793508abe7dd593853ece47d428 ]

thread__set_comm_from_proc() calls procfs__read_str() then strips
the trailing newline via comm[sz - 1] = '\0'.  procfs__read_str()
allocates the buffer before reading, so on an empty /proc/pid/comm
(reachable during late exit teardown) it returns success with sz = 0
and an unterminated heap buffer.

The sz - 1 underflow was the original sashiko finding: it writes a
null byte before the allocation.  But even with a sz > 0 guard on
the newline strip, the unterminated buffer would still be passed to
thread__set_comm() which calls strlen() — an unbounded heap read.

Fix by treating sz == 0 as failure: free the buffer and return -1.
This is consistent with pmu.c's perf_pmu__parse_scale/unit which
already treat len == 0 from filename__read_str as an error.

Fixes: 2f3027ac28bf6bc3 ("perf thread: Introduce method to set comm from /proc/pid/self")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 309d573eac9a94..64f29370d59962 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -273,6 +273,11 @@ int thread__set_comm_from_proc(struct thread *thread)
 	if (!(snprintf(path, sizeof(path), "%d/task/%d/comm",
 		       thread__pid(thread), thread__tid(thread)) >= (int)sizeof(path)) &&
 	    procfs__read_str(path, &comm, &sz) == 0) {
+		/* sz==0: read got nothing, e.g. race during exit teardown */
+		if (sz == 0) {
+			free(comm);
+			return -1;
+		}
 		comm[sz - 1] = '\0';
 		err = thread__set_comm(thread, comm, 0);
 	}
-- 
2.53.0



