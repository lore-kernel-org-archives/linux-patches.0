Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B747F429CE0;
	Fri,  7 Aug 2026 14:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113783; cv=none; b=j17wXb0cMXYeEt3L9x6Y/eie135zgSaPBUYHdXiGIkIU1EVjHr+00xTMKOmbTde8ftd6HM9Kd2b3MAQP0nP4DHBij4KAjTLKMyx5D9B1F37kmQ+bRoGn/h8xrGJL75HixErnatbRutYiL1FzHarT6Z5AB1TtpyregEXca3o3Huw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113783; c=relaxed/simple;
	bh=LZK6hZNlk8IP8XLEjExIs4eQ8998oxH4BQUAcjSolhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpB053sihPLfSC3GT9JTxpGie5HSIHVnlG3EO06IbCSRtwDaSubEEg5xdEyMlWdkQUpuMw2dXa0mpCB9oPScYaYESLX7ni+i9n+UA9TrLKzGq2RtAQk+7jvGbqV2qIoRz7MwFlvPHFb7gtxCfLZ1f4IP+5KILf0YdTA8di1V6QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD1kVLTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD1kVLTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE201F01559;
	Fri,  7 Aug 2026 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113765;
	bh=A5gLHMdDLH+w41LSW5c+9wxbc+F1Uz5F+hzS0zOI+tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iD1kVLTrv7f+BOhhecmii+MR3rgFZOCH+0P45SxNQk5eCYtJSvbXZ0lOT7d8VFusF
	 bEYZvIGupRJCErzvPhhvpmLnyOLdUPNjAjWLAJEgYlu0JihoWCBrCmJbQ5YqeZcDMo
	 dK+0eA0xULvtWUL6nzHZqhImePZKLX3JjNcLJ/K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/337] um: Use os_set_pdeathsig helper in winch thread/process
Date: Fri,  7 Aug 2026 16:33:27 +0200
Message-ID: <20260807143418.616390047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit 42b8b00c8ab1ac18fccde3f29ee589626a561ea7 upstream.

Since we have a helper now, let's switch to using it. It will make
the code slightly more consistent.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241024142828.2612828-5-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_user.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 1434114b2f34..35f9beeb19b3 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -10,7 +10,6 @@
 #include <signal.h>
 #include <termios.h>
 #include <sys/ioctl.h>
-#include <sys/prctl.h>
 #include "chan_user.h"
 #include <os.h>
 #include <um_malloc.h>
@@ -162,7 +161,7 @@ static __noreturn int winch_thread(void *arg)
 	int count;
 	char c = 1;
 
-	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	os_set_pdeathsig();
 
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
-- 
2.53.0



