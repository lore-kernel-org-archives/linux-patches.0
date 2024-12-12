Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C96C22A81B;
	Thu, 12 Dec 2024 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025510; cv=none; b=NvJYOGVFn82urynXY4oDaZiGJEwKH/dsNkWULKOKt0SzEAdwmNHVwFBFk8CjKaMeGFMzJCXYZ+7d35M/sijPyqzqQ2WXf7ZxESrVeIYgxCkGf4gfKVLCkGU7i2FtPmOmSRq1sDjFtL5dkFvwQQn3OKqxkC6QYyD3igG8v1xC9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025510; c=relaxed/simple;
	bh=DXsn0FbtWQnxXSkHpdgcmFKZxBpgazyrreYgW8WkVJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+6HyC1qL2Dzt7pvrxegvsjmNsRNrhPed1fF/HW19lkgDVS7Oy+guhr7NmOWdFMLD87GUbuZvt5EZnf9Aur6JSP0MOpULNuKb4haOqz+FK0WFMJOZAMT8Je3t1uReJsukyTuz8LbWYlwJQnLJ9wzu47J1bOkuok+KZQ/q6/ZOkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cATcRSTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cATcRSTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C00C4CECE;
	Thu, 12 Dec 2024 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025510;
	bh=DXsn0FbtWQnxXSkHpdgcmFKZxBpgazyrreYgW8WkVJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cATcRSTUK/Eqc0O3Jf+8SXGHXw3Uv76W4fArcGs2gJ5aHDyu127T3mEVczzim9TTQ
	 CHoIs5MIwQicXABlzHs82QtQmV9hmtmdrrb8ENe37vVDfmdv5w5RWdyCHT2K9Qrs+M
	 n9bDTA9QcBdHUnLJBSbsOKYVW4q5kIJ559qPQEXM=
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
Subject: [PATCH 5.4 193/321] 9p/xen: fix init sequence
Date: Thu, 12 Dec 2024 16:01:51 +0100
Message-ID: <20241212144237.607027615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4a16c5dd1576d..f5b8f009b8a95 100644
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



