Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A9C134AC;
	Mon, 12 Aug 2024 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480003; cv=none; b=A5gWLCMlGzasoZk3W7jxgDxp21Nozmcj1QXbwHlIUxwwaVZzosxYXOlyGuZvW3PnWJYXd+jxwuoza+2LBoJIJIqt8x7lquzHTS3GmPVoQhLp60Yv7Bf9RgKc3jxZV67UGBGmGhS02OL/wlwHwS02RtV5LN99/pOwC5rz/ubfsB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480003; c=relaxed/simple;
	bh=aovqduk0riAEEJmmc5hOZ1kX1i9klkgMJsKrEumcaBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uo9aV5AqEyW8G7IJphrvV5NAdAcGpknkTzZVt/e4ZgpDtIOilK1sWqhb8kC/d1OnmrfG/PjsJzV6x0zq6W6B3RJrWq6zJPAYA94ekV5owaPaRMvbOEA2QhlvvDMpP+C6Mhl883cbt1uTancwcttoVQd6Yowok/RWmEuHjKGDRcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD+ewOa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD+ewOa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3934C32782;
	Mon, 12 Aug 2024 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480003;
	bh=aovqduk0riAEEJmmc5hOZ1kX1i9klkgMJsKrEumcaBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MD+ewOa/kPrON9xRf5b2v/TCfa0fk4O/AnOUpS94jNFgtDuuNq0SWPFgIXsyxl4aJ
	 rn7ZtieU/NUpOl9esUUwpbn1TD8dbYPhcVntAV3AKF4KY6VXAkOVaZFG4OSi92YcyI
	 Gw/PqFU8VenUiy/VzPl1ueM3OLYn1Kg9BRZqtg60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 049/263] debugobjects: Annotate racy debug variables
Date: Mon, 12 Aug 2024 18:00:50 +0200
Message-ID: <20240812160148.421388548@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5b5baba6222255d29626f63c41f101379ec5400b ]

KCSAN has identified a potential data race in debugobjects, where the
global variable debug_objects_maxchain is accessed for both reading and
writing simultaneously in separate and parallel data paths. This results in
the following splat printed by KCSAN:

  BUG: KCSAN: data-race in debug_check_no_obj_freed / debug_object_activate

  write to 0xffffffff847ccfc8 of 4 bytes by task 734 on cpu 41:
  debug_object_activate (lib/debugobjects.c:199 lib/debugobjects.c:564 lib/debugobjects.c:710)
  call_rcu (kernel/rcu/rcu.h:227 kernel/rcu/tree.c:2719 kernel/rcu/tree.c:2838)
  security_inode_free (security/security.c:1626)
  __destroy_inode (./include/linux/fsnotify.h:222 fs/inode.c:287)
  ...
  read to 0xffffffff847ccfc8 of 4 bytes by task 384 on cpu 31:
  debug_check_no_obj_freed (lib/debugobjects.c:1000 lib/debugobjects.c:1019)
  kfree (mm/slub.c:2081 mm/slub.c:4280 mm/slub.c:4390)
  percpu_ref_exit (lib/percpu-refcount.c:147)
  css_free_rwork_fn (kernel/cgroup/cgroup.c:5357)
  ...
  value changed: 0x00000070 -> 0x00000071

The data race is actually harmless as this is just used for debugfs
statistics, as all other debug variables.

Annotate all debug variables as racy explicitly, since these variables
are known to be racy and harmless.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240611091813.1189860-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index fb12a9bacd2fa..7cea91e193a8f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -78,16 +78,17 @@ static bool			obj_freeing;
 /* The number of objs on the global free list */
 static int			obj_nr_tofree;
 
-static int			debug_objects_maxchain __read_mostly;
-static int __maybe_unused	debug_objects_maxchecked __read_mostly;
-static int			debug_objects_fixups __read_mostly;
-static int			debug_objects_warnings __read_mostly;
-static int			debug_objects_enabled __read_mostly
-				= CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT;
-static int			debug_objects_pool_size __read_mostly
-				= ODEBUG_POOL_SIZE;
-static int			debug_objects_pool_min_level __read_mostly
-				= ODEBUG_POOL_MIN_LEVEL;
+static int __data_racy			debug_objects_maxchain __read_mostly;
+static int __data_racy __maybe_unused	debug_objects_maxchecked __read_mostly;
+static int __data_racy			debug_objects_fixups __read_mostly;
+static int __data_racy			debug_objects_warnings __read_mostly;
+static int __data_racy			debug_objects_enabled __read_mostly
+					= CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT;
+static int __data_racy			debug_objects_pool_size __read_mostly
+					= ODEBUG_POOL_SIZE;
+static int __data_racy			debug_objects_pool_min_level __read_mostly
+					= ODEBUG_POOL_MIN_LEVEL;
+
 static const struct debug_obj_descr *descr_test  __read_mostly;
 static struct kmem_cache	*obj_cache __ro_after_init;
 
-- 
2.43.0



