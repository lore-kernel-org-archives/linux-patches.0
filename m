Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606D919F485;
	Tue, 27 Aug 2024 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771181; cv=none; b=ex1eHxPBIzLJc0x73dB8sCuHzm81uJzqpYpPhGFras+0nXCaegzcydvr6n3lgLvyUF5J9SvCp/F5l7pTsg/94VTUvscC7sRL8zKs5IoAW5TT3tdY8BwE2KoUkQ+AKmqCTZQC1AUlw9SAHn3lLXAsLQ/DBsdO02+bvmYEVrRuGi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771181; c=relaxed/simple;
	bh=kPe4ve067nEKhbGCn+LK+zlpYgVUk3tko2lRx/AQeMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqccCMmB5UB3WlY8tpCxW5J2Oc3wPuI3vaIcWQeYRTaeSQWDhbwHlKgq6MNaKexdV5zHF7nC7tIjTq1e7v16wDdeM9mTCDJU0Ba2fnDqCyVF65WdnNsof/x0HYTCdt5a4Eqai5uUp4xGEYzqV37bbdDf+1HPJSsAjwfUTOWeqoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVrprAEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVrprAEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA39AC6107C;
	Tue, 27 Aug 2024 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771181;
	bh=kPe4ve067nEKhbGCn+LK+zlpYgVUk3tko2lRx/AQeMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVrprAErNEl6zu9h2nIHRam7SExr/5Zjk483hxolWPrDq3Q29hKOPcHYdrzGC8KRY
	 d1bLrEMeIV0lr6TgLg6fAIOg2YcmQRRqUPLIIRphTcBq5tCQon0tfSiMuBXONqGlmm
	 u8CqQLjDzyroXdQeBEFzCWBzt0wvkLg27N/SWoPo=
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
Subject: [PATCH 6.10 112/273] selftests: net: lib: kill PIDs before del netns
Date: Tue, 27 Aug 2024 16:37:16 +0200
Message-ID: <20240827143837.671440494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b2572aff6286f..93de05fedd91a 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -132,6 +132,7 @@ cleanup_ns()
 
 	for ns in "$@"; do
 		[ -z "${ns}" ] && continue
+		ip netns pids "${ns}" 2> /dev/null | xargs -r kill || true
 		ip netns delete "${ns}" &> /dev/null || true
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
-- 
2.43.0



