Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EB61FC3;
	Wed,  8 Jan 2025 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297936; cv=none; b=S9i/vSxGoH+skUknHOS5FjY2YrmKVrhC0E8ZaN8EkDDh6tRfoeW+EZNPBCsbQQmtsWOrDdYUAulXDxG8GBZCcodggVgjUD9GoHetfjNQznOGTOVZ9Ye+YKPvXux3xKcokXIKpw3WSN5hs1798xq7JTg/Zbeyu37UMvx3kOJFew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297936; c=relaxed/simple;
	bh=ioQtssOka6MflKMgcxybfGFT8j3DH0KOUIGFlRpLQFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kd+9nJSg9Z/tgqmfcAaZapRHIpJEA5UAB4H8X33TLietxjKub+ALFQAdQaltfwnfQ368ZxhR4kxdl6kL9d8eLodcyaFFe9lLKRlzolTkbsfpLDZZBzQ7L6g04PHjIoHPN+p1gW0mROXP7Ytmctq/yyjnmVIxCuROh5g2DTrW6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBgekz9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBgekz9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDCBC4CED6;
	Wed,  8 Jan 2025 00:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736297935;
	bh=ioQtssOka6MflKMgcxybfGFT8j3DH0KOUIGFlRpLQFQ=;
	h=From:To:Cc:Subject:Date:From;
	b=NBgekz9fddLswipGTV3NujiapW7h87og1tIAfDmIGQhZCllcs1kpEiTA9umfY0drE
	 LuNpBq1r313eVw+nzKK3Yvae7cJR76I2YjsYikQexgW2QATvoatjEL3Uy2CqCvZLmc
	 4iKcrP/lF8cOsQfje6WwqOglc7J1eaD6ZInQ2V/LjyX+jqvolpnzjG+qPsHpPymDDX
	 rOrghY+WSZqGjRmW2IIhsVgHjL4/0EgBkK2t8caPMG7lEjT5iNhAT+6+zQ1V/PxjNH
	 CdVLAG02qlvpA+nAzCTv1HY4YGkFa4AbPFlUjmZ2unrGzb1AUe0cOOxiNoruuptk4V
	 KdbXT7/opZx7g==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/4] clk: Move debugfs to a loadable kernel module
Date: Tue,  7 Jan 2025 16:58:45 -0800
Message-ID: <20250108005854.2973184-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series moves as much of the debugfs code as possible from the core
clk framework file clk.c into a loadable kernel module. The goal is to
move the debugfs code out of the primary vmlinux and allow users to
decide if they want to load the debugging logic at all. To get there, we
make the debugfs code use struct clk_hw and then add a bunch of helpers
to interrogate the clk_hw enough to satisfy the use-cases we have in
debugfs today. Finally we move the code from clk.c to clk-debug.c almost
wholesale, except for some tree walking logic and functions to
interrogate a struct clk_hw or install a function pointer to call when a
clk is registered.

I'll probably wait to merge this until after we're able to limit the
exporting of kernel symbols to particular modules, because I'm not super
excited with exporting internal clk details to any module. For now, I've
put the symbols that are newly introduced for debugfs into the
"clk-debug" namespace.

Stephen Boyd (4):
  clk: Prepare clk_debug_create_one() to be split off
  clk: Use struct clk_hw instead of struct clk_core for debugfs
  clk: Iterate instead of recurse for debugfs printing
  clk: Make debugfs code into a loadable kernel module

 drivers/clk/Kconfig     |   8 +
 drivers/clk/Makefile    |   1 +
 drivers/clk/clk-debug.c | 529 ++++++++++++++++++++++++++++++++
 drivers/clk/clk-debug.h |  33 ++
 drivers/clk/clk.c       | 646 ++++++++++++----------------------------
 5 files changed, 763 insertions(+), 454 deletions(-)
 create mode 100644 drivers/clk/clk-debug.c
 create mode 100644 drivers/clk/clk-debug.h


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

