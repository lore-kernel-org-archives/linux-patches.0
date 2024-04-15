Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6067A74BE1;
	Mon, 15 Apr 2024 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191453; cv=none; b=p5UnK0HW0gOH3ny3On/kCP9bb4JC/3LKsn6Cs/dIH4XrSloyr5mQ5NrVVBXgEey30avOOAmziBwh+VYO5CYerRMQQAgUlQyQ1Wn6YxFkjm6UIZvXqJViqsdknwNEJ0buUy8i4D3kvgcmXvWSHquSTZKgq+82U2kuA70qASwOIzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191453; c=relaxed/simple;
	bh=9RH6s+BxpUE0earT1JsjyNGZCI3yKXkEvPa/sAxPIws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP+KHMLAYDVxowqPRjhB0XhxBetXoMqsCv7KaNJ2wIRinvZPP84a6Gl4Ei6vTjpalUhtw/oo25husuS+zA5gbkqDZ+hfTBQU5W5d2xx0bQDPRWueewJQybjzOnWhktC5m/XFd/ECEOPCCF3963ZfrW4X+SbrtERIlIVMMsJZ67I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNrL8A7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNrL8A7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962C9C113CC;
	Mon, 15 Apr 2024 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191453;
	bh=9RH6s+BxpUE0earT1JsjyNGZCI3yKXkEvPa/sAxPIws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNrL8A7nKIfzGlHAs4whrGy6o0tKcnufagY0u+nWapE0Cwlc5kwWLWXEvRIvVh6ZR
	 jf2k1R0aCVF1S0JhS8L2iC6NIsvNCLYhBFGsgWMvKWnThiLzr2pfEbSxlnQMGpduYx
	 a/IzpLDpmQtKSZVSBrPd48DHs4GQ66r5Ndr9pNUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.8 148/172] irqflags: Explicitly ignore lockdep_hrtimer_exit() argument
Date: Mon, 15 Apr 2024 16:20:47 +0200
Message-ID: <20240415142004.865913864@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c1d11fc2c8320871b40730991071dd0a0b405bc8 upstream.

When building with 'make W=1' but CONFIG_TRACE_IRQFLAGS=n, the
unused argument to lockdep_hrtimer_exit() causes a warning:

kernel/time/hrtimer.c:1655:14: error: variable 'expires_in_hardirq' set but not used [-Werror=unused-but-set-variable]

This is intentional behavior, so add a cast to void to shut up the warning.

Fixes: 73d20564e0dc ("hrtimer: Don't dereference the hrtimer pointer after the callback")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240408074609.3170807-1-arnd@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202311191229.55QXHVc6-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/irqflags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -114,7 +114,7 @@ do {						\
 # define lockdep_softirq_enter()		do { } while (0)
 # define lockdep_softirq_exit()			do { } while (0)
 # define lockdep_hrtimer_enter(__hrtimer)	false
-# define lockdep_hrtimer_exit(__context)	do { } while (0)
+# define lockdep_hrtimer_exit(__context)	do { (void)(__context); } while (0)
 # define lockdep_posixtimer_enter()		do { } while (0)
 # define lockdep_posixtimer_exit()		do { } while (0)
 # define lockdep_irq_work_enter(__work)		do { } while (0)


