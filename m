Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6691B4257;
	Tue, 17 Jun 2025 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177039; cv=none; b=aQc2iAAuMiQeG1+WhpeM8olfTrPtnpFMrlYhNNPXqNDRrugyUTtfIPXBdpSGEKmPwMqeNgPr8TU3EWqZzazhiZfwdEkzlvCkHM04xfaLwE3ihESN94Aa9L24sneRTeaL6OoFXGZXCAtCXchm1XvX2hFCsCwmCYIwjXLo9TGOzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177039; c=relaxed/simple;
	bh=nofw/bzlnfzr7ZZVJ7ehJMZmPifq+JiscvCdJnQ9118=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSXU1HhFuuBYCRB38MHg6XONqRHtLqTWOJghjhe1eMI7UD9ZlKRllG7yUuP9lELIwPhHKMkd1xl135Nlg1Y1ATvL4ORpR+iMHFP66WxMcl4yzT2Y31WI7QbgLwOzKipVNMAZtCzRJxe0PP8qh4mu/zPf0w8uzAbyIie9enwgY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9550iBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9550iBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938CBC4CEE3;
	Tue, 17 Jun 2025 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177039;
	bh=nofw/bzlnfzr7ZZVJ7ehJMZmPifq+JiscvCdJnQ9118=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9550iBcDKMPHE/WvU6M2b0wixohPBn2FyDplPL9HEvo8gERJw9zeEwXmqQHahNy2
	 O0yy+Pn7Kug7QWtp7p0YKDJNzwSgK2+TtpnYL7x0sWWuMNqYVP2Cs52ogI+Qsj0Hi/
	 3xTolfLrW/P3+/meI4wBBgoUAfJKuYYY+8xFn2ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 251/780] rtla: Define _GNU_SOURCE in timerlat_bpf.c
Date: Tue, 17 Jun 2025 17:19:19 +0200
Message-ID: <20250617152501.680525634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 8020361d51eea5145402e450d91b083bccdcd874 ]

Newer versions of glibc include a definition of struct sched_attr in
bits/sched.h (included through sched.h which is included by rtla).
Commit 0eecee340672 ("tools/rtla: fix collision with glibc
sched_attr/sched_set_attr") has modified the definition of struct
sched_attr in utils.h, so that it is only applied with older versions of
glibc that do not define it, in order to prevent build failure.

The definition in bits/sched.h depends on _GNU_SOURCE.
timerlat_bpf.c does not define _GNU_SOURCE, making it fall back to the
definition in utils.h. The latter has two fields less, leading to
shifted offsets of struct timerlat_params in timerlat_bpf_init.

Because of the shift, timerlat_bpf_init incorrectly reads
params->entries as 0 for timerlat-hist and disables the creation of
histogram maps, causing breakage in BPF sample collection mode:

$ rtla timerlat hist -d 1s
Error pulling BPF data

Fix the issue by also defining _GNU_SOURCE in timerlat_bpf.c.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250430144651.621766-1-tglozar@redhat.com
Fixes: e34293ddcebd ("rtla/timerlat: Add BPF skeleton to collect samples")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/tracing/rtla/src/timerlat_bpf.c b/tools/tracing/rtla/src/timerlat_bpf.c
index 5abee884037ae..0bc44ce5d69bd 100644
--- a/tools/tracing/rtla/src/timerlat_bpf.c
+++ b/tools/tracing/rtla/src/timerlat_bpf.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #ifdef HAVE_BPF_SKEL
+#define _GNU_SOURCE
 #include "timerlat.h"
 #include "timerlat_bpf.h"
 #include "timerlat.skel.h"
-- 
2.39.5



