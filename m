Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2730DEA6;
	Sat, 12 Sep 2026 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216917; cv=none; b=T6RRwd8xrxDyisYNlg9qQx5MJyS7hx0cSfR3hciL+MSzixSGmVkT0oTexjANuqfueBwVZjuKy7EJzvb4JXgml63j2CDmdCkOf7/mspi2FfXFqi0X6EQ/0nRyh7GJcxrIwK4qkF0dX7CqcQXwifwU+c7UNktUknM3hHg6BSQoy4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216917; c=relaxed/simple;
	bh=0CBIOBAUK/5SI1fh4B5iLJhpByVdixh+2hu5UpjOJ7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a88Et5nMT4ItleUIx+48IieXyK/IW9FOm3L8OIglL54k/DtN3yUuXMwzTgm7rltFRS0nLejcybLcnZiemvPJWpH3U5ToYyDVq9C7Y1D2WtYtScTN+GND9DzGT9/5N38sF8n9wN2ZFgBbDERd+XJTlbgwMHH0OPUWo3XGQg4uw+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdomfyOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdomfyOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B91F00893;
	Sat, 12 Sep 2026 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216914;
	bh=ucsxQ1clOiJQPyEFp/4Uih79hedbHDMN8fsrh5TklOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdomfyOZSih6GmGsGBqqtJa2quTYomf+JjcgKEuud2oflaLe4GosZSDqjoVDyhyqZ
	 QwvAZl9V81k3JiZB7poY7dER/SUYMqEFSuJsYLwZbJxxLlPWp+D7LRVvfjwaluSa3L
	 1gWEAlqu5112pHVsoXYkVjG69rlC0zFSWbjgF6Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0832/1376] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 08:54:18 +0200
Message-ID: <20260912065626.088880256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cc6abe0012bf8c04af8275266f8ed7c55ba4a5fb ]

The guestmount path is built with snprintf() into a PATH_MAX buffer
without checking the return value.  If symbol_conf.guestmount is long
enough to cause truncation, the truncated path could match a different
directory, causing the wrong guest to be associated with the pid.

Check for truncation and bail out early.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 03fd3dcd4c986..ea89e7499032a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -289,7 +289,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
+		if (snprintf(path, sizeof(path), "%s/%d",
+			     symbol_conf.guestmount, pid) >= (int)sizeof(path)) {
+			pr_err("Guest path too long for pid %d\n", pid);
+			machine = NULL;
+			goto out;
+		}
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
-- 
2.53.0



