Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297AA140E38;
	Tue, 17 Dec 2024 17:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456253; cv=none; b=TVEq43SadrkqBFD4OWTEXQJPyDQ5JoKWYimO7bCmrqIEURJvNQmbcSIVu5pvx5NtAYDh63ZhgkouyRmQFP93tqR7TEaFxAie3dyy/xVGu9TPxGL4pcX8xCHZrsB/EMXR6okhewhPCQRB5MMou7Qgx2nj+jFIHkbUlk75wbEGdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456253; c=relaxed/simple;
	bh=pt8LnnEZCCMjDfFk8Ja9Gmt1JQjJsVTQTmxoWD9yYWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXoOtltsjgpK/5PP9s12Ty0j+gKUQuKvbriCMf7b6ItBsyvs3c9fI+dP5HNEegTLfFvxtG9jSkqZUMWoKuOgm6LRkcSRUPkwuQdDXEEY4n9dDb/V1ozrGf4Z35vgRWIBH6LeFf+2G8VuEiK+hJqXDdBfcJ0+lWh3L4qVgia0uJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Coje1XSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Coje1XSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4978C4CEDE;
	Tue, 17 Dec 2024 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456253;
	bh=pt8LnnEZCCMjDfFk8Ja9Gmt1JQjJsVTQTmxoWD9yYWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Coje1XSjeNcqLSTRZGhb1W+KgnHc7IYJgQKL8r0lnjcBfoYtebeSkGd/Qw8mfFDp5
	 sqRoYeknrAFkK1Kgg9HNCLD86DG4APHXuZ2stzFvsToIQ3jvFDX2H22U3MQC+mBZm1
	 xNewn/7PFCFF65NzX0k6JjERitRnk4MzcQi7iEkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 6.6 097/109] tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()
Date: Tue, 17 Dec 2024 18:08:21 +0100
Message-ID: <20241217170537.441528614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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
@@ -1814,7 +1814,7 @@ create_local_trace_kprobe(char *func, vo
 	int ret;
 	char *event;
 
-	if (func) {
+	if (func && !strchr(func, ':')) {
 		unsigned int count;
 
 		count = number_of_same_symbols(func);


