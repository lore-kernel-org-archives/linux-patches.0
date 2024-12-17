Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1062E1F7562;
	Tue, 17 Dec 2024 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455661; cv=none; b=EwueftUVCxPw8ily6fVXwVYn6A2a3sXFoxY4PkZbcs+ISVxFWLyr/GLAkqi4sgOT03k7/3iMgyFhZJ1z0bx5+nIVjBJoVDoQoMlRHRMGOw2P52gPvW7CS0k7n35YyZfO+QkUbHNFxWTQHEq6ZJqR+pfeLD51W2jPpTIlbXqWrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455661; c=relaxed/simple;
	bh=vOxECXJ63sNZxHg/V4gxxBzysmRZjFEAXn4t6KaiqcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR9eWQp4FztI1wQfVSxDcBLKwfLsIq+gNdfSvQWhZ+NtK8UeE/cyig0p9JcjPkqMKqGzBDnJS5MWYYjmINb1VDx8UDwUsuy7g7YB0TC5DzfFwgbAhtBbqSGJ6S8AR9M2qlwaoVKnzWVUN9uBxuJ+gT0BKPCmnPNkWO26mjYd/kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fecSbEyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fecSbEyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE9BC4CED3;
	Tue, 17 Dec 2024 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455660;
	bh=vOxECXJ63sNZxHg/V4gxxBzysmRZjFEAXn4t6KaiqcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fecSbEyLNz76emTt+X0zSmH47fBb/+4nE2R93IW92teJhY0iltKL8/zOmEXpmjeVI
	 QJZrbwXdI1fVt12O/I3BoxzsuvaTYp+aF8Qw++MnIWbO8Xcza9xTj/CUhBbLJ8AZtw
	 P6I18Oe6NvcFW61KTA92q8/2bGrLkhvMU7AfeSPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 5.15 41/51] tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()
Date: Tue, 17 Dec 2024 18:07:34 +0100
Message-ID: <20241217170522.160047675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
avoids checking number_of_same_symbols() for module symbol in
__trace_kprobe_create(), but create_local_trace_kprobe() should avoid this
check too. Doing this check leads to ENOENT for module_name:symbol_name
constructions passed over perf_event_open.

No bug in newer kernels as it was fixed more generally by
commit 9d8616034f16 ("tracing/kprobes: Add symbol counting check when module loads")

Link: https://lore.kernel.org/linux-trace-kernel/20240705161030.b3ddb33a8167013b9b1da202@kernel.org
Fixes: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v1 -> v2:
 * Reword commit title and message
 * Send for stable instead of mainline

 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1823,7 +1823,7 @@ create_local_trace_kprobe(char *func, vo
 	int ret;
 	char *event;
 
-	if (func) {
+	if (func && !strchr(func, ':')) {
 		unsigned int count;
 
 		count = number_of_same_symbols(func);


