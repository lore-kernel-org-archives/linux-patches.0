Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75225DF59;
	Wed,  5 Feb 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767908; cv=none; b=estg609B577mj4GqOVksjG/1MEE9ldVFdQ/axVbKCuP/PjtY9dB045V0/c3bYs1SSIKUHDrZcr14rBO/5iuLYnelD8GbVuJfXirCNyMIldWDtGgaV0WFOWWRjDr77HJap7YEq+ct6wXPCft7aSUJbsLpZaN39MzKKhCAlWWX270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767908; c=relaxed/simple;
	bh=lMlRd1RHsK5AZoa2brCZCl7gHmaUZWefwedzhHHpd4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjNgVLXdYYlzCGJVunbMnn/s3wK9g+I/iRXm6V1PzE9CDIVsCRdWDgtEDD5tTXQvOiLNb2bWjHcgnAnYghkPfy8zI7BqwMBrAQCGhDAplF9VXg5xRn3IckRR1nusG2nbIIKxh2XDY2NBSQoKzbH+Kdst6prhS0wyQxeM4Aqzgzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdwAgYfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdwAgYfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6929C4CED6;
	Wed,  5 Feb 2025 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767908;
	bh=lMlRd1RHsK5AZoa2brCZCl7gHmaUZWefwedzhHHpd4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdwAgYfypHNnD2kNoCQ4l43YrjpAP7Ct1f67eZygZPDo7UCpPx2M+XPr2eY8PO7rA
	 bP+PDcq6r2/t6fsGIyt2/fdjYLBGubiuNMxqwnLohJosIzwQ2p9f8bmF4L0cOtCUeC
	 i73OSRxcHsUImAKdmSmiZ1fJSlG7vA0yH4xhsQlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/590] selftests: mptcp: extend CFLAGS to keep options from environment
Date: Wed,  5 Feb 2025 14:44:11 +0100
Message-ID: <20250205134514.245152718@linuxfoundation.org>
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

[ Upstream commit 23b3a7c4a7583eac9e3976355928a832c87caa0f ]

Package build environments like Fedora rpmbuild introduced hardening
options (e.g. -pie -Wl,-z,now) by passing a -spec option to CFLAGS
and LDFLAGS.

mptcp Makefile currently overrides CFLAGS but not LDFLAGS, which leads
to a mismatch and build failure, for example:
  make[1]: *** [../../lib.mk:222: tools/testing/selftests/net/mptcp/mptcp_sockopt] Error 1
  /usr/bin/ld: /tmp/ccqyMVdb.o: relocation R_X86_64_32 against `.rodata.str1.8' can not be used when making a PIE object; recompile with -fPIE
  /usr/bin/ld: failed to set dynamic section sizes: bad value
  collect2: error: ld returned 1 exit status

Fixes: cc937dad85ae ("selftests: centralize -D_GNU_SOURCE= to CFLAGS in lib.mk")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/7abc701da9df39c2d6cd15bc3cf9e6cee445cb96.1737621162.git.jstancek@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index 5d796622e7309..580610c46e5ae 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -2,7 +2,7 @@
 
 top_srcdir = ../../../../..
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
+CFLAGS += -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
-- 
2.39.5



