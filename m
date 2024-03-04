Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA907B3D8;
	Mon,  4 Mar 2024 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589348; cv=none; b=urY9HsG14JT4QqMN42/dwmm+3RIx+KJZdEKezILu65rCQMOcd27Kb7JNOFkWc0WJ/umE12baBrcIpLkkbvfIjr4YiO4zJ+RqlLL8mXrWQY8/hlTZ3dJoz1KON3rBCDT/UA+CxU2JtEdeKd4SPKSdQWOfAz3E12EZwdYz4gAEFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589348; c=relaxed/simple;
	bh=A9o8AUdEJZo7V5NnkF0ylxIvUvZAC7h8UldQvLFs8Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1bfqgO7AjhAw4gUNfyYxgKbir5pSVyDR3u0+HAJ4nwPMX6WV/SJCiGuy+TeI+ehhP+Gh9+gE68OCuQgU+LhieVA3qclw3k4dipgmL2DPhMgsJQ6MsmCJKYen1PmFjfG6s3gnKjIrOGtPGyCoFslRvXyld8iNuHBj1Ia4pFXs8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWuH1bee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWuH1bee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C39C433F1;
	Mon,  4 Mar 2024 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589347;
	bh=A9o8AUdEJZo7V5NnkF0ylxIvUvZAC7h8UldQvLFs8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWuH1bee39H5E+Rpdt0LujTHGfQlpICf9U+LeIoN//xxsk7ozkQ065JIoqfMpkXJE
	 pAFPn+BTx1WvmNoExDwgLVIo0PbJsaZBCT69lZOjzfgvBm97F3jyIZu9tZfapxcD3P
	 JAI7Dut66ompsZbZB7BeeXOd+oiJNm9YfdzI47Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd4779978217b1973180@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 50/84] wifi: nl80211: reject iftype change with mesh ID change
Date: Mon,  4 Mar 2024 21:24:23 +0000
Message-ID: <20240304211544.029514096@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

commit f78c1375339a291cba492a70eaf12ec501d28a8e upstream.

It's currently possible to change the mesh ID when the
interface isn't yet in mesh mode, at the same time as
changing it into mesh mode. This leads to an overwrite
of data in the wdev->u union for the interface type it
currently has, causing cfg80211_change_iface() to do
wrong things when switching.

We could probably allow setting an interface to mesh
while setting the mesh ID at the same time by doing a
different order of operations here, but realistically
there's no userspace that's going to do this, so just
disallow changes in iftype when setting mesh ID.

Cc: stable@vger.kernel.org
Fixes: 29cbe68c516a ("cfg80211/mac80211: add mesh join/leave commands")
Reported-by: syzbot+dd4779978217b1973180@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3914,6 +3914,8 @@ static int nl80211_set_interface(struct
 
 		if (ntype != NL80211_IFTYPE_MESH_POINT)
 			return -EINVAL;
+		if (otype != NL80211_IFTYPE_MESH_POINT)
+			return -EINVAL;
 		if (netif_running(dev))
 			return -EBUSY;
 


