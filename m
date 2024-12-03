Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9D1E25E4;
	Tue,  3 Dec 2024 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236876; cv=none; b=pjeHY/AOY68wOwX2awP1csrI62oWHrDL1ZqIponqGQgK2iCVzD44zFae/WLktrrhfxtar9qNejMKOvrw05EfBSs6qBz53yedwRY1eYngOhuuVI3YrVaLcZ9R+VF9LWMaRWtGUsP3+j8UqQmmALUwBhF0hNNa13J7RmHVIEsRbow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236876; c=relaxed/simple;
	bh=nljt5Zrh73Kh7zbpg9z4OK2+XXvGLDKyGgwWTxbuxH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwN3GVhFVRuZwWVjIdsxHe8PeVkxSTs+frMWm0LcxCiDLZULYZMRGJSzKXbIsCub1q6w3/dGW9J2VbAH/hK+CHWUAF2pPL1vYKkbfwopZicljTSIl8HyB4dmTdXXDTC/cUfhzNM7Irg21twj5q7870/R1ecAQkZoNZh/FwBYSzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHJtSN/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHJtSN/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31716C4CED6;
	Tue,  3 Dec 2024 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236876;
	bh=nljt5Zrh73Kh7zbpg9z4OK2+XXvGLDKyGgwWTxbuxH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHJtSN/WgbmBW69KKz+2fpjPqMqnv4jksDumIimAdeumYQZecj5SHotiv40IyGZbx
	 j0ufr0CqePUAMCqLSwvYIn2EOkmw8TOJf97syUjSMNNZAnR04CktG3WrHopa3Dzehf
	 YxQbo0wgz6TqOPgNr6uiVdvKdWZMjQ4CssPfe538=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/138] 9p/xen: fix init sequence
Date: Tue,  3 Dec 2024 15:32:44 +0100
Message-ID: <20241203141928.732740979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Zenla <alex@edera.dev>

[ Upstream commit 7ef3ae82a6ebbf4750967d1ce43bcdb7e44ff74b ]

Large amount of mount hangs observed during hotplugging of 9pfs devices. The
9pfs Xen driver attempts to initialize itself more than once, causing the
frontend and backend to disagree: the backend listens on a channel that the
frontend does not send on, resulting in stalled processing.

Only allow initialization of 9p frontend once.

Fixes: c15fe55d14b3b ("9p/xen: fix connection sequence")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241119211633.38321-1-alexander@edera.dev>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index c87146a496363..77d7e6c3d7a27 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -480,6 +480,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
  error_xenbus:
@@ -527,8 +528,10 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
-		if (!xen_9pfs_front_init(dev))
-			xenbus_switch_state(dev, XenbusStateInitialised);
+		if (dev->state != XenbusStateInitialising)
+			break;
+
+		xen_9pfs_front_init(dev);
 		break;
 
 	case XenbusStateConnected:
-- 
2.43.0



