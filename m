Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAC1430CD5;
	Thu, 16 Jul 2026 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212490; cv=none; b=RTrxQrlbcL5EooFq2mxS5tlzdvk/94evyfUZTJY89XloLLt8YZw3DqaI8gS2E9Or9V0NHthG3Do8HD57TGhEejinovcteHv9DGNCbsorFsDoNqhzBF0SRtwWhBi4A3AOXPrIB1ImFZ0txtFwxAPJtjaokEXDujX+W6+qPEfnJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212490; c=relaxed/simple;
	bh=e1cva7kQVULpL32Iof7uEuG/5jV1ezB403kRkae/QSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRmuUJcyp6Q05nmQ+W89iqgDgHc6p46N5adeQPf7ZwREFQxNhoGuk4Rmp04tvFPFhx+iBhnSNwTkJ5GlUaqGkimKHlTU/PFSzZHwkREZeu2zKt2DcQ3291sc5GsI1XfhLlsxb8HO16STIuSh9xjk8iU47++nqQNCNgQitpxtCDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou/2c+LQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou/2c+LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE051F000E9;
	Thu, 16 Jul 2026 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212489;
	bh=ZJ9GV2T+a6Xq4nCUVyI9a+45jdqqMglWq36RnG9LA3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ou/2c+LQSfmXWwM0Wc74iH0aXi0YMNlfHTdrPcsw0nJODjOK544hPRruyUX/4zK0U
	 j+e/ZVUdkmrxkBSAiPOV1CNKLRMek7Q84sjTtEXqJSGMzLhObH33/HBExPj87b+Fbu
	 FJXmlWVJyFBZgM2Yx5kznuGxL/oxLWObxDIBApx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 347/349] fuse: re-lock request before returning from fuse_ref_folio()
Date: Thu, 16 Jul 2026 15:34:41 +0200
Message-ID: <20260716133041.068485657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit b5befa80fdbe287a98480effed9564712924add5 upstream.

fuse_ref_folio() unlocks the request but does not re-lock it before
returning. fuse_chan_abort() can end the request and the async end
callback (eg fuse_writepage_free()) can free the args while the
subsequent copy chain logic after fuse_ref_folio() accesses them,
leading to use-after-free issues.

Fix this by locking the request in fuse_ref_folio() before returning.

Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -960,7 +960,7 @@ static int fuse_ref_page(struct fuse_cop
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


