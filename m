Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB3F8827;
	Mon, 23 Dec 2024 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970820; cv=none; b=KIhTH/GD3KQvJWlK/W0iib9LuypgS3uhiPIe1atB210TIcdx9bazhlZ1cHmUYO62D3hU4iBOXoih5L5iPZD2xhlp+mo5Ne8HLMBP2gFFry5awxz2nEhdgvzwTk+Pc/gVcR4KVqkZcUCigsuEedSO4rF4XnQLFRCPCIpBW9g7uU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970820; c=relaxed/simple;
	bh=tTiFYyMnZIiiHmGKiqNwjlsZKrv2gBesEXWlLqH6dRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAIJ0TgwWMvjglUK4Ctvh+Hb/pbWNeBgIoBCQDq5pcjSbCps2zYn1QdHphIZC3WkwOY+ME26S/3gMDR0bj2X09SrnoRVepnDeeGO/OsPFfHQr5aukkugh+71kPuwYWzLClWkqs4n8itf4h/CA2hM2WbfGMImLPaHhC+/ZfNgUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHmT2Oso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHmT2Oso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B5C4CED3;
	Mon, 23 Dec 2024 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970820;
	bh=tTiFYyMnZIiiHmGKiqNwjlsZKrv2gBesEXWlLqH6dRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHmT2OsoMZl5OvuWFoO1VLN0UVKyqMhXzrxg9vMxl0t8c45qe9aTZ8u0ZP5GwnFNe
	 TnE/EgA5Hs/oUbOhVw15EWahGrGwpAsWgEbma8phJZ+b7IRrPe0QkS5QHzgZTI4ctP
	 8+ZNNMK1mkOvbdES71yQf6nXgFEsQtaXatIjdFZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 79/83] io_uring/rw: split io_read() into a helper
Date: Mon, 23 Dec 2024 16:59:58 +0100
Message-ID: <20241223155356.709486805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit a08d195b586a217d76b42062f88f375a3eedda4d upstream.

Add __io_read() which does the grunt of the work, leaving the completion
side to the new io_read(). No functional changes in this patch.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit a08d195b586a217d76b42062f88f375a3eedda4d)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -691,7 +691,7 @@ static int io_rw_init_file(struct io_kio
 	return 0;
 }
 
-int io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
@@ -836,7 +836,18 @@ done:
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
-	return kiocb_done(req, ret, issue_flags);
+	return ret;
+}
+
+int io_read(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_read(req, issue_flags);
+	if (ret >= 0)
+		return kiocb_done(req, ret, issue_flags);
+
+	return ret;
 }
 
 static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)


