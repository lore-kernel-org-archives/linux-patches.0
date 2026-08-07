Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EAC38F626;
	Fri,  7 Aug 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113804; cv=none; b=pHWg3QDA9F2bifjpbOg4tGUQ/FF0e83MSdxA2jSzIlxeeeh69ligcitVVxzEbe2wNvnM4JKP8LpIOkBy/lJrpXGDdild7BEhwOjjMAtnablJL0Wj9hBXLISUANhX+mz0sD5OsZ/sPYVuqgrk+ZGqjVHXPuyZ8GXSRweII7CQJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113804; c=relaxed/simple;
	bh=1oFTqKUDaBnTjDYeLVWD0VxsgdObeq5QvdgxTfakQ8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr9+RfBQFGqy/mt5XzJsq6bmqYm/TC0XvmXd78+L88ngqMWuugxIttKb10x8W35hJk8XFpGYl4ljkQNfe5e4Hw26GWwz6mYMtYUzJiTG4YQ7Y0qYZ/3b750VJqoGOqK5aFlNovdwiyUz6nRuEp8OabpVLgNu07l1kRGsE8QcnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkpEN8ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkpEN8ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4741F00ACF;
	Fri,  7 Aug 2026 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113782;
	bh=PwXVfWgDFrrZ7dgyDXGY+uY74TEn7tOaMNJuD5Ut0CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkpEN8ni2c5ymBtRxlQGEN7a1iew9nj5P+bGBOHlYuSGHlx7PocQWK5L0FNfQ2xrg
	 e+sxkbTtqYGKyNln40AcxNr0QdTBSk8/KT/wl/vAHdY76/ZEVsOitAGj6/5Iq48ULI
	 3kH8T3s5SfJqGN6n/uvMhgBQeuGHfbsIQwk6QzGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/337] um: Preserve errno within signal handler
Date: Fri,  7 Aug 2026 16:33:33 +0200
Message-ID: <20260807143418.745439178@linuxfoundation.org>
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

commit f68b2d5a907b53eed99cf2efcaaae116df73c298 upstream.

We rely on errno to determine whether a syscall has failed, so we
need to ensure that accessing errno is async-signal-safe. Currently,
we preserve the errno in sig_handler_common(), but it doesn't cover
every possible case. Let's do it in hard_handler() instead, which
is the signal handler we actually register.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20260106001228.1531146-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[florian: hard_handler() in 6.12 retains the to_irq_stack/from_irq_stack
loop from before the upstream SMP refactoring; errno save/restore is wrapped
around that loop rather than replacing sig_handler_common's existing save/restore]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/signal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index b11ed66c8bb0..94abc9e3ec7e 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -190,6 +190,7 @@ static void hard_handler(int sig, siginfo_t *si, void *p)
 {
 	ucontext_t *uc = p;
 	mcontext_t *mc = &uc->uc_mcontext;
+	int save_errno = errno;
 	unsigned long pending = 1UL << sig;
 
 	do {
@@ -227,6 +228,8 @@ static void hard_handler(int sig, siginfo_t *si, void *p)
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
+
+	errno = save_errno;
 }
 
 void set_handler(int sig)
-- 
2.53.0



