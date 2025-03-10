Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC69F231A2A;
	Mon, 10 Mar 2025 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628982; cv=none; b=aTcsD5SxGXOvzkkbsvGK5fQbYZNLRosk69TbKweVgxu+k9qBuKD68KjKhhYWMYZDLSX3eFz1SssuB9xr2a2HMIcxlkoVIKPIW7NSawqgk/0gao18/p7abCwZXry1ZlZ4jNr6n2szEBPaSDEe8wOrfqERazFOHz8Hp18pNfhsrsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628982; c=relaxed/simple;
	bh=WkiKFSXKsRboQO4WMkRM8E3q5HxT+p3HFG/VNd3Rqjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF0x/tqiSBMXRiHx6yxUItDEswDGgnh6171Mi5tt5sJkYozUCvil12WswVqtdcUPlt58nLdqjsHuqZy5kU/c0RJKniGFSjDpRCvUzXbOW+5Ls3q6RZbTY0MszBn4+oLlg6LBUL1Rrt4gd3dLxgoQbCYurHWDlms4ToWXVQJmW7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXO9NmS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXO9NmS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05158C4CEE5;
	Mon, 10 Mar 2025 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628982;
	bh=WkiKFSXKsRboQO4WMkRM8E3q5HxT+p3HFG/VNd3Rqjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXO9NmS4Pv/bDBzVj/0wfRriOEMHhd73r3TFawoplQCS6DoLQ81rH/lYyK5qn6XnO
	 x94RYeyl+cEkM5MGoLZRabC+WTWr68jgYcOTQc+v6mXdSEt5b/kMDUyi4qT8fYum71
	 XAiLL2dAXuxcJAYwxMsqiitvQ3kNgG2fjlPaohk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/620] media: rc: iguanair: handle timeouts
Date: Mon, 10 Mar 2025 17:59:42 +0100
Message-ID: <20250310170550.968688492@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b98d5000c50544f14bacb248c34e5219fbe81287 ]

In case of a timeout the IO must be cancelled or
the next IO using the URB will fail and/or overwrite
an operational URB.

The automatic bisection fails because it arrives
at a commit that correctly lets the test case run
without an error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: e99a7cfe93fd ("[media] iguanair: reuse existing urb callback for command responses")
Reported-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66f5cc9a.050a0220.46d20.0004.GAE@google.com/
Tested-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 84949baf9f6b3..c1343df0dbbab 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -197,8 +197,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 	if (rc)
 		return rc;
 
-	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
+	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0) {
+		usb_kill_urb(ir->urb_out);
 		return -ETIMEDOUT;
+	}
 
 	return rc;
 }
-- 
2.39.5



