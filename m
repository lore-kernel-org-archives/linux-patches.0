Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31C1519BF;
	Wed,  5 Feb 2025 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767733; cv=none; b=fKukyjMsKf32M4lDudfVIe6e2Xys1hwnOSD1EK1zg+J4KbtakujZxmdtOZzMDsP1MLej+0rrQgQAuUVeodx4ASU/Ah9YQNEUTIV2fnDMBmwb9WCPoteC7C0Lpc7pcKCJJyX+jSNw0rPMkvFletwQNoe2vQB1Eb39bjJ9QJOpLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767733; c=relaxed/simple;
	bh=aAw29CDT7b67tvHc1qEFU/UupJR3A5AypnHuLb6bzA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHi05Joce7M5Qm/IuWUqjoZIbiEnYsfmDbebIfAyw8CjAOLHqIGfEz9zzd2bLIC88qBhASC2EZyPckQNXQ16koJYIP+OiIWaKCmWaEueSOMpnapRqngDhuDIIYX19dB4q1/0rZ9DWhOVHo0KIddayBz+fYWjSLgokdapJ5iewuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqiO1AZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqiO1AZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F51C4CED1;
	Wed,  5 Feb 2025 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767732;
	bh=aAw29CDT7b67tvHc1qEFU/UupJR3A5AypnHuLb6bzA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqiO1AZFDvWiiAg5D3ssVdePwp7N1I5HLcsbruMX/HJ1ehGfhAidHDLHHVx+rYJwM
	 6grja1Ga4nLQv957ETxt/uHzojk1VGOzL+NaUjcO+6DCD0fEaz3WZjnwPqnsq0o9ui
	 7ZfiYnwR0LXORe6qHny2Zzxcavjpf8TEIpQvHyuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 497/590] selftests: net/{lib,openvswitch}: extend CFLAGS to keep options from environment
Date: Wed,  5 Feb 2025 14:44:12 +0100
Message-ID: <20250205134514.283073234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82c3264b115ee..704b88b6a8d2a 100644
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



