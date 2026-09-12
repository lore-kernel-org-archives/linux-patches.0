Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E83447CA62;
	Sat, 12 Sep 2026 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219244; cv=none; b=NXi3+WYvzbTdhxUq980OYV2grFt1WZLGtBr1oeNi1A3aVDuga9CsjE9Vhd1caAU68BSnudNqi/hGDd/XOtYUAhCtzAZLiez0kxaQ5P+JfSVzqCTFs6CpR0DGxuwh/HlPsH5rDd55lxd1xVbt+N8AUUaILAmUavSuEzwQNS0jlMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219244; c=relaxed/simple;
	bh=94nJhWcXG2ijgyCQZWW89ZC/XqcfHo2dRuwx1VRYDMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eub1p7honfAetqdNHUSySltzWIQKxFXJ4dOMU1fDneB6ze3UA9k2WmdIi9Exo824VgVUFsE1KEej1YvXoZcCD950sJmwpFBlggdtPRFbJ0sJu3/oL5dPgabhz14D2w9+ysCW9yPKj2d7qjJsIqwJ6BCRNp1BAm57aFiPVgvcAak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI4CHZNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI4CHZNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54561F00893;
	Sat, 12 Sep 2026 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219242;
	bh=zr4kshE7TK/LCwXk3FoNZtB2Yru+z4JDqK+Nq+kzcOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rI4CHZNGnG49oYIZcPaDPig8YoPpLQiBIHe7NS4/U8I0V0kGyn60ldXK5TGhbj2A9
	 5iHb3YmedeM0FpcHRmAdIXMiAuti5ZG4R7wv2TAatgPvMUF5O89ROuqTsEKaM5zMg9
	 q+fbQANsdwf9bLcITAyjYauCCigLRVUX8Ge/f1oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1312/1376] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify
Date: Sat, 12 Sep 2026 09:02:18 +0200
Message-ID: <20260912065636.775938948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d79fb758e7e2e7a181eab630c0545a56041c473d ]

ftrace_direct_init() assigns kthread_run()'s return value to simple_tsk
without an IS_ERR() check. When kthread_run() fails it returns
ERR_PTR(-ENOMEM), but init still returns 0, so the module loads with
simple_tsk holding an error pointer. On unload, ftrace_direct_exit()
then passes that ERR_PTR to kthread_stop(), leading to a
null-pointer-dereference.

Check the return value of kthread_run() with IS_ERR(); on failure,
unregister the ftrace direct call and propagate the error code.

Link: https://patch.msgid.link/20260826015034.10755-1-vulab@iscas.ac.cn
Fixes: ae0cc3b7e7f5 ("ftrace/samples: Add a sample module that implements modify_ftrace_direct()")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-modify.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index 3bb791e0b05ec..a44ca313d916c 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -237,9 +237,15 @@ static int __init ftrace_direct_init(void)
 	ftrace_set_filter_ip(&direct, (unsigned long) my_ip, 0, 0);
 	ret = register_ftrace_direct(&direct, my_tramp);
 
-	if (!ret)
-		simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
-	return ret;
+	if (ret)
+		return ret;
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
+	if (IS_ERR(simple_tsk)) {
+		unregister_ftrace_direct(&direct, my_tramp, true);
+		return PTR_ERR(simple_tsk);
+	}
+
+	return 0;
 }
 
 static void __exit ftrace_direct_exit(void)
-- 
2.53.0



