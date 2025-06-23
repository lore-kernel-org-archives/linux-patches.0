Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C720616D9BF;
	Mon, 23 Jun 2025 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717160; cv=none; b=qbwqGwp+07IbbMeM0PA3g/UG8HdbaYMdBG5Ugjhyx1bRmsBtZm3mqcx20QC7XeGLxdo4rfwQYOQw0cYN0vTscN0ZJuNI/kQXFtrnHgzrL0Mn2FsQvVJsPItvvUe3UoiXvBQVCRZNmA510PvV6lra1OLy7aBf2QaCf4WksLAyioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717160; c=relaxed/simple;
	bh=C1sXbatwffC38qBgbMRmhjGwJ8t6ozE0oCvKQDDCGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HXQTmheSpJIg1KrXuGZQitrAJoX7othgDPWmsdB962mp6MhrBASu+IkHSaU/L9ACxI9fKtHOB/d8FQSgIUSE779q0x5rYIQu+dz7uOIG668DRHbqLygckuVoztKdcUHamLexGQuZj2i72y/26KnQVlloy8DnesxDxqMrOSWBmvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb7M7L6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb7M7L6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E08DC4CEEA;
	Mon, 23 Jun 2025 22:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717160;
	bh=C1sXbatwffC38qBgbMRmhjGwJ8t6ozE0oCvKQDDCGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb7M7L6+Dc+qPMfPeMGIE1wfE6w+lvysz97iH9aKTmLSPcAWUR7hw3lyzWwqpud9T
	 zaUuHwxtW2Sdu5+k5wLw04QnH8jkuaAiFTvBSPPz+iiUY5Of2/reptDqTMyLY9nJEV
	 zcBErIRTlh26pgFtLoNQj1zGubKyoF6TNi8w7R5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Yan <felixonmars@archlinux.org>,
	Eric Long <i@hack3r.moe>,
	Jianfei Zhang <zhangjianfei3@gmail.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	Minh Le <minhld139@gmail.com>,
	Sicheng Zhu <Emmet_Z@outlook.com>,
	Rong Zhang <i@rong.moe>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 320/414] platform/x86: ideapad-laptop: use usleep_range() for EC polling
Date: Mon, 23 Jun 2025 15:07:37 +0200
Message-ID: <20250623130649.996268172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit 5808c34216954cd832bd4b8bc52dfa287049122b upstream.

It was reported that ideapad-laptop sometimes causes some recent (since
2024) Lenovo ThinkBook models shut down when:
 - suspending/resuming
 - closing/opening the lid
 - (dis)connecting a charger
 - reading/writing some sysfs properties, e.g., fan_mode, touchpad
 - pressing down some Fn keys, e.g., Brightness Up/Down (Fn+F5/F6)
 - (seldom) loading the kmod

The issue has existed since the launch day of such models, and there
have been some out-of-tree workarounds (see Link:) for the issue. One
disables some functionalities, while another one simply shortens
IDEAPAD_EC_TIMEOUT. The disabled functionalities have read_ec_data() in
their call chains, which calls schedule() between each poll.

It turns out that these models suffer from the indeterminacy of
schedule() because of their low tolerance for being polled too
frequently. Sometimes schedule() returns too soon due to the lack of
ready tasks, causing the margin between two polls to be too short.
In this case, the command is somehow aborted, and too many subsequent
polls (they poll for "nothing!") may eventually break the state machine
in the EC, resulting in a hard shutdown. This explains why shortening
IDEAPAD_EC_TIMEOUT works around the issue - it reduces the total number
of polls sent to the EC.

Even when it doesn't lead to a shutdown, frequent polls may also disturb
the ongoing operation and notably delay (+ 10-20ms) the availability of
EC response. This phenomenon is unlikely to be exclusive to the models
mentioned above, so dropping the schedule() manner should also slightly
improve the responsiveness of various models.

Fix these issues by migrating to usleep_range(150, 300). The interval is
chosen to add some margin to the minimal 50us and considering EC
responses are usually available after 150-2500us based on my test. It
should be enough to fix these issues on all models subject to the EC bug
without introducing latency on other models.

Tested on ThinkBook 14 G7+ ASP and solved both issues. No regression was
introduced in the test on a model without the EC bug (ThinkBook X IMH,
thanks Eric).

Link: https://github.com/ty2/ideapad-laptop-tb2024g6plus/commit/6c5db18c9e8109873c2c90a7d2d7f552148f7ad4
Link: https://github.com/ferstar/ideapad-laptop-tb/commit/42d1e68e5009529d31bd23f978f636f79c023e80
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218771
Fixes: 6a09f21dd1e2 ("ideapad: add ACPI helpers")
Cc: stable@vger.kernel.org
Tested-by: Felix Yan <felixonmars@archlinux.org>
Tested-by: Eric Long <i@hack3r.moe>
Tested-by: Jianfei Zhang <zhangjianfei3@gmail.com>
Tested-by: Mingcong Bai <jeffbai@aosc.io>
Tested-by: Minh Le <minhld139@gmail.com>
Tested-by: Sicheng Zhu <Emmet_Z@outlook.com>
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://lore.kernel.org/r/20250525201833.37939-1-i@rong.moe
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -15,6 +15,7 @@
 #include <linux/bug.h>
 #include <linux/cleanup.h>
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dmi.h>
 #include <linux/i8042.h>
@@ -267,6 +268,20 @@ static void ideapad_shared_exit(struct i
  */
 #define IDEAPAD_EC_TIMEOUT 200 /* in ms */
 
+/*
+ * Some models (e.g., ThinkBook since 2024) have a low tolerance for being
+ * polled too frequently. Doing so may break the state machine in the EC,
+ * resulting in a hard shutdown.
+ *
+ * It is also observed that frequent polls may disturb the ongoing operation
+ * and notably delay the availability of EC response.
+ *
+ * These values are used as the delay before the first poll and the interval
+ * between subsequent polls to solve the above issues.
+ */
+#define IDEAPAD_EC_POLL_MIN_US 150
+#define IDEAPAD_EC_POLL_MAX_US 300
+
 static int eval_int(acpi_handle handle, const char *name, unsigned long *res)
 {
 	unsigned long long result;
@@ -383,7 +398,7 @@ static int read_ec_data(acpi_handle hand
 	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
 
 	while (time_before(jiffies, end_jiffies)) {
-		schedule();
+		usleep_range(IDEAPAD_EC_POLL_MIN_US, IDEAPAD_EC_POLL_MAX_US);
 
 		err = eval_vpcr(handle, 1, &val);
 		if (err)
@@ -414,7 +429,7 @@ static int write_ec_cmd(acpi_handle hand
 	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
 
 	while (time_before(jiffies, end_jiffies)) {
-		schedule();
+		usleep_range(IDEAPAD_EC_POLL_MIN_US, IDEAPAD_EC_POLL_MAX_US);
 
 		err = eval_vpcr(handle, 1, &val);
 		if (err)


