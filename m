Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27C53B8409;
	Mon, 17 Aug 2026 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976386; cv=none; b=TLnHxsjcONAWRL9vk4gWsFvzNCYVgB4hXr2SjMwFwUFlnFmPmIH/2LfPc2pYCvb1nKXQIKwECCKR1BnzaZRS9UHuZ9RwCej2a5gDOOIPehHKq7fn4R3z/rxTD6dgdwDlYtaarnZKCu93uoT36IWhNjXR49pEVvMUsWZ1lG1aWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976386; c=relaxed/simple;
	bh=brIcRjLERZL/+v/ggpQ7w3f5qvs1tvhsWcXMJyC8Vek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3T9pHcuxuaeBs44WmSVUxLEK3/36Xnpq7cFGy3aEDfOtRQXeRuKXMgchcD7ypGaiTTk/i7K7vMfeiQ087jPQjMgK6mx240BrzAZwrtAq4CQHdLP7aQGMmdWhsk2puSHMyUihAqNcueHSgurnt+HCKztzdqEyIMT+R7ve2ewZTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQUuXcXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQUuXcXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D29F1F000E9;
	Mon, 17 Aug 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976385;
	bh=vmanMvd/eB6eMXKM5I7OifatJRE510ZMEn+Eh05lKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQUuXcXqmPspB9TgTCZABrvtswEZsfwZQfH8Qqiips1/KcS52yTqayJGMyt3eG0F6
	 jbU7j3RW63642/qmWE+6POq24sCG2pDCB3UZRRvgf8QTvSXTjf14cgcXav1QNNympG
	 2foGhlxbUXO9980Zsll70hxo/YXtooujdgMVXwac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 5.10 354/389] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:33:13 +0200
Message-ID: <20260817132552.576472340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit a7ad0034453ba4c353f9b8f810ee2569de33d283 upstream.

KDSKBMETA modifies keyboard meta mode but lacks the !perm check that all
other keyboard setter ioctls in vt_k_ioctl() enforce, allowing a process
to change meta mode on a non-controlling console without authorization.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Link: https://patch.msgid.link/20260731-tty-vt-stuff-v1-2-be99b9da8e30@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -408,6 +408,8 @@ static int vt_k_ioctl(struct tty_struct
 	/* this could be folded into KDSKBMODE, but for compatibility
 	   reasons it is not so easy to fold KDGKBMETA into KDGKBMODE */
 	case KDSKBMETA:
+		if (!perm)
+			return -EPERM;
 		return vt_do_kdskbmeta(console, arg);
 
 	case KDGKBMETA:


