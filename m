Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569735AC0E;
	Tue, 21 Jul 2026 18:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657305; cv=none; b=lmH3nYjvfk6ZaOyfklLdtqsguMZkMv4hHDbxFdj6d06pz1fxiVDYDKHUCF5gGKUTncrzHjuh5Cn+I8t626rSxMe6uE5fhA/ytZbD3nYT+cnpui174s8y/k8CW/fhXq7SuOngPDqqvvzFBrjTF5btAUyxhGhV8XaRG66LM4I02hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657305; c=relaxed/simple;
	bh=vhTfY8qYCKYdMDrPlySIX9/w5pONCda8CuUd5GIdLWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cO8VZfi1uItPqyx76QsHXUbjCYTC6Hl7I2jaILnuZ7NPea/pIp+xZ3p2QRkKcMtpry+WUGRcuRDwkHoj1f4FRaUbld4mSzP66XmCvmiHIShTyd0DeoSyV6tFgXlwDCze4FWsQIq6aptJmVBFWox4k+wQ5Ue+6U5PAgsctjnZWBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=va+8okQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="va+8okQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D501F000E9;
	Tue, 21 Jul 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657298;
	bh=mrBLOxgK3MuITyZEgZwRpTHFECTfS/wcC3hKFj9rtbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=va+8okQO1Io/MEBd3iN/vka7QaWQXyvC4gQH/MLdxHetTSkEamfFCVUcykhDBs9AP
	 A/0kld0xal7M6uDrU+tOLJHay+jgu0I9MpDn+NnYN6bVSGksJ3IfgL6R+4ooBCgO95
	 Q6/zTbgO77NF0yzUjvT706Q0hnk/8qA4ly81oKgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0713/1611] perf tools: Fix thread__set_comm_from_proc() on empty comm file
Date: Tue, 21 Jul 2026 17:13:49 +0200
Message-ID: <20260721152531.419297063@linuxfoundation.org>
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
index aa9c58bbf9d32c..9409d32dce04c4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -294,6 +294,11 @@ int thread__set_comm_from_proc(struct thread *thread)
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



