Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB13A0B2E;
	Sat, 17 Oct 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255960; cv=none; b=DPB2MSPHdUmXKUviAIfMSL/7lDJbKl8H6lAnpH6+zer6jVJa0ispt7YyaKARD4EndBqF2kwFDJhmjwMThvUcQZmFW1HeY+FizP5dgUWLJYYTdK6UvMhGQQdvMuyFFdS+nVok+DckSo8mUDEV6BR6vDH65aouaVOMZSdlrMENGIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255960; c=relaxed/simple;
	bh=CZGREHNMCQSrVcswXpfyWwimJ1O990+tepdYjY3e5B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQ53R3WDa9n+VqxqTpASi71R78Ev5r80UloVjcUWRERlo1d6ec35VCVmkQUfHpUSVW/G4pmTT3TUGs/Pv6I1xWzhSSsvacboxtF5iOh5yEjV/KWdwpAlJOlsWyIGh5hTtd+mSvDrAw2ITtKWOlTrcP4E4c9T+d/9OMdhSxflZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbKEOe5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbKEOe5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB351F000C4;
	Sat, 17 Oct 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255959;
	bh=clnQacgAlX9IZwbuHv1YJEuYgRiQ1TkylXq3he8G/Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbKEOe5RTgJ7DzTpd/HdAOGCJMrCUerde4sc3p41wyKw6vtsN/jHVGlsvhpCEwQqR
	 gpbII2YI0FMFdf/QKuTSowCRg5Kccv/jGMb4IgtvcnoDVK8LVmDlLB5rUBGh8H1yOY
	 KbgOxHj6SmmbuCeBb8EG5aZTX994BEORThU3v3zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0079/1674] i3c: master: Do not treat master device as a duplicate target
Date: Sat, 17 Oct 2026 17:39:11 +0200
Message-ID: <20261017160433.161039329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 4dc1b3eeba7991905a5b5b8129ebea51be7d87b7 ]

i3c_master_search_i3c_dev_duplicate() searches the bus for another I3C
device with the same PID as the reference device.  The search can match
master->this, causing the controller itself to be returned as a
duplicate.

Since the controller is not a target device, it cannot be a duplicate of
one.  Exclude master->this from matching so that the function only
returns real duplicate target devices.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260807145638.168865-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ adjusted the duplicate-device comparison to match the older branch’s PID handling without nonzero-PID checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 330f87c65bff4..cbe12ae58ab6c 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1983,7 +1983,8 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 
-- 
2.53.0



