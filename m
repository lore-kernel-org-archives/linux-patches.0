Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE861C578E;
	Tue, 27 Aug 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769928; cv=none; b=QALW+uSNNj5LVb2vmvYzRgEk3fgTfA+NifS6eaYpmFPmY85Pe5vSYPBBRR8kJoWqDIKSLpcr2VzOtScTgeGrPan1xccMNZC57jTsaTLT6fvle2HOujFdIBvcJ9zhoFGkyoSDbzU2UVtN5SPB/8kZr0YCoULPho1kWEouP6+cz2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769928; c=relaxed/simple;
	bh=rmtGvV8BZV9E72/ZrlhQwixrOI2cjnBRJbC/XXaI858=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNzVDd1PPvWoljzg5acquq5QyPTWbb79RCxi6dMtz5ZSsaC75Extd64LdaPSqOFuFFKAstV/Zpqp+0fgV2hc5MO1qWJ73IZ/visbU3mm+JFAkwPTOoacMEphauNC15K0xcTT500HZa+Rv4JA52mWkVao2mvMO2mviCKEuvEL+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRsSb3TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRsSb3TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC747C61063;
	Tue, 27 Aug 2024 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769928;
	bh=rmtGvV8BZV9E72/ZrlhQwixrOI2cjnBRJbC/XXaI858=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRsSb3TIl2KrrHmD+3OkX9Ai8tqi5YL/pSecEgUnQaSija798Wf/2nSZU2rlpqgOZ
	 bUc04MRnsCxKD0PzO4Or7r4TMS534qspnEOlqQpBQS2mykZ7vj3xl8lTb7I5fpV1R1
	 g230p2r4bwm2BzeDWjxmiBkmniSQfuK/rSKhL0wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/341] selftests: net: lib: kill PIDs before del netns
Date: Tue, 27 Aug 2024 16:35:08 +0200
Message-ID: <20240827143846.341969927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 7965a7f32a53d9ad807ce2c53bdda69ba104974f ]

When deleting netns, it is possible to still have some tasks running,
e.g. background tasks like tcpdump running in the background, not
stopped because the test has been interrupted.

Before deleting the netns, it is then safer to kill all attached PIDs,
if any. That should reduce some noises after the end of some tests, and
help with the debugging of some issues. That's why this modification is
seen as a "fix".

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Acked-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20240813-upstream-net-20240813-selftests-net-lib-kill-v1-1-27b689b248b8@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index 323a7c305ccd4..e2c35eda230af 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -42,6 +42,7 @@ cleanup_ns()
 
 	for ns in "$@"; do
 		[ -z "${ns}" ] && continue
+		ip netns pids "${ns}" 2> /dev/null | xargs -r kill || true
 		ip netns delete "${ns}" &> /dev/null || true
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
-- 
2.43.0



