Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A47335BA9;
	Mon, 18 Aug 2025 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525148; cv=none; b=DDCvnmdGJpIMSx9VMMflxIBCFnAdFpTnwmOpCJ9Pfm9AC7snW506lnq2gprfwyO7hPdlT9DYvSMbwcd3aLfc32sWE2WP9tITJAGpJFcvuYyv2JhKaG0GwTdwybZnylw6uIYAXIwk9N8NUzEDsJVK2KXpH25pTO+t15w4ePBd4EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525148; c=relaxed/simple;
	bh=r+uGZREiG8Qz/x8GdD4OBtCdK+1Eq3g9tT/xhyhGnl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmmwpZpqiHB44NHi+SijqOTHm3flJlga+f8fTLOgJQw4xFu5C6XCg7iiWMzW1CsMURzCDwC3raGKcTHwvtJdvIrNS8i0pc77+Sp97qmXy18XkP2HNU9iWfL8ucM61N+x4f+HcUW04HW3jJc3eDJVeMaEhNbHvbPhXVfdaoZc3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fgcMAOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fgcMAOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67F4C4CEEB;
	Mon, 18 Aug 2025 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525148;
	bh=r+uGZREiG8Qz/x8GdD4OBtCdK+1Eq3g9tT/xhyhGnl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fgcMAObU8KlyxoCg00Vu9YgbdlzzrVBF/tg995FUPHlA9Ae17P/rhWGPd+xItQQD
	 vu8U6z6IzTu1MaA5Vq+KeQQuYMyOlvSoGwaO8wxdf9FieyJr/6Ao+yiMsgWIlSRFtG
	 mHYY4i+foRRthyZFFiOhaZM0AXBb3DYHHeGP7xts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tuhaowen <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 166/570] PM: sleep: console: Fix the black screen issue
Date: Mon, 18 Aug 2025 14:42:33 +0200
Message-ID: <20250818124512.198608354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: tuhaowen <tuhaowen@uniontech.com>

[ Upstream commit 4266e8fa56d3d982bf451d382a410b9db432015c ]

When the computer enters sleep status without a monitor
connected, the system switches the console to the virtual
terminal tty63(SUSPEND_CONSOLE).

If a monitor is subsequently connected before waking up,
the system skips the required VT restoration process
during wake-up, leaving the console on tty63 instead of
switching back to tty1.

To fix this issue, a global flag vt_switch_done is introduced
to record whether the system has successfully switched to
the suspend console via vt_move_to_console() during suspend.

If the switch was completed, vt_switch_done is set to 1.
Later during resume, this flag is checked to ensure that
the original console is restored properly by calling
vt_move_to_console(orig_fgconsole, 0).

This prevents scenarios where the resume logic skips console
restoration due to incorrect detection of the console state,
especially when a monitor is reconnected before waking up.

Signed-off-by: tuhaowen <tuhaowen@uniontech.com>
Link: https://patch.msgid.link/20250611032345.29962-1-tuhaowen@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/console.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/power/console.c b/kernel/power/console.c
index fcdf0e14a47d..19c48aa5355d 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -16,6 +16,7 @@
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
+static bool vt_switch_done;
 
 static DEFINE_MUTEX(vt_switch_mutex);
 
@@ -136,17 +137,21 @@ void pm_prepare_console(void)
 	if (orig_fgconsole < 0)
 		return;
 
+	vt_switch_done = true;
+
 	orig_kmsg = vt_kmsg_redirect(SUSPEND_CONSOLE);
 	return;
 }
 
 void pm_restore_console(void)
 {
-	if (!pm_vt_switch())
+	if (!pm_vt_switch() && !vt_switch_done)
 		return;
 
 	if (orig_fgconsole >= 0) {
 		vt_move_to_console(orig_fgconsole, 0);
 		vt_kmsg_redirect(orig_kmsg);
 	}
+
+	vt_switch_done = false;
 }
-- 
2.39.5



