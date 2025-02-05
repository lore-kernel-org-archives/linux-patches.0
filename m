Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3918D621;
	Wed,  5 Feb 2025 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768304; cv=none; b=OoLD/emttPQcyvoPhh6aXfVXnCCJe9teAk1G2anCihEESJ0c5lyat4NuLnqKT0ArRzPn+Tj6SgUhqw+B17FyCXwJh6arnZbjSKXk8Wj0ws3gobQ+KZjJtUsRqcV0VbyGkMgaUFhlkdyJzz2rRA4cnR2QW94yMAtYz4/z7B0/t90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768304; c=relaxed/simple;
	bh=MYeVt+XObSgD8XUcKAN6mrM0tTY2qe38xx/jAsCKkAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcOoDy1A3HH9gawTvk3EOhzz/OYVyBN17iwCt1decd0xDWcaPrOLkt6x2J4dSoZvZXs+zDz9URyxg58GmWNFjuLeYAAvOS2hc6bXQjft5PaDAQWrSywiof+RusFMbYLoAS1vc9dl2XYq4r6aFm7LIXuvgnGpxT4IJUXJ0SEmxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEz0acnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEz0acnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A952C4CEE2;
	Wed,  5 Feb 2025 15:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768304;
	bh=MYeVt+XObSgD8XUcKAN6mrM0tTY2qe38xx/jAsCKkAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEz0acnlXPWZolhoL+Q8a8fmrGRMR1B5ePI25q6cyon5S/+bIX22OJGqOxbeXyLIt
	 t3WX5W8712iFrWblBnoVPfqyxlhDfdBq02qGTOUk72rBA+4XMfi9SNU9XWt0E/IOFV
	 leA5aI4h+EZ2YD1EmlUFX/Mbdysm/BEJdB39yvBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 528/623] selftests: net/{lib,openvswitch}: extend CFLAGS to keep options from environment
Date: Wed,  5 Feb 2025 14:44:30 +0100
Message-ID: <20250205134516.425342520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit 9b06d5b956131bde535f5c045cf8c1ff6bfba76c ]

Package build environments like Fedora rpmbuild introduced hardening
options (e.g. -pie -Wl,-z,now) by passing a -spec option to CFLAGS
and LDFLAGS.

Some Makefiles currently override CFLAGS but not LDFLAGS, which leads
to a mismatch and build failure, for example:
  /usr/bin/ld: /tmp/ccd2apay.o: relocation R_X86_64_32 against
    `.rodata.str1.1' can not be used when making a PIE object; recompile with -fPIE
  /usr/bin/ld: failed to set dynamic section sizes: bad value
  collect2: error: ld returned 1 exit status
  make[1]: *** [../../lib.mk:222: tools/testing/selftests/net/lib/csum] Error 1

openvswitch/Makefile CFLAGS currently do not appear to be used, but
fix it anyway for the case when new tests are introduced in future.

Fixes: 1d0dc857b5d8 ("selftests: drv-net: add checksum tests")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/3d173603ee258f419d0403363765c9f9494ff79a.1737635092.git.jstancek@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib/Makefile         | 2 +-
 tools/testing/selftests/net/openvswitch/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib/Makefile b/tools/testing/selftests/net/lib/Makefile
index 18b9443454a9e..bc6b6762baf3e 100644
--- a/tools/testing/selftests/net/lib/Makefile
+++ b/tools/testing/selftests/net/lib/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
+CFLAGS += -Wall -Wl,--no-as-needed -O2 -g
 CFLAGS += -I../../../../../usr/include/ $(KHDR_INCLUDES)
 # Additional include paths needed by kselftest.h
 CFLAGS += -I../../
diff --git a/tools/testing/selftests/net/openvswitch/Makefile b/tools/testing/selftests/net/openvswitch/Makefile
index 2f1508abc826b..3fd1da2ec07d5 100644
--- a/tools/testing/selftests/net/openvswitch/Makefile
+++ b/tools/testing/selftests/net/openvswitch/Makefile
@@ -2,7 +2,7 @@
 
 top_srcdir = ../../../../..
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
+CFLAGS += -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := openvswitch.sh
 
-- 
2.39.5



