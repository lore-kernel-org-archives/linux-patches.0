Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E84E43E07D;
	Mon, 17 Aug 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978163; cv=none; b=VyE3zn8hIgOQnBZC3wKtsP8qlE+Xn2ZxZEOWhPPoeXumlNa6/2t2WIUsqbHscJNUzyDU7GPI0qs5R0lgkM/ZRcUwNp2Zs89/zs63TG6SbJQ0KKSTOiWq9B+XHLJ7Xjj46ZLH1r/pbZvRWFykNFWpXQOQMmNEgsaQv6xxXB8eejU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978163; c=relaxed/simple;
	bh=bZ6pCFHfzOamIuHK2VFYCTwEBdSOLik+xgakOpoohNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnHF+CifjizuzNepypUhGHAIP1fyeAXPwMYSO8axKMYx0ib7erwYAvZst7bSFAilwTZKSXJ3gXBWNWxbeSwLuyLRi4E/dDRV6wC0JzKbS2us1T8aSxrxyxIv/bfI6JW0XBfH6+4sXXnr6k8iZZJlvdKCSMlG6FwIINcGsB9b5fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=by3lSYiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="by3lSYiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576B21F00A3D;
	Mon, 17 Aug 2026 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978156;
	bh=AwJAFZaNfGBdG0khGlGqDht/pEPj5R6ZSdMrCl3RGNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=by3lSYiLqYwKDX+q9PVtHCIJPICH/TpOeulAe85E1TzTyFl171JlRlFaPh+6S9ge8
	 HQHnyeqg9D8NJx65r/MTD9nE+12HjviNnNYc1kiSYLfaggrInjKcYr/V8PkP/KqEjk
	 8IU26jiLHDzWu6xnFXnhR8D9Ed5Rui5leY+lhfnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 6.12 082/181] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:32:56 +0200
Message-ID: <20260817132538.668464547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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


