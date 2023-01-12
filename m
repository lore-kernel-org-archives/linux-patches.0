Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954879CE
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CC5C433F1;
	Thu, 12 Jan 2023 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533673;
	bh=TOmRZ6aZZrQ4hhnqJ+8SwiNIcgCrwrXQSE73dc0VpCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrikRMLqyrH1sDb+QUu2DqasWZYGVPKKYT2szF73+ZClzO0+ouaPITJy679JKqFHL
	 UBlf6qzQdaqTcob07NWen4Ggtv4JEkxPLX41C5HXzQAoNaR3dGeyDIGYMNbW1roj3i
	 VoOaEpuBcEW/+e6Namma+IMCmSTfxGrQsNMXlsAs=
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
Subject: [PATCH 5.10 554/783] pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES
Date: Thu, 12 Jan 2023 14:54:30 +0100
Message-Id: <20230112135549.904718389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 8efe60487b48..71dbe9a2533f 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -118,6 +118,7 @@ config PSTORE_CONSOLE
 config PSTORE_PMSG
 	bool "Log user space messages"
 	depends on PSTORE
+	select RT_MUTEXES
 	help
 	  When the option is enabled, pstore will export a character
 	  interface /dev/pmsg0 to log user space messages. On reboot
-- 
2.35.1



