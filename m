Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F1818D621;
	Wed,  5 Feb 2025 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768298; cv=none; b=ri0vRghoFtIJT1oRtDNe3jNPkB/f5/GRIlaeY3vyB08rmWAii/bwSHF2Tq15fklf1tbTquregs67Z7ZY8/tNIS9QZmuqkQ93ed7dOrTfnnTqvZhjKymF7gyHj4nCBSjCHemGuqdFQ2bv0ajrhXoLRUcCfgLUCVbZvXm3nTdIluU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768298; c=relaxed/simple;
	bh=RdFTYVl1qN6xD8JZPwP1qEmYz59xZ1t1QZ8PIy+s3Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPIhW9zCUujzxP4MpdbxUurK9IIW3YWB5TzsO2TOXDq7Srw1wpTODruR1DzDKVL58VIcw9tRmOGKcyM+ggu7+3TQiArtX35MRDbzCDVz0+6r2T8J2IhB7pJcgpQ2Ew7ln/RInDvXEZd1YRienhECLCa+Qi2oLwl7KPFPwsNc1Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIHa6/xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIHa6/xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C25EC4CED1;
	Wed,  5 Feb 2025 15:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768297;
	bh=RdFTYVl1qN6xD8JZPwP1qEmYz59xZ1t1QZ8PIy+s3Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIHa6/xf20Bjoqw9P3uyQxp3jQLoUYkEjdcQM32BBQRcHIKy9Q9NC0ikEGlFBY2uL
	 UNbo/x3TFi10cPkKB4UBUO0eb+MB6cRULFaMCv8EgEqUCJhSeEuznGDeEDpkCKluzr
	 L9qYOBIAmCq7pYABsZqFOdowcD3sA0bVWmpXDhX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 527/623] selftests: mptcp: extend CFLAGS to keep options from environment
Date: Wed,  5 Feb 2025 14:44:29 +0100
Message-ID: <20250205134516.386743129@linuxfoundation.org>
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
index 8e3fc05a53979..c76525fe2b84d 100644
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



