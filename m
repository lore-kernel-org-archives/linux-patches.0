Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6D1DE8B0;
	Wed, 19 Feb 2025 09:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957600; cv=none; b=Zo+jNjrDwi/pLOxTYTkIDbfB4KnsCk42Aeem9IXDr8LJZAcS7NEl/yaFr2ttU7e7SSIlXwM0zwEKmIMGgR+kuI4t4JBbrPH3VBOzqikrqDG5QY+2/MuUXX0xuVbFOY6TTjWMJW0IafGYEqOthOvjX18ePuBYbYFqao2QHAjfpbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957600; c=relaxed/simple;
	bh=THdSF2SX+lzr54sO+bveNOek/GfRMn9wn8e2NfgV0Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqmpN9Svww4/DMzpRaSkbYUgkRBYXqj0SAovG2SVhQuZ5sqGP8YXWfWhwyqQ1ciFTdL88EyB799Y4XpKlGta0j+1BqIqdI+MY9dpFBw0J9n2DH0Qg363QTrpc8gzu6/uYoeUjRNM/6xIsuiS2ntQDkRgS3BDoR0EFEiapd5gM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo8ujuDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo8ujuDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D46CC4CED1;
	Wed, 19 Feb 2025 09:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957597;
	bh=THdSF2SX+lzr54sO+bveNOek/GfRMn9wn8e2NfgV0Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo8ujuDWX6XMPmniA0fyQtnOP+H0eT0dJjhA5J+RR886LlHPVGV05LBTVC8l9MS81
	 AfQsf9UW5vXr5GshJRmFoGa1wOGZqcxqMt15z7w1BqANWJ34jiczy9zbBSjnIZdZJ5
	 n4AXqFFuzcetWjl20SVVJkMaPrLpbMIOd/FIKKaM=
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
Subject: [PATCH 6.1 559/578] kdb: Do not assume write() callback available
Date: Wed, 19 Feb 2025 09:29:23 +0100
Message-ID: <20250219082714.945543689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -576,6 +576,8 @@ static void kdb_msg_write(const char *ms
 			continue;
 		if (c == dbg_io_ops->cons)
 			continue;
+		if (!c->write)
+			continue;
 		/*
 		 * Set oops_in_progress to encourage the console drivers to
 		 * disregard their internal spin locks: in the current calling


