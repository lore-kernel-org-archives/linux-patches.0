Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9436FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD2AC433EF;
	Mon, 16 Jan 2023 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889090;
	bh=bSa5CxUacWm9ZAF7X8/Vd7f9wXON7cZ4FUUwnIl9hrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKM9EyibCjp0mBy69aagfnd2FUMRXkTVIroGCQycXyKaIKA15M62saJjdQQM6d2Pb
	 VuORZj/vrTT/Hmk432TvB7e/8c6AZI5S4+2AI7QMCu7EzmSrlMKHgKb4IjTUOeZX/V
	 V2pyoC786P9WU4qFW2psz2yvYcdZk+rh6vlLf+tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wvw@google.com>,
	Midas Chien <midaschieh@google.com>,
	Connor OBrien <connoro@google.com>,
	Kees Cook <keescook@chromium.org>,
	Anton Vorontsov <anton@enomsg.org>,
	Colin Cross <ccross@android.com>,
	Tony Luck <tony.luck@intel.com>,
	kernel test robot <lkp@intel.com>,
	kernel-team@android.com,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 255/338] pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES
Date: Mon, 16 Jan 2023 16:52:08 +0100
Message-Id: <20230116154832.188869905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Stultz <jstultz@google.com>

[ Upstream commit 2f4fec5943407318b9523f01ce1f5d668c028332 ]

In commit 76d62f24db07 ("pstore: Switch pmsg_lock to an rt_mutex
to avoid priority inversion") I changed a lock to an rt_mutex.

However, its possible that CONFIG_RT_MUTEXES is not enabled,
which then results in a build failure, as the 0day bot detected:
  https://lore.kernel.org/linux-mm/202212211244.TwzWZD3H-lkp@intel.com/

Thus this patch changes CONFIG_PSTORE_PMSG to select
CONFIG_RT_MUTEXES, which ensures the build will not fail.

Cc: Wei Wang <wvw@google.com>
Cc: Midas Chien<midaschieh@google.com>
Cc: Connor O'Brien <connoro@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: kernel-team@android.com
Fixes: 76d62f24db07 ("pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221221051855.15761-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index b42e5bd6d8ff..144e5027fe84 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -51,6 +51,7 @@ config PSTORE_CONSOLE
 config PSTORE_PMSG
 	bool "Log user space messages"
 	depends on PSTORE
+	select RT_MUTEXES
 	help
 	  When the option is enabled, pstore will export a character
 	  interface /dev/pmsg0 to log user space messages. On reboot
-- 
2.35.1



