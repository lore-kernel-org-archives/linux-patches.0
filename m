Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D277034DCF6;
	Tue, 26 Aug 2025 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217771; cv=none; b=V08yIHrh4I/ruXh7Fw4UYB7JnJsvCK+ipc+Iq443zsQUkbWjnMG5ws3AYXKB0xr+bYJc+WtDbwKw4C6OgPin74uSbh1IuavwzM+tiluK3gWqQyCcULcXH5nN/U3g5KyhiODopNJYaAJLKmLyTeVlTpLjZa8Om2BwL2DNHf3mZrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217771; c=relaxed/simple;
	bh=N3rYMGbZJgaQRJiy9Ur1ogL9RrzEdCmypuX7QGsXaHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPZz+SMdEQfaJDspc1lAI23zKOoPa2ks0TubcYJhXkElPwk13nnSDwhmwmvJvt5PoYXjn3NqGPMJkUF5sc9pgGXKCE8wtiPhFCVCexgOTnGxNqpI2XTT7pYd+jWhAzBpIY8ZBx3i3aklNEXswrPrlKeNkSzRgjDS9TsGehBr7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opNaptlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opNaptlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66036C4CEF1;
	Tue, 26 Aug 2025 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217771;
	bh=N3rYMGbZJgaQRJiy9Ur1ogL9RrzEdCmypuX7QGsXaHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opNaptluJ2nVZsLhF1LsQrGD2T6k3uRHSHZJFkrRRnOWkBLL92aCdDt/iUCvTJ0Js
	 diNQRGsV+RXeiQXET+ot0zvpqDuBKRZDnooBRDWi4wx3py1biBTK9tmOxslhvObXj1
	 pshX19oKP7g9fSUd81hIE/svlO0EIHE5J6khuB/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tuhaowen <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/523] PM: sleep: console: Fix the black screen issue
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826110930.315448011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



