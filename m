Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1AD350D54;
	Tue, 26 Aug 2025 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216184; cv=none; b=W31Sx3C+yH8WFZSKkOmksiAMBX3DRBjX6SRt6PVKs0/o40z1OdKLQx95bi6Mvj6aJ9DrqbbWoIssokwnGxAQS+CG2Pi0/3QTmWTgbkP7U6W89+R7xwwT3e9C4SKKaVfhWJdqCywgYHgtrerQnnUDeASpV21qd0x/UpdICWYBd9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216184; c=relaxed/simple;
	bh=amtt516RVWu/g6B1nQQrvvNSDr1e20aeTsUWgwUywsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCAGGib+j2hKTA8E9iRRGjPtrr10kgb1/0NlWVDeD6b+cAcFhO8SCPF5Q0a7zJVdqPmb6evWaTml1954DWOqMGqdljf5k0m7HhF/MtGYWCv5C3MQkjjUqjwTyLJ+N8epDSkYnt4NEPZuHR8z2F08ZQvv1qQHCkvJkMRj2rkLfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyXhVnc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyXhVnc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E27AC4CEF1;
	Tue, 26 Aug 2025 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216184;
	bh=amtt516RVWu/g6B1nQQrvvNSDr1e20aeTsUWgwUywsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyXhVnc1YpSLKVHYEvZaTryU0lDsCRT5Jz736fAg8Lkz5Dh7ET9n+oHhfb/odjQO4
	 CnAy1Cql00K3WOAO8wDBj1f45eDJGiWrwFozzfRJPtp02bT034PA1YgvKLm0l5Uxa/
	 z5F9YXDPQyFHyiGtpptQaDVDIOCiNtJQjubK4rL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tuhaowen <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/644] PM: sleep: console: Fix the black screen issue
Date: Tue, 26 Aug 2025 13:06:47 +0200
Message-ID: <20250826110954.217001847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



