Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39184389104;
	Tue, 13 Oct 2026 11:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892510; cv=none; b=OaCF8OiFJrc6tQsYdnoU44DN9ExEaQd6+3W2agRoxTjvDPpVEZiHNz7jfarxdOUu3Rc/DevqrNlQ2G/ocB2Nq+tMo49X+VQaQyUgICu9UnpZ1M/m+NzSpXeZV/A/fKPcclaecb1I2ohvQqcRo6nnSEgwDCSUvenAa0SvNBBpcIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892510; c=relaxed/simple;
	bh=7aSAplnAbUzlv+6OPULybigCHnbF4jWP6sZLRuirXc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdPlOrLXK5voQEagae9cWLEPfzdDvUEsIxcbMaLDtxjMXF6Ag/BGUPsHbrmClGWOz0fGu28/n2ukRs6jiWNr4owsLfp9+VkTFZujh7stxLJSautwmyI+f+/UuAZRrb8jx9K38RHtPE+JHuVllCa31MKYQEY62UYsovplWa+8QjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScFcHBZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScFcHBZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8475F1F000FF;
	Tue, 13 Oct 2026 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892509;
	bh=wYyYBQeYw5mQgI7aAiMbGnTF/crKuYQD2HquMZZgFL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScFcHBZwxfsH5W+cWlOkW7ggfAwFsItSTIYUyKOMfQqLeZiDUpRKjy91NVjuEOn4w
	 VkFzZW4HVMP1x4WiYH/8dFJVmj64a2q2ieNWSeEG7ue6k8tA1vM8jt4+x2ahyDTL3p
	 o+/1Aq4d+Uxv8kBZsjVYYWcj0brbjV+hpmM74HGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 197/281] net/sched: em_text: reject unterminated algo before autoload
Date: Tue, 13 Oct 2026 13:38:33 +0200
Message-ID: <20261013112859.945535685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
index 4132f8c3c5fc9..bc45edb8c03bf 100644
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



