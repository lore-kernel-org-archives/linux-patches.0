Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB725F7A9;
	Tue, 11 Mar 2025 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707152; cv=none; b=FSHfd/ilcf+TYzWzqrdHKWGF5e01Hs4dwpctRxndYFYYQ/KNQOLS5YEZTphb0eWseMzNKl5WdK256uZvJkmDzg/RgrLc0cP4GDt2HAO+s4iAqQWfu0aIo3jDmWoFrcHYVQLbYJzg4M9Ygx2PwSr3zImnTZE0J8DQu1ENX2tavRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707152; c=relaxed/simple;
	bh=cqkqpzsHeBFE/X5R6sG2NnB9IZwazypF1YT8w992oEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plihQ/GTnnqI4cIv77UaxP1mplDeoLTke0ze0DL7+SA6k4mCBMkyOkQ4KUmseEcdkHzTBtknPgB4etsZOnb1FH4vgRmP8mAl0oygK9n/FXGG1jp+ZdHQlLhkh9cdFBcZRpBb9Pm3+aDA6jcz0exMRYXmiSurOHi50cpoAPx4NuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY1bPrxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY1bPrxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EF4C4CEE9;
	Tue, 11 Mar 2025 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707151;
	bh=cqkqpzsHeBFE/X5R6sG2NnB9IZwazypF1YT8w992oEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YY1bPrxKg+oMVOmqlNC8aepPxtjQq0sQz4l6AMnl+M3zr3frz9+PJ0zDzNybZ9xEy
	 eybGHvI9qQ6SinaeF5uB8rOGaQBK/F/+Y64ER+CtcIzcJUc9Pq/T58C7/MT8NGX58J
	 0+Pz5pOLfKpOzm5jtb6u852aCBHxADUr/c1PDQGg=
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
Subject: [PATCH 5.10 292/462] kdb: Do not assume write() callback available
Date: Tue, 11 Mar 2025 15:59:18 +0100
Message-ID: <20250311145809.902720261@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


