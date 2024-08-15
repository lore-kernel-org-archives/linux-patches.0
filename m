Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606B663C;
	Thu, 15 Aug 2024 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683322; cv=none; b=nTwbEa8j6+ndntniC7gHUL8ARbT9N4f2rLfEqIhhPZVty2pTtMDXSmAfJiwSjoqj42VTU49jiqu8yRCdhiud2JiK50PYJgjZ2LhlryFeOvxE7/y/7LLPuxYNdJzLGc0D4M47OE2XFnx28Yy+utkJ5FED/SFl8nZyZrdv1alScHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683322; c=relaxed/simple;
	bh=xMjGUKON6LLUAWLnJja4K6PiE7W+OUxh2h/3ZA5g+fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pEIhUTZ3pkPjlc01Ct/aBNyNyhbO23Dkmmy/NCG3ADtn0H2Mjbn+GKqEvU/+BfZBpWJ61GF6rF3P/5XbKYQu11cmzq0terU8cccb/DvQ3dT8q3gbWPakHNLXplJZgMj5/fZOcrRXjmGFlUgye3xcoDRbg8JX58vYWts7+afeqwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl60/AXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl60/AXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D2DC116B1;
	Thu, 15 Aug 2024 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683321;
	bh=xMjGUKON6LLUAWLnJja4K6PiE7W+OUxh2h/3ZA5g+fs=;
	h=From:To:Cc:Subject:Date:From;
	b=hl60/AXkRBRAMhBRJRfv3E0Nx2gYuOASZCV7fgOD9pEQYk2ywMUc4DyvzFLl8XDYl
	 HhvXqtK4sFdAce+V4o9nqrK1SMP+36SJa0GeclXDIzdRgvTQSoikJjrz3qO8wA7fWz
	 Ds6jCccJHwC20HO3bwjtDz0kfXqjtP04KLYGNuEW5hSMzZsIxm308wih29PwICWDmt
	 eoMcd4EvmrrPx6hOnpyVjLVN++P8kZAcGVriaaHoM5TS8YwwS9MBaUfGaUwlvo8AB+
	 llHmuHlKALWNot/IVBjtXbSRUtwezcYP+Yb8agOQ4m6JDpXsXTUD+wdbfYecfX8XxD
	 WCsF6kBIb+3hA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>
Subject: [PATCH 00/12] clk: Unit test clk unregistration paths
Date: Wed, 14 Aug 2024 17:55:06 -0700
Message-ID: <20240815005520.1192374-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The clk_hw_unregister() path is rarely used and almost entirely
untested. Case in point, the first patch in this series that fixes a bug
due to unregistering a clk_hw and calling clk_put(). Add unit tests for
this code and test the consumer APIs to make sure the behavior stays
consistent.

The last patch is a WIP because I haven't gotten around to fixing all
the problems.

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>

Nuno Sá (1):
  clk: Fix clk not being unlinked from consumers list

Stephen Boyd (11):
  clk: test: Introduce clk_hw_unregister_kunit()
  clk: test: Introduce clk_put_kunit()
  clk: Add tests for unregistering clk_hw and using consumer APIs
  clk: Fail phase APIs after clk_hw is unregistered
  clk: Test clk_get_phase() behavior after clk_hw is unregistered
  clk: Fail duty cycle APIs after clk_hw is unregistered
  clk: Test clk_set_duty_cycle() behavior after clk_hw is unregistered
  clk: Prevent unregistered clk_hw from being reinserted into clk tree
  clk: Test clk_set_parent() behavior after clk_hw is unregistered
  clk: Test parent/clk flags combos while unregistering a clk_hw
  WIP: clk: Test behavior of children clks after a parent is
    unregistered

 drivers/clk/clk.c               |  26 +-
 drivers/clk/clk_kunit_helpers.c |  46 ++
 drivers/clk/clk_test.c          | 720 ++++++++++++++++++++++++++++++++
 include/kunit/clk.h             |   2 +
 4 files changed, 791 insertions(+), 3 deletions(-)


base-commit: 274aff8711b2e77c27bbda0ddc24caa39f154bfa
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

