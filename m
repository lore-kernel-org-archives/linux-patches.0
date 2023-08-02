Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC33DF58;
	Wed,  2 Aug 2023 17:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21C5C433C7;
	Wed,  2 Aug 2023 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690998039;
	bh=4hVTE+i9pfxMJ2F33rRe90JktNk2rYBpP+Ie4qp/6l4=;
	h=From:Date:Subject:To:Cc:From;
	b=HPfWdXroeHcDcrpC5fkZfN4KTlRSZs9yzMI/sMX97S+GCtokJz7LftdBXVv+oHbcl
	 uAU2H52CnhuYzec7rTBmcNFd+AT5Gw+12zgO6onJ2Jslf62kpseuKKntvM9i9AWIbp
	 NXblaM82SWFBPeafHA+mtWaJagY1VAWap+4KLynWH6UnElnzXDz84MiOF4F93vmU9z
	 Lsv4Z01gg34jUHlht1NL5EnIq9iQ/lWlw1EQucXGaJKq8TYB6lUFabrxJjRN53EGeP
	 OnfW36l2J8xfxJ2DHm3SkrXI4x3U9fgtV8wyaIfr9SGATj49Qli6IIHROf0+sbS0qK
	 5PaMEOpohlDJw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 02 Aug 2023 10:40:29 -0700
Subject: [PATCH] mISDN: Update parameter type of dsp_cmx_send()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAyVymQC/x3MQQqEMAxA0atI1gZqFBGvIiK1TTWgVRpmEMS7W
 1w++PwblJOwQl/ckPgvKkfMqMoC3Grjwig+G8hQbTpDGORCr+fk9mtSjh5dEAxWtl9iJN8Y6ub
 K2baGvDgT5/7bD+PzvI+Wm7luAAAA
To: isdn@linux-pingi.de, netdev@vger.kernel.org
Cc: keescook@chromium.org, samitolvanen@google.com, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3446; i=nathan@kernel.org;
 h=from:subject:message-id; bh=4hVTE+i9pfxMJ2F33rRe90JktNk2rYBpP+Ie4qp/6l4=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCmnpord7Q27f92HKWzldR65BfcMn4lFJczqeB4Zxz7bb
 LONZ3B8RykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIzNOMDI030o6+6T63bsfV
 Nfn57TtWrdZXzl3atCNZqnPXwsTjEhsZGTbWXQ4+tZznD7uP3sJjiVVPVnvnhhov2inzNNXa4+r
 NQ8wA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

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
---
I am not sure if there is an appropriate fixes tag for this, I see this
area was modified by commit e313ac12eb13 ("mISDN: Convert timers to use
timer_setup()") but I don't think it was the original source of the
issue. It could also be commit cf68fffb66d6 ("add support for Clang
CFI") but I think that just exposes the problem/makes it fatal.

Also not sure who should take this or how soon it should go in, I'll let
that to maintainers to figure out :)
---
 drivers/isdn/mISDN/dsp.h      | 2 +-
 drivers/isdn/mISDN/dsp_cmx.c  | 2 +-
 drivers/isdn/mISDN/dsp_core.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp.h b/drivers/isdn/mISDN/dsp.h
index fa09d511a8ed..baf31258f5c9 100644
--- a/drivers/isdn/mISDN/dsp.h
+++ b/drivers/isdn/mISDN/dsp.h
@@ -247,7 +247,7 @@ extern void dsp_cmx_hardware(struct dsp_conf *conf, struct dsp *dsp);
 extern int dsp_cmx_conf(struct dsp *dsp, u32 conf_id);
 extern void dsp_cmx_receive(struct dsp *dsp, struct sk_buff *skb);
 extern void dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb);
-extern void dsp_cmx_send(void *arg);
+extern void dsp_cmx_send(struct timer_list *arg);
 extern void dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb);
 extern int dsp_cmx_del_conf_member(struct dsp *dsp);
 extern int dsp_cmx_del_conf(struct dsp_conf *conf);
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 357b87592eb4..61cb45c5d0d8 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1614,7 +1614,7 @@ static u16	dsp_count; /* last sample count */
 static int	dsp_count_valid; /* if we have last sample count */
 
 void
-dsp_cmx_send(void *arg)
+dsp_cmx_send(struct timer_list *arg)
 {
 	struct dsp_conf *conf;
 	struct dsp_conf_member *member;
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 386084530c2f..fae95f166688 100644
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

---
base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
change-id: 20230802-fix-dsp_cmx_send-cfi-failure-2d4028b1ca63

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

