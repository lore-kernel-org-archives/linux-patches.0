Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DEF1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A722DC433EF;
	Wed, 28 Dec 2022 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245943;
	bh=GfROr8HR6qZP6TAhiHR0HybOQfzTNxipuRy8eXjgMtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVHRqYy1rPM4hjbUujwmPZREENHkYZat6J8a6EUpbQPpGSQ5OKi54jg+QQpxtah0R
	 oJSYIJF1ycnq3xDz6w7Z9XUuwYIhQsuteTUZPjZNkyj6r8E6oqcTuITVewCRPnDIW+
	 YTnSK6nmfUmRyWw7qJDUDYFUynaGro3nfhOhwcD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0984/1073] scsi: elx: libefc: Fix second parameter type in state callbacks
Date: Wed, 28 Dec 2022 15:42:52 +0100
Message-Id: <20221228144354.815853215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 3d75e766b58a7410d4e835c534e1b4664a8f62d0 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function pointer
prototype to make sure the call target is valid to help mitigate ROP
attacks. If they are not identical, there is a failure at run time, which
manifests as either a kernel panic or thread getting killed. A proposed
warning in clang aims to catch these at compile time, which reveals:

  drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  ctx->current_state = state;
                                    ^ ~~~~~
  drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          node->nodedb_state = state;
                            ^ ~~~~~
  drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' from 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
                  pf = node->nodedb_state;
                    ^ ~~~~~~~~~~~~~~~~~~

  drivers/scsi/elx/libefc/efc_device.c:455:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  node->nodedb_state = __efc_d_init;
                                    ^ ~~~~~~~~~~~~

  drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  ctx->current_state = state;
                                    ^ ~~~~~

The type of the second parameter in the prototypes of ->current_state() and
->nodedb_state() ('u32') does not match the implementations, which have a
second parameter type of 'enum efc_sm_event'. Update the prototypes to have
the correct second parameter type, clearing up all the warnings and CFI
failures.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221102161906.2781508-1-nathan@kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efclib.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
index dde20891c2dd..57e338612812 100644
--- a/drivers/scsi/elx/libefc/efclib.h
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -58,10 +58,12 @@ enum efc_node_send_ls_acc {
 #define EFC_LINK_STATUS_UP		0
 #define EFC_LINK_STATUS_DOWN		1
 
+enum efc_sm_event;
+
 /* State machine context header  */
 struct efc_sm_ctx {
 	void (*current_state)(struct efc_sm_ctx *ctx,
-			      u32 evt, void *arg);
+			      enum efc_sm_event evt, void *arg);
 
 	const char	*description;
 	void		*app;
@@ -365,7 +367,7 @@ struct efc_node {
 	int			prev_evt;
 
 	void (*nodedb_state)(struct efc_sm_ctx *ctx,
-			     u32 evt, void *arg);
+			     enum efc_sm_event evt, void *arg);
 	struct timer_list	gidpt_delay_timer;
 	u64			time_last_gidpt_msec;
 
-- 
2.35.1



