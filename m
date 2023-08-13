Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868739446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BA5C433C8;
	Sun, 13 Aug 2023 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963082;
	bh=z1bi7sjIe+HcyufpBLtsmTUYkE6/ZIFOj1d7unzD9iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJgX0hoT6nbyaPLmBB7agHF2f3gsbTNqsvkxkPQwquKZbrpQ6qN4Uk9yTO8kzhni3
	 o9rY5ghpgm0P3uLVD9OTfIq0LuDQMV06l59J9nipi2bRWQJHQPur7GrVdnLOxfkXDi
	 fZHwRmOAkP/IZvTYpM5zM020lsa/2eB9vmpNnoJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 46/89] mISDN: Update parameter type of dsp_cmx_send()
Date: Sun, 13 Aug 2023 23:19:37 +0200
Message-ID: <20230813211712.171368590@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
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

commit 1696ec8654016dad3b1baf6c024303e584400453 upstream.

When booting a kernel with CONFIG_MISDN_DSP=y and CONFIG_CFI_CLANG=y,
there is a failure when dsp_cmx_send() is called indirectly from
call_timer_fn():

  [    0.371412] CFI failure at call_timer_fn+0x2f/0x150 (target: dsp_cmx_send+0x0/0x530; expected type: 0x92ada1e9)

The function pointer prototype that call_timer_fn() expects is

  void (*fn)(struct timer_list *)

whereas dsp_cmx_send() has a parameter type of 'void *', which causes
the control flow integrity checks to fail because the parameter types do
not match.

Change dsp_cmx_send()'s parameter type to be 'struct timer_list' to
match the expected prototype. The argument is unused anyways, so this
has no functional change, aside from avoiding the CFI failure.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202308020936.58787e6c-oliver.sang@intel.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: e313ac12eb13 ("mISDN: Convert timers to use timer_setup()")
Link: https://lore.kernel.org/r/20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/mISDN/dsp.h      |    2 +-
 drivers/isdn/mISDN/dsp_cmx.c  |    2 +-
 drivers/isdn/mISDN/dsp_core.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/isdn/mISDN/dsp.h
+++ b/drivers/isdn/mISDN/dsp.h
@@ -247,7 +247,7 @@ extern void dsp_cmx_hardware(struct dsp_
 extern int dsp_cmx_conf(struct dsp *dsp, u32 conf_id);
 extern void dsp_cmx_receive(struct dsp *dsp, struct sk_buff *skb);
 extern void dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb);
-extern void dsp_cmx_send(void *arg);
+extern void dsp_cmx_send(struct timer_list *arg);
 extern void dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb);
 extern int dsp_cmx_del_conf_member(struct dsp *dsp);
 extern int dsp_cmx_del_conf(struct dsp_conf *conf);
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1625,7 +1625,7 @@ static u16	dsp_count; /* last sample cou
 static int	dsp_count_valid; /* if we have last sample count */
 
 void
-dsp_cmx_send(void *arg)
+dsp_cmx_send(struct timer_list *arg)
 {
 	struct dsp_conf *conf;
 	struct dsp_conf_member *member;
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -1195,7 +1195,7 @@ static int __init dsp_init(void)
 	}
 
 	/* set sample timer */
-	timer_setup(&dsp_spl_tl, (void *)dsp_cmx_send, 0);
+	timer_setup(&dsp_spl_tl, dsp_cmx_send, 0);
 	dsp_spl_tl.expires = jiffies + dsp_tics;
 	dsp_spl_jiffies = dsp_spl_tl.expires;
 	add_timer(&dsp_spl_tl);


