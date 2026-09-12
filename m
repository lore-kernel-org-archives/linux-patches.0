Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A635C6B2;
	Sat, 12 Sep 2026 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205751; cv=none; b=h3+N67GDxOnDKRvw+71if0XkwdW1XuOLykm24S8LwiL5Sn+cLUBsT+D25+Y3O03+rOJqDHIWpiiQwK3RoRwlixkm+1rrN0uWqyBvZi6zUFO0EXNsDJtwy9ocHj2KWvfJTXuJ03VOM1Hv9MiRUvPz5ddKwqnqH3Oui+hlvx0PQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205751; c=relaxed/simple;
	bh=FT3ln71cCrlvWCvX2BsY1BuAR9cRU+xDqvVjYHmjcsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DlW/olQ9mLGirfF3ZQcMUFZBfLQDqprI6d1bWOqYy2oZXzbPND+oJc7jfGNLV+QveqMjD2J1e8+K7coYtuCNrAV4bMX+u6B1mw41Yt/njiUXu2UVOky23aYEds06yQY79aVNMxZ9C0lQD3/jwDHgWyXku13G1oxqgbXa+epWPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLbsTCT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLbsTCT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD131F000FF;
	Sat, 12 Sep 2026 09:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205750;
	bh=ZYxNfkSaprFr0vtVWaoXq6ew2JF3QEzNUTOI4vz3agE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLbsTCT8NwfhiG86bIpG1bt4ODebCwUrPCpaZoHMfAPZAowHEGWC8AzCj3trOJbQ2
	 gNt5IGtGI3OIVJ8t6GuZkhr1tdgcsSX7h5HXeiFc3ReWCcwjpO9f+D+oEOSBLeDONe
	 OKChOcBdQJMO58R+p6eyFzeUWNC0LTaMtJLozQiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0065/1518] i3c: master: Do not treat master device as a duplicate target
Date: Sat, 12 Sep 2026 08:37:14 +0200
Message-ID: <20260912065624.925036336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2295,7 +2295,8 @@ i3c_master_search_i3c_dev_duplicate(stru
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 


