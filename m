Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2E3BBFD8;
	Fri,  7 Aug 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113735; cv=none; b=uWWUk0ZupGhUhnB8VkGcnUWc/37gNOPdIFgy6LN8biA7uxlidCnxyJbvDM9jFZHOrgskqLrywNTnXgm8lHlTXyvANWlGU260GHdags3fbuiUs8cO04RONM8AIy4b56xGXQv21hJ+3yjx195DFjJzpG0/1+vtda25HyHhF8Vzvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113735; c=relaxed/simple;
	bh=+iIGKw7sIwHqEYl+bXpiRpOLK8lp7UU8lj+gaOlJHa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNMb3iOnsfBIdYKqrPNEfvx7oq+/IAiK4lHthGBcdHcCguvm9gLiJQKW6dQJqipzVpnAM7VCobJ1fAcd3Thr/SLozL1jccPcEGmvRqZUPtoXM6NsiDe5XCbJKAHn+UaQxWN+EP5uZyqDGHjTvRyrO0sauVaOrgf3bqJ5Z0kMNc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCai8+MD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCai8+MD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41641F000E9;
	Fri,  7 Aug 2026 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113714;
	bh=6MJLIMPQfjqJKvd1QV6VDjcDse6Od7a1uynCKUvcSp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCai8+MDlTRYX5pMC2ZcLKC14czmYmCUKBgHj2pUkHfm5X9W6g4ghWuwefGk3lRkg
	 UnCwqjR5kuwmwz+EQfbBcwUxMg9Ovc5vS+qgX15LjFRXD+qQ0VSvfnnexrVvZo4gaW
	 I0taI4EGCfsxE96ARrysEGC+d+mwHk3ho7JhpX14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/337] um: Add os_set_pdeathsig helper function
Date: Fri,  7 Aug 2026 16:33:25 +0200
Message-ID: <20260807143418.572136819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit 4e5adbe447db382cc76e05613581f96aef4f91d2 upstream.

This helper can be used to set the parent-death signal of the calling
process to SIGKILL to ensure that the process will be killed if the
UML kernel dies unexpectedly without proper cleanup. This helper will
be used in the follow-up patches.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241024142828.2612828-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/shared/os.h | 2 ++
 arch/um/os-Linux/process.c  | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 77a8593f219a..2a0843cc2208 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -219,6 +219,8 @@ extern int os_unmap_memory(void *addr, int len);
 extern int os_drop_memory(void *addr, int length);
 extern int can_drop_memory(void);
 
+void os_set_pdeathsig(void);
+
 /* execvp.c */
 extern int execvp_noalloc(char *buf, const char *file, char *const argv[]);
 /* helper.c */
diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index 2686120ab232..4015d3dc3958 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -12,6 +12,7 @@
 #include <fcntl.h>
 #include <sys/mman.h>
 #include <sys/ptrace.h>
+#include <sys/prctl.h>
 #include <sys/wait.h>
 #include <asm/unistd.h>
 #include <init.h>
@@ -234,3 +235,8 @@ void init_new_thread_signals(void)
 	set_handler(SIGIO);
 	signal(SIGWINCH, SIG_IGN);
 }
+
+void os_set_pdeathsig(void)
+{
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+}
-- 
2.53.0



