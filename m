Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E467147604A;
	Tue, 13 Oct 2026 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894378; cv=none; b=lTf2oslUP8VD/1eUq2SWvN8V7jl++GerLlA7Ai2rMZ8cS5+fPIvXwaMNoB5jUtjYsb2SF8mirKL+jJbKChIccA7qQ21pUocsY44eRrlZqaUy1iy3/7YBAUTztHHZq51dJsUGCndbIMgBCvcwbcGWDd5o0pLb6tJIuQq7TODDqgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894378; c=relaxed/simple;
	bh=r2T6NvPCO4DylhBII8ALV3zTlfuM3BIR0IC65s64ygs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPvLMKlOk5jumMVNjtQgPprd1JUGdZB/o7cqVf8Ddd/2fMiR+BoArCHlTkHe/dcshSFqznMVmmzvCl0JZBCZqmki88nIe1hpyf0P6vJ6nXtRO97zZ8lYC1Z1T8S6ldEobQWNrciA3HfoAsKMolnTxxfUsTGba/tsK9LMq/6hGBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsYWZbQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsYWZbQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21721F000FF;
	Tue, 13 Oct 2026 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894376;
	bh=ku4lXnyOUD+VZGdecBx0ljPXRX2r9JI2xqa/7LJ6A4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsYWZbQZr54ddRflf4Cq7pqVv83NuDK8KOhABvpeDWsEqCY9/HsoGKSO6Qg0IBll+
	 PkSlPq9rYILptWukCaGALPL073NmP8kiOWDTn2kWHePXpQLhiuzaR0r9NC8cpM5hKX
	 BV11j+e2CF0+bveso5IedDv9V1ecnM1jFQYx5XxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 541/621] net/sched: em_text: reject unterminated algo before autoload
Date: Tue, 13 Oct 2026 13:38:56 +0200
Message-ID: <20261013112933.657549864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit c9728fcf2e7fb4a7a8d08ebd9524c3b02ae1a021 ]

This is a follow-up to commit 9c572a83037a ("net/sched: fix potential
stack infoleak in em_text_dump()"), which zero-initialised the dump-side
struct. Sashiko pointed at a pre-existing bug that exposed the change-side
input-validation gap open.

em_text_change() casts the raw netlink attribute payload to struct
tcf_em_text and passes conf->algo, a 16-byte array with no enforced NUL
terminator, to textsearch_prepare().  On the TS_AUTOLOAD retry
textsearch_prepare() calls request_module("ts_%s", algo); vsnprintf()
walks %s until it finds a NUL, so an algo[] with no NUL reads past the
array into the adjacent struct fields and payload and feeds those bytes
to the usermode helper command line.  This is an out-of-bounds read and
a kernel memory disclosure.

Reject the attribute when no NUL exists within TC_EM_TEXT_ALGOSIZ bytes,
matching the check xt_string has had since 3ab720881b6e.

Conditions to recreate the bug:
- CAP_NET_ADMIN on the target netns (namespace-local via unshare -Urn
  is enough)
- install clsact on an interface, then add a basic filter with one text
  ematch whose algo[] is 16 bytes with no NUL (e.g. "A"*16) and
  pattern_len at least 1
- the add fails with -ENOENT and the kernel invokes modprobe with a
  module name made of "ts_" plus the 16 bytes and the adjacent payload

Fixes: d675c989ed2d4 ("[PKT_SCHED]: Packet classification based on textsearch (ematch)")
Reported-by: Sashiko (gemini) <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260918133953.12494-1-bernard.ladenthin%40gmail.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-2DIU.v1.20260929183844@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/em_text.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/em_text.c b/net/sched/em_text.c
index 8052c55b2f4d0..6ee8c653bb94c 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -58,6 +58,9 @@ static int em_text_change(struct net *net, void *data, int len,
 	if (len < sizeof(*conf) || len < (sizeof(*conf) + conf->pattern_len))
 		return -EINVAL;
 
+	if (!memchr(conf->algo, '\0', sizeof(conf->algo)))
+		return -EINVAL;
+
 	if (conf->from_layer > conf->to_layer)
 		return -EINVAL;
 
-- 
2.53.0



