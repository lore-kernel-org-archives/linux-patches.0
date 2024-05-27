Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1212117E90E;
	Mon, 27 May 2024 19:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837020; cv=none; b=lnzyspOxgJ2FGNRDLQUNk5pOZ6wvhbviyffe+eLTnCxlNaC+gbwpaNa/vlUwKykp/oOncsd/lEvnwxApfGlXNXWYruiL5rpSD6EA0GloujhkmImuPdmtTgMiUnV87HhDw31kllQEsrvd51aLyNTrDLyYW2Koj5RtZryoqMJyTxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837020; c=relaxed/simple;
	bh=3UIjb+IlpN6K4dFG4ReUmlhwu77u3YBEdXpSVMAtfvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhtUZZ6O+qRtvhJ3ZsiyNJIQZJKECLJ3LLO45jrEAeCmWsZ5fGP3E1wnhRHtofpgqsvT5EYfA59mkyAYZb7pF6aCvqX6R2mTcq+U7bkXa/0GQaEjxhfTDm/U5SJ6WByWOsp2cgX6u+VSh7QYurebOhLYBXFrc/AxwZFVRWglWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbvEBow4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbvEBow4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB63C2BBFC;
	Mon, 27 May 2024 19:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837020;
	bh=3UIjb+IlpN6K4dFG4ReUmlhwu77u3YBEdXpSVMAtfvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbvEBow4Ld0HiYGKtVeAnkxA9+qsT1RT1nt6+PH61stzPRLrfQnHpFvc/DdYi85w4
	 psxJdlF/XCmcay8BVFsgws7FQwnFf3JwCmwr6Iihb8QEWb9nUs8Tan5AGfEZsCIJiu
	 yDO0P3s4LTEruD00cQNvAvrSfWsoeYCHs4lXiEP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Xiubo Li <xiubli@redhat.com>,
	Chris Down <chris@chrisdown.name>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 280/427] printk: Let no_printk() use _printk()
Date: Mon, 27 May 2024 20:55:27 +0200
Message-ID: <20240527185628.684545882@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8522f6b760ca588928eede740d5d69dd1e936b49 ]

When printk-indexing is enabled, each printk() invocation emits a
pi_entry structure, containing the format string and other information
related to its location in the kernel sources.  This is even true for
no_printk(): while the actual code to print the message is optimized out
by the compiler due to the always-false check, the pi_entry structure is
still emitted.

As the main purpose of no_printk() is to provide a helper to maintain
printf()-style format checking when debugging is disabled, this leads to
the inclusion in the index of lots of printk formats that cannot be
emitted by the current kernel.

Fix this by switching no_printk() from printk() to _printk().

This reduces the size of an arm64 defconfig kernel with
CONFIG_PRINTK_INDEX=y by 576 KiB.

Fixes: 337015573718b161 ("printk: Userspace format indexing support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/56cf92edccffea970e1f40a075334dd6cf5bb2a4.1709127473.git.geert+renesas@glider.be
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 955e31860095e..2fde40cc96778 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -126,7 +126,7 @@ struct va_format {
 #define no_printk(fmt, ...)				\
 ({							\
 	if (0)						\
-		printk(fmt, ##__VA_ARGS__);		\
+		_printk(fmt, ##__VA_ARGS__);		\
 	0;						\
 })
 
-- 
2.43.0



