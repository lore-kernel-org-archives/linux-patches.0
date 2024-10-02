Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB31D0480;
	Wed,  2 Oct 2024 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875952; cv=none; b=br/Y67CPj7nAAVyhCxyaGEIhXenYTi2q2HZLG6ATcz5x/k6kinY4ZfWtT890h3VZ9IgERhwWmb152eioQgQl+69crcHiWgpcOX3FYV5QYQYuwvJBWK8FLis5TFNEuHOxy6V99UUQJzo1rg661npoBGChaiQ/toBzVN2eGWpT+bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875952; c=relaxed/simple;
	bh=+9iWcoitQHZrpSEPME1Z/xBurJGHhbrOHMLohDBa2A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaQTT9zPVdCxWgmXwJ1qNQg/awwHjQfVHk89RQZEbCeB/JTHAk9YW/BBSkroQRV09LvNQkR8ueDxXHrfvD/hMwk8duAteCA1c0vUrlpwFLYY/KM94z7PTpvmjYhDBa/t0cbEvKur1qDMDdOD+WsB0pi26cVmnRlz2bhhBbbrSlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz/WlX8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz/WlX8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944EAC4CEC5;
	Wed,  2 Oct 2024 13:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875952;
	bh=+9iWcoitQHZrpSEPME1Z/xBurJGHhbrOHMLohDBa2A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz/WlX8JZaM5P17eYjJppSwEqCAh2Fr1OUDyN3D+pnU3EP9qiqUkX766jjPXw4r7r
	 uAmJUnFLldVuJrGcaknOZzxaJK8qLITZIVAk2nuxofl3wsqj4Qpm3mmeW2kzvl0gp0
	 9Du50vWGCa4jAyVXLFS9TZCpU1iU7K7crgADBy3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 277/695] selftests/bpf: Fix errors compiling lwt_redirect.c with musl libc
Date: Wed,  2 Oct 2024 14:54:35 +0200
Message-ID: <20241002125833.501699668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 27c4797ce51c8dd51e35e68e9024a892f62d78b2 ]

Remove a redundant include of '<linux/icmp.h>' which is already provided in
'lwt_helpers.h'. This avoids errors seen compiling for mips64el/musl-libc:

  In file included from .../arpa/inet.h:9,
                   from lwt_redirect.c:51:
  .../netinet/in.h:23:8: error: redefinition of 'struct in6_addr'
     23 | struct in6_addr {
        |        ^~~~~~~~
  In file included from .../linux/icmp.h:24,
                   from lwt_redirect.c:50:
  .../linux/in6.h:33:8: note: originally defined here
     33 | struct in6_addr {
        |        ^~~~~~~~
  .../netinet/in.h:34:8: error: redefinition of 'struct sockaddr_in6'
     34 | struct sockaddr_in6 {
        |        ^~~~~~~~~~~~
  .../linux/in6.h:50:8: note: originally defined here
     50 | struct sockaddr_in6 {
        |        ^~~~~~~~~~~~
  .../netinet/in.h:42:8: error: redefinition of 'struct ipv6_mreq'
     42 | struct ipv6_mreq {
        |        ^~~~~~~~~
  .../linux/in6.h:60:8: note: originally defined here
     60 | struct ipv6_mreq {
        |        ^~~~~~~~~

Fixes: 43a7c3ef8a15 ("selftests/bpf: Add lwt_xmit tests for BPF_REDIRECT")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/3869dda876d5206d2f8d4dd67331c739ceb0c7f8.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lwt_redirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
index 835a1d756c166..b6e8d822e8e95 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
@@ -47,7 +47,6 @@
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <linux/if_tun.h>
-#include <linux/icmp.h>
 #include <arpa/inet.h>
 #include <unistd.h>
 #include <errno.h>
-- 
2.43.0



