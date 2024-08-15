Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC21AC896;
	Thu, 15 Aug 2024 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731594; cv=none; b=Gx2hX248/wgXT8hf0r0n0PJt9dTG1+bs2qjaoMpM1znd/fgL1f8/4F92lWpJIiHcZYJFfSTKmHUWujHxQa23BDCwuGfaPRS4II7b0uumjnBwXegAW8o/VorED9eTiBct4ezsVQfNmS24DMgFgIZ9KPhBgeGFrFZHj0pkOk8Fm7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731594; c=relaxed/simple;
	bh=iCxfgtAlR+xJiZuFxkWjVG2RHGPKw/uVPERCweTxjHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQOkgd2cCbxNZA1YUX6gOBeVCgjYDzQSBwUp0L5fm9PMKlZZpbHHlaibC7kMeBActubhGvf8JJdbw9KgwIWS9FLENlNLvmOMiXSI/TDdqLMiYHz15I+dcEOllwmlzjJ+8Lo5Ac1iSBCcaL0aEZfIwXRK2GUdmksAKBQTcNKWoIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxCFAlla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxCFAlla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E327EC32786;
	Thu, 15 Aug 2024 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731594;
	bh=iCxfgtAlR+xJiZuFxkWjVG2RHGPKw/uVPERCweTxjHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxCFAllaAYngUxQOM7QhSS4OpHl5BAyh77nNjpnCqSsybnLjXBUiDfxaA/S4uQiIy
	 wpyUOYak1PUYosKSPWDTQy9ZJyiyK7ihyNmPM9kLycm/jbUtxTrTSUyHrB/02VS3bz
	 7SAMeN1Estu9c/Bx2ANov3LD5LIbqJZSSTWqMOeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 179/259] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Thu, 15 Aug 2024 15:25:12 +0200
Message-ID: <20240815131909.691966354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8aa37bde1a7b645816cda8b80df4753ecf172bf1 upstream.

both callers have verified that fd is not greater than ->max_fds;
however, misprediction might end up with
        tofree = fdt->fd[fd];
being speculatively executed.  That's wrong for the same reasons
why it's wrong in close_fd()/file_close_fd_locked(); the same
solution applies - array_index_nospec(fd, fdt->max_fds) could differ
from fd only in case of speculative execution on mispredicted path.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -908,6 +908,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


