Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EE4335069;
	Thu, 27 Nov 2025 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255989; cv=none; b=Znu0oY5lDMqkJ2BSK+X7mbCQ4uBU4LsJqYpewMK2ucPb2Mck1/ZBZ1BQXTRV+aEIBpyb2/ak10pqye2zurEPZdXqOzCMjQS5Ti/4VhCbo1mZKy+De5N/TXS+oUbcMrFpc5Zu2LTuh73jH3Aag6tHrOoqC0kOHctxO0MMmD+RZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255989; c=relaxed/simple;
	bh=TlQRAsSld7liGVBkDb+G4ZAg970JCnmYiqwkTbwq+5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjJA8WYjsiKTZckx4Mv5HoeziQ0nYSZiEGGhGQ6FCUtbn2DOqd8pJsHi8HMk//rSwBgBaaUw7ziwGzxD5gsySpjJX40xPX8yLD2tpbHogZzStXq4KoxwyVXntn4jBfxABlxJyg2Q886uycEXBA73qThDgu/7n5jaZfd3cLUiYrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci5bJW4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci5bJW4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569E1C113D0;
	Thu, 27 Nov 2025 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255989;
	bh=TlQRAsSld7liGVBkDb+G4ZAg970JCnmYiqwkTbwq+5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci5bJW4+jezbmXL7Sc0BNLV5r4mQ/eR+0ip//R62UK+Ys9odX24l/Z7mXqpLaaojR
	 vFpQxz/VDfl4/UvvrdztzBMRDxQF0iSM1AFs17fPw7C5oRTEYNoA5yapbcdxawZ0aN
	 czhuanu5cM9LPHgt7ffO+9/MI5rquBvw8NeSLO5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/112] selftests: net: use BASH for bareudp testing
Date: Thu, 27 Nov 2025 15:46:29 +0100
Message-ID: <20251127144036.027173199@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 9311e9540a8b406d9f028aa87fb072a3819d4c82 ]

In bareudp.sh, this script uses /bin/sh and it will load another lib.sh
BASH script at the very beginning.

But on some operating systems like Ubuntu, /bin/sh is actually pointed to
DASH, thus it will try to run BASH commands with DASH and consequently
leads to syntax issues:
  # ./bareudp.sh: 4: ./lib.sh: Bad substitution
  # ./bareudp.sh: 5: ./lib.sh: source: not found
  # ./bareudp.sh: 24: ./lib.sh: Syntax error: "(" unexpected

Fix this by explicitly using BASH for bareudp.sh. This fixes test
execution failures on systems where /bin/sh is not BASH.

Reported-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Link: https://bugs.launchpad.net/bugs/2129812
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20251027095710.2036108-2-po-hsu.lin@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/bareudp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/bareudp.sh b/tools/testing/selftests/net/bareudp.sh
index f366cadbc5e86..ff4308b48e65d 100755
--- a/tools/testing/selftests/net/bareudp.sh
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Test various bareudp tunnel configurations.
-- 
2.51.0



