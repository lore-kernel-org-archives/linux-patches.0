Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAB242C4E8;
	Fri,  7 Aug 2026 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113768; cv=none; b=IBxiDIHxe2MDZAmeRqIkbvrJmpFGXFAxG0EkH271OL5LJZhMJhdbYL6pXdseJGbDBzmzeqdZAsPuX5RIYIG0CLKqXfaO/oVbKMTCb2qi+HsozbjxIcGJ2dnRa8Fd4OPLr0QPuBdRk++1DKsMIBPlXUpCjVPwRzSGEovkhTdYGrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113768; c=relaxed/simple;
	bh=oKqSUuioZ+Gch0z6mjq3LZAhqc2oDuxi4YNStvtxJFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goV9usSLrdRLckB4jscVz5EnkPJoYc4pkLlf12FZ38UTJPwj56AzFwbcKwgwG1wj1xflYZ1BMttbaMI6ciChJ4vwgQiO4Be9RZIr59N6/8CqgX/WvLvrN/tCtrVllCu7/Y4/MTMPSFSl1mwiJ1Ym1c3/dfLmt8V9RqBRe/eXuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoqZk4RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoqZk4RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E584B1F00A3D;
	Fri,  7 Aug 2026 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113745;
	bh=hCGgHmzaesImvJdpupJSwuHEXDh8dyC2aWkfun5qfX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoqZk4RXvoag5ez3Ob95eENzLT8jN3RAcnQnl+/W2BqbnQceeHygVrc8SDmWC5Dsv
	 ptJW0yIS9nAiDofzzeELuFGTg+sOd3z8oXZgUQncquKsSKBdhWR522VqVdnZOiWPI4
	 tgRSQD+agIXjjJ2NJQqXHIRlO76PQ9Z/zFyIgJKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/337] um: Set parent death signal for winch thread/process
Date: Fri,  7 Aug 2026 16:33:26 +0200
Message-ID: <20260807143418.593750999@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

commit fdb2ecd35d327a1fc6bba69b97f85b494e1f4b6b upstream.

The winch "thread" is really a separate process. Using prctl to set
PR_SET_PDEATHSIG ensures that this separate thread will be killed if the
UML kernel itself dies unexpectedly and does not perform proper cleanup.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20240919124511.282088-5-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index a66e556012c4..1434114b2f34 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -10,6 +10,7 @@
 #include <signal.h>
 #include <termios.h>
 #include <sys/ioctl.h>
+#include <sys/prctl.h>
 #include "chan_user.h"
 #include <os.h>
 #include <um_malloc.h>
@@ -161,6 +162,8 @@ static __noreturn int winch_thread(void *arg)
 	int count;
 	char c = 1;
 
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
 	count = write(pipe_fd, &c, sizeof(c));
-- 
2.53.0



