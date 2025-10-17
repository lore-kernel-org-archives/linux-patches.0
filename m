Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088C1330B26;
	Fri, 17 Oct 2025 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716233; cv=none; b=YIVmJcL+or0qwSiot+ppIR3GYsukDnpkgKx8FgfT0s+NrDailpCH0u++F71g8fgRzGFD80vIRRvRxPJugif2Z4JQRvo0GmIkCnUh1qFWglO5hsNNMNS7s2lz1THr76PAmHy6nhMx1pl28BPBNI67QTaOvzNA27ACAhg1E7UPGvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716233; c=relaxed/simple;
	bh=NW2aKZJZbUt+Jzz1WpcWFfahtlWBZevyHAFiLPPdu30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hn5ZMMcB05xjqCbzzkuvgEXMqgUcoSKT4g/qzMINu5e6vYn5btko6PRRDg7v8cFVyzoga/T+9Bxt8uKU6iS2t/reAMjTXVu26uxQ+H6FmmRqtaBcNtq/PgFO7PITUFrZKkbPdTejL+wv3LP0sSdOJbM25XmPZqvU2++0T26nO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSh1GU2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSh1GU2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839E7C4CEE7;
	Fri, 17 Oct 2025 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716232;
	bh=NW2aKZJZbUt+Jzz1WpcWFfahtlWBZevyHAFiLPPdu30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSh1GU2I5ZpSwjc8FT2S4Wz90Cx6ZPDrUZwIZCmJckJmxu/8SKZX51Qw1dMCrhWus
	 7RRPd/cDv31ybl1j7Kw0RUgqWEs5ia6eCA/l2nvf6a6MmshUDHQrHECT32yvB7OQle
	 R7cWJtifnE9eBw9QFJ+HJ96bTJansaWlzGAcZnaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 120/276] fs: always return zero on success from replace_fd()
Date: Fri, 17 Oct 2025 16:53:33 +0200
Message-ID: <20251017145146.858285975@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 708c04a5c2b78e22f56e2350de41feba74dfccd9 upstream.

replace_fd() returns the number of the new file descriptor through the
return value of do_dup2(). However its callers never care about the
specific returned number. In fact the caller in receive_fd_replace() treats
any non-zero return value as an error and therefore never calls
__receive_sock() for most file descriptors, which is a bug.

To fix the bug in receive_fd_replace() and to avoid the same issue
happening in future callers, signal success through a plain zero.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/lkml/20250801220215.GS222315@ZenIV/
Fixes: 173817151b15 ("fs: Expand __receive_fd() to accept existing fd")
Fixes: 42eb0d54c08a ("fs: split receive_fd_replace from __receive_fd")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/20250805-fix-receive_fd_replace-v3-1-b72ba8b34bac@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1154,7 +1154,10 @@ int replace_fd(unsigned fd, struct file
 	err = expand_files(files, fd);
 	if (unlikely(err < 0))
 		goto out_unlock;
-	return do_dup2(files, file, fd, flags);
+	err = do_dup2(files, file, fd, flags);
+	if (err < 0)
+		return err;
+	return 0;
 
 out_unlock:
 	spin_unlock(&files->file_lock);


