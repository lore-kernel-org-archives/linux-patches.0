Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321723236F;
	Mon, 10 Mar 2025 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630459; cv=none; b=nbXFh210t2P5bwr6pi9XdNKuSMF+nSgBOKM/ZWUGsAS7oj88eee3d1Kif7QKzKddExDhSlGvz7gRDDxQDY9WwhxphtdlNNzvdwLrb+oJPtV4dok5r2341aQie179e5WuiiyCVga64f4a0bgO5/xO5yDF0B16yn5tLdCft46hIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630459; c=relaxed/simple;
	bh=fsXOZwNIFSbGPAgPTJHpYkJdYaRSxY714E7oO19eqJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTCCxzArtqS+3nQ92gxLV4DHlZs7KrXib+W5EE+6xupHR+P6HWxglwtzK2eLgVXVjuAmpVovLzvn/DEVZxsPYHYUUpWScTrB7vIUSjIgWCuiw3nQnR5/z1tOoflDyQO5kfNtxigdkOgQLZxJpWyqpLSUEBkrJdo2aM9bUiGcrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVTeFnQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVTeFnQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC17C4CEEC;
	Mon, 10 Mar 2025 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630458;
	bh=fsXOZwNIFSbGPAgPTJHpYkJdYaRSxY714E7oO19eqJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVTeFnQaElHIotO8RAAxLqYkAYREMjV9ZX+AxXl7PoxQqd3u508VFZU4Ze7RSYcZb
	 EcFijcF12TJDjy5f7N5K9vPV9H6YzfcjWX1nDfzO+sTWQwoR4btPI9T0bpwzjOJbV3
	 +qbYiEN6za/7nO/4ITzqQ1A04P/biBA2IFdW8IaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH 5.15 413/620] kdb: Do not assume write() callback available
Date: Mon, 10 Mar 2025 18:04:19 +0100
Message-ID: <20250310170601.892094073@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

commit 6d3e0d8cc63221dec670d0ee92ac57961581e975 upstream.

It is allowed for consoles to not provide a write() callback. For
example ttynull does this.

Check if a write() callback is available before using it.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230717194607.145135-2-john.ogness@linutronix.de
Cc: Brian Norris <briannorris@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -577,6 +577,8 @@ static void kdb_msg_write(const char *ms
 			continue;
 		if (c == dbg_io_ops->cons)
 			continue;
+		if (!c->write)
+			continue;
 		/*
 		 * Set oops_in_progress to encourage the console drivers to
 		 * disregard their internal spin locks: in the current calling


