Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1774931D372;
	Mon, 29 Dec 2025 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025532; cv=none; b=ph5PuE+8klsY821eXCZovQPolHDDn9wK/s5b8/XyJL4BJGtpHIwfvuyiUOYNmxhGwowoZStl9XsdBn1z26nODrfIC4ibz4PvTT4nCnxSI2SpZNDP2bdZLbp7Cgv0TSHg5u0194Z16OZDRz0/FMXvxarGXjZ1nDkqev12t0jFcpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025532; c=relaxed/simple;
	bh=W7pcwOuYsxzVJLnIWjonAOxN5aMh911yRw8fj9ZQnUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChzAyS0bVYR7VDLWlhTtaJN79aTnNWAN+9e2euqdC4ZvqKe0Xb4f4pG8fV5cMz+yT6cWZNH7aRoovN8vRrxYlTF+unqVnBBoeJJw/Mf+ey6REIsgFkPlIINR7AAmzb4G6etzZME8qtKUGysYU/NoN96PiHBOtfux7ChRGWtthhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDJi0E4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDJi0E4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459DCC116C6;
	Mon, 29 Dec 2025 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025531;
	bh=W7pcwOuYsxzVJLnIWjonAOxN5aMh911yRw8fj9ZQnUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDJi0E4wAXeTLJGl8dkmv7ccHFrQTP5RyBXQwII/E1p+ZHE9DeZD5DJLnYxjBGvTG
	 lr1HhiUcrr2riEVv374xPqJDow9RNE3U2d76Dvv8wEW84gPUClBOFJ1YcLEWyl1VjE
	 LuLMIVumurLsDpf8EOLgSMqrBLIXrt0VGuO7RmNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.18 247/430] gfs2: fix freeze error handling
Date: Mon, 29 Dec 2025 17:10:49 +0100
Message-ID: <20251229160733.445354805@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

commit 4cfc7d5a4a01d2133b278cdbb1371fba1b419174 upstream.

After commit b77b4a4815a9 ("gfs2: Rework freeze / thaw logic"),
the freeze error handling is broken because gfs2_do_thaw()
overwrites the 'error' variable, causing incorrect processing
of the original freeze error.

Fix this by calling gfs2_do_thaw() when gfs2_lock_fs_check_clean()
fails but ignoring its return value to preserve the original
freeze error for proper reporting.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -749,9 +749,7 @@ static int gfs2_freeze_super(struct supe
 			break;
 		}
 
-		error = gfs2_do_thaw(sdp, who, freeze_owner);
-		if (error)
-			goto out;
+		(void)gfs2_do_thaw(sdp, who, freeze_owner);
 
 		if (error == -EBUSY)
 			fs_err(sdp, "waiting for recovery before freeze\n");


