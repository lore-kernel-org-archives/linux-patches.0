Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305628135D;
	Thu, 27 Nov 2025 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255880; cv=none; b=siJSf1whl86uV3OF7mhNx1wSPeBQyx5pjSVTPX2HkuNbOVwiHZZ2pjznqwmcY3irAuppMTyUTgLPwZPyWk12cWNyhE6dx/7Zuo7HGDGfC5fr2BG64ZdrTFFMAEt2mx/vgJlBWO+pu8wrqxjSdTrM5j+lmX7ttOkYvhyO2wQCWzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255880; c=relaxed/simple;
	bh=hPY8s491yHgjWvkTGC/NLJPF8BfsVvzyTgAlz+l38hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc2DsM79Z5ZWMg9hOpi2jEz0oJP/EgX/RGYbvCE11TvObvPQDb4Bto319f8r3/SrWps4GJ3W66BfuwiHZ/RDT2x1oK8TcLTqRzSSSpEK91WHMMYe0vuj/wf/JZz8wFHgU5dnPda3i36W1U3gILeyVf3C/3b7j5QPWo1/ZApEtzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZv9e/Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZv9e/Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E141C4CEF8;
	Thu, 27 Nov 2025 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255880;
	bh=hPY8s491yHgjWvkTGC/NLJPF8BfsVvzyTgAlz+l38hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZv9e/GhCzH+anevVDc5kjpKWGqDiuly0xwn5FFy9C52pv9bxWxYtV49WrjJP56EW
	 hh+VMiY/k+GsFvKcSNmq5NJs7chmjiefy11A+INIIAIahRJAmErl8y6yKfu4lWsJK0
	 UNFVYFkqkHfPtO/l6lCsMMWvBooR+BPIT1gl2l38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 147/175] selftests: net: use BASH for bareudp testing
Date: Thu, 27 Nov 2025 15:46:40 +0100
Message-ID: <20251127144048.323311459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4046131e78882..d9e5b967f8151 100755
--- a/tools/testing/selftests/net/bareudp.sh
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Test various bareudp tunnel configurations.
-- 
2.51.0



