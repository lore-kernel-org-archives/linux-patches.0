Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8939124C664;
	Wed,  4 Jun 2025 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749037787; cv=none; b=OH3Tf1pf4aA54Uam7AAimsJM1mqENO5eEvE2D/qmdQ+gqxSBGLB8n4Xxsmy/by7TVwDqSmDMa3XeshLMKtyVsdGuuxo1gtA1ngnr9ss2ag4IqrlE+hsk9wu4IKYOEB7spZDJntk0gGWfTWdakQJImxmjdPn5XX5xQTiN3QtQGkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749037787; c=relaxed/simple;
	bh=isGxqCNue62srG1Hrb/sHpyePM7ya+J4KpoZi932Rl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EASEgqhTaKj8N+dlLwzKzPfZSp80f3b8r1vr8HwqwYdWF7wZZKPAEWmNVC5yDlEEbI2UpfZoEzy80EV6gmrt7go9GB5H3MqFcWbrzl44luWiZsFQO46RUwZmExbE/7B7LRmscnKOzWpiUD+xu0HY3ahjdR0a2tzrftOP4InxUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4dpJiro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4dpJiro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1262C4CEE7;
	Wed,  4 Jun 2025 11:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749037787;
	bh=isGxqCNue62srG1Hrb/sHpyePM7ya+J4KpoZi932Rl8=;
	h=From:To:Cc:Subject:Date:From;
	b=K4dpJiro7TMHvGIiyo0TQseug3OdybLGkLcK/Ui37ylfVBBU6iEeTJFiHQ5/WYGh1
	 hqyJ46rAsZ1hrup8TgANnF9xqyIOtLw+ti6UbAZRqetgs5uw10M9GlTRnhOB2U8J5L
	 lXJqRdC15cr7BaNMZj9ye6QippGmsy1IzS05DgJ+yMQJbMBh45bZW/Xb/fEtQPIdAk
	 lbe7qqdubSJdHtTQh3S6MgVpJKAZPCK9RHV4r7V55d/Co/jfjEdHIA3vvtGzsooo6h
	 A5ad3K36AWMGi0GCyJ9vLUmipW5i+OqVCQ2VlqsQctIX987fpg9HWbIr8MmWETIFmR
	 u7pU4H8gqGHVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	syzbot+a7d4444e7b6e743572f7@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	simona@ffwll.ch,
	qianqiang.liu@163.com,
	jfalempe@redhat.com,
	tzimmermann@suse.de,
	soci@c64.rulez.org,
	oushixiong@kylinos.cn
Subject: [PATCH AUTOSEL 6.14 1/8] fbcon: Make sure modelist not set on unregistered console
Date: Wed,  4 Jun 2025 07:49:36 -0400
Message-Id: <20250604114944.208828-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit cedc1b63394a866bf8663a3e40f4546f1d28c8d8 ]

It looks like attempting to write to the "store_modes" sysfs node will
run afoul of unregistered consoles:

UBSAN: array-index-out-of-bounds in drivers/video/fbdev/core/fbcon.c:122:28
index -1 is out of range for type 'fb_info *[32]'
...
 fbcon_info_from_console+0x192/0x1a0 drivers/video/fbdev/core/fbcon.c:122
 fbcon_new_modelist+0xbf/0x2d0 drivers/video/fbdev/core/fbcon.c:3048
 fb_new_modelist+0x328/0x440 drivers/video/fbdev/core/fbmem.c:673
 store_modes+0x1c9/0x3e0 drivers/video/fbdev/core/fbsysfs.c:113
 dev_attr_store+0x55/0x80 drivers/base/core.c:2439

static struct fb_info *fbcon_registered_fb[FB_MAX];
...
static signed char con2fb_map[MAX_NR_CONSOLES];
...
static struct fb_info *fbcon_info_from_console(int console)
...
        return fbcon_registered_fb[con2fb_map[console]];

If con2fb_map contains a -1 things go wrong here. Instead, return NULL,
as callers of fbcon_info_from_console() are trying to compare against
existing "info" pointers, so error handling should kick in correctly.

Reported-by: syzbot+a7d4444e7b6e743572f7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/679d0a8f.050a0220.163cdc.000c.GAE@google.com/
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my analysis: ## Security and Stability Issue This commit fixes a
critical **array-index-out-of-bounds vulnerability** that can be
triggered via sysfs. The issue occurs when `con2fb_map[console]`
contains `-1`, causing `fbcon_info_from_console()` to access
`fbcon_registered_fb[-1]`, which is an out-of-bounds array access. ##
Bug Analysis The problem is in the `fbcon_info_from_console()` function
at line 122: ```c // Before fix: return
fbcon_registered_fb[con2fb_map[console]]; // After fix: fb =
con2fb_map[console]; if (fb < 0 || fb >=
ARRAY_SIZE(fbcon_registered_fb)) return NULL; return
fbcon_registered_fb[fb]; ``` ## Trigger Path The vulnerability can be
triggered through: 1. **sysfs interface**: Writing to
`/sys/class/graphics/fbX/modes` 2. **Call chain**: `store_modes()` →
`fb_new_modelist()` → `fbcon_new_modelist()` →
`fbcon_info_from_console()` 3. **User-accessible**: This is exploitable
from userspace through the sysfs interface ## Code Context from Analysis
Based on the git blame, the vulnerable code path in
`fbcon_new_modelist()` has existed since: - Original code from **2005**
(Linus Torvalds) - The problematic `fbcon_info_from_console()` call was
added in **2022** by commit `409d6c95f9c6` ("fbcon: Introduce wrapper
for console->fb_info lookup") ## Risk Assessment 1. **High Impact**:
UBSAN array bounds violation, potential for memory corruption 2. **User
Triggerable**: Accessible via standard sysfs interface 3. **Long-
standing**: The vulnerable pattern has existed since 2022 when the
wrapper was introduced 4. **Active Exploitation**: Reported by syzbot,
indicating active fuzzing found this issue ## Backport Suitability 1.
**Small & Contained**: Only 6 lines changed in a single function 2.
**Safe Fix**: Adds bounds checking without changing logic flow 3. **No
Dependencies**: The fix is self-contained and doesn't require other
commits 4. **Clear Bug**: Definitively fixes out-of-bounds access with
proper NULL return 5. **Stable Pattern**: Callers already handle NULL
returns from `fbcon_info_from_console()` ## Comparison to Historical
Precedent Looking at the similar commits provided: - **Similar Commit
#1** (Backport Status: YES): Fixed boundary checks in fbcon parameter
parsing - this follows the same pattern of fixing bounds issues in fbcon
- The other NO commits were architectural changes or refactoring, not
security fixes This commit perfectly fits the stable tree criteria: it's
an important bugfix, has minimal regression risk, is contained to a
single subsystem, and fixes a user-triggerable vulnerability.

 drivers/video/fbdev/core/fbcon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 07d127110ca4c..c98786996c647 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -117,9 +117,14 @@ static signed char con2fb_map_boot[MAX_NR_CONSOLES];
 
 static struct fb_info *fbcon_info_from_console(int console)
 {
+	signed char fb;
 	WARN_CONSOLE_UNLOCKED();
 
-	return fbcon_registered_fb[con2fb_map[console]];
+	fb = con2fb_map[console];
+	if (fb < 0 || fb >= ARRAY_SIZE(fbcon_registered_fb))
+		return NULL;
+
+	return fbcon_registered_fb[fb];
 }
 
 static int logo_lines;
-- 
2.39.5

