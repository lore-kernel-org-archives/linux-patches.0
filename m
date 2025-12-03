Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B002C35CBA2;
	Wed,  3 Dec 2025 16:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780136; cv=none; b=fTgpqQnn523le/viMY8yiBFwz+6Shv5+CSW70w1W1sYooZ8gIjECBfUTI753VWx7UmD3JxX/1aBMR36oXE7e+Qzrpf8VQUpGXAxC3ltNgnfnVihRXMjxUr69arTefTM2/DYcaGsv0iWElcNJyvPUx9dBwrwWyQueCtFg1oHt7a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780136; c=relaxed/simple;
	bh=JD+th2TnAPMc/3095Qsi8PSlId2mrHCafUj4ZigXgYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgXgUJBXAOnvp6X3KxUHTQY1m8VU7a/er2i/Bqs4g6iYa3jjIbA92SBqXU4FrSHypjyva6JF6/ucJ88GCDTrPK5PbPwQd2Zcj+ImxtXhKm1MG5dHqGkVKuvpwurOdHHeNGpx5FSiHk16oZDZfEZHr8NfvfNDp17Sos4KkVAfUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9VEfhDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9VEfhDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF8C4CEF5;
	Wed,  3 Dec 2025 16:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780136;
	bh=JD+th2TnAPMc/3095Qsi8PSlId2mrHCafUj4ZigXgYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9VEfhDlA0QZg1NgCzKxs7vi58rpLdtscNAVMQP7SHpV9RD0C1VyPwWf8LL+oBycf
	 TylOXl2PJxfyAObIv1Ovq1WcD9/RiBgpl8PAJkqU6+MWotoSiHLWpUAiqMZtOrnVzc
	 3NuchG6ZyPmWTIPi+D5jldb8duBIV3Y9Ovs6prB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 467/568] selftests: net: use BASH for bareudp testing
Date: Wed,  3 Dec 2025 16:27:49 +0100
Message-ID: <20251203152457.805862811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



