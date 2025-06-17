Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117BE2FA62D;
	Tue, 17 Jun 2025 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178893; cv=none; b=hQnLrXH1dTNg2qFj5LvrwAQyGjfOlnnZoLCOkstOQY1RkLqKr6sIY6ZYRpCD64mqrey+8wkyODxrRxtVjE3L2QAdgm1PYt6OH+Ue1PUyejJnMNNUOB8Pntg9N6QVk6Z8BZXEHpUATPYdLhUfHsDPnGcnHWhPjVXuevbkXOMAqVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178893; c=relaxed/simple;
	bh=CjiVsuLp+Wyaxrb2m8/CUDNSRQBFUwqY/1Ej7PDvD58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyjOj9ntAeoeiV9r3w9CR/7aNfUMvLLU8O8u/huZEikyfJ6Xff1Y3awMrO6oAOLvVdo3FSqF1G7lpelNu9A07y1XgET659CQPUEViF0gkeEaUxCZIvQGpeSvPu/QfEprxF77Lja0tul8N2Pb8AKTfxvzLjYDrR3xDKxxVdSsJaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptOMQnNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptOMQnNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752B4C4CEE3;
	Tue, 17 Jun 2025 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178892;
	bh=CjiVsuLp+Wyaxrb2m8/CUDNSRQBFUwqY/1Ej7PDvD58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptOMQnNqHB/vCKqMvHdmFuhUmqS/fnJpWghRpL3n3aFKNSos1PxEZtS4AGNBbjSlo
	 PHGnHtwuhFVUPkYFP0y0veVJPhNUn8RU1rnQs7UmLAGQEjAsP1dBjPw/q3MGmUBILR
	 wQW7/oFoXBAAb6F2Gn5ima4LwBpSh9ff8rWDSv0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongting Lin <linyongting@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 585/780] um: Fix tgkill compile error on old host OSes
Date: Tue, 17 Jun 2025 17:24:53 +0200
Message-ID: <20250617152515.304988662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongting Lin <linyongting@gmail.com>

[ Upstream commit fd054188999ff19746cc09f4e0f196a113964db9 ]

tgkill is a quite old syscall since kernel 2.5.75, but unfortunately glibc
doesn't support it before 2.30. Thus some systems fail to compile the
latest UserMode Linux.

Here is the compile error I encountered when I tried to compile UML in
my system shipped with glibc-2.28.

    CALL    scripts/checksyscalls.sh
    CC      arch/um/os-Linux/sigio.o
  In file included from arch/um/os-Linux/sigio.c:17:
  arch/um/os-Linux/sigio.c: In function ‘write_sigio_thread’:
  arch/um/os-Linux/sigio.c:49:19: error: implicit declaration of function ‘tgkill’; did you mean ‘kill’? [-Werror=implicit-function-declaration]
     CATCH_EINTR(r = tgkill(pid, pid, SIGIO));
                     ^~~~~~
  ./arch/um/include/shared/os.h:21:48: note: in definition of macro ‘CATCH_EINTR’
  #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
                                                ^~~~
  cc1: some warnings being treated as errors

Fix it by Replacing glibc call with raw syscall.

Fixes: 33c9da5dfb18 ("um: Rewrite the sigio workaround based on epoll and tgkill")
Signed-off-by: Yongting Lin <linyongting@gmail.com>
Link: https://patch.msgid.link/20250527151222.40371-1-linyongting@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/sigio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index a05a6ecee7561..6de145f8fe3d9 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -12,6 +12,7 @@
 #include <signal.h>
 #include <string.h>
 #include <sys/epoll.h>
+#include <asm/unistd.h>
 #include <kern_util.h>
 #include <init.h>
 #include <os.h>
@@ -46,7 +47,7 @@ static void *write_sigio_thread(void *unused)
 			       __func__, errno);
 		}
 
-		CATCH_EINTR(r = tgkill(pid, pid, SIGIO));
+		CATCH_EINTR(r = syscall(__NR_tgkill, pid, pid, SIGIO));
 		if (r < 0)
 			printk(UM_KERN_ERR "%s: tgkill failed, errno = %d\n",
 			       __func__, errno);
-- 
2.39.5



