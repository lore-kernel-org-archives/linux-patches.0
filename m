Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2974078C9C;
	Sat, 12 Sep 2026 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241319; cv=none; b=WmPZ8ONnia3RtgEso63nC1oCSHkTvwFzErcBHnU1DY6R51FHvlp6TfwVSW9HkmOUPcZuJZdBifrPAJ1Ryx80qLX+C/HezTTVsZ4kTf/bBA0TOo3qPYX6KrOG2GjoDz5f1qNaKp+Y8T7vOWOjasQm4SK1cYtzJOf2ZOEoX/1ar4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241319; c=relaxed/simple;
	bh=kY4ruyMxv6i7QOooacrJZrzbVDEeZC3zMfjpnydrlvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuGoLb5i/j72aplHjQl3+yDLXRtVqxzYpJo9g7a64y0lSirvS9vTyvns7WlaDw/95YTuNtx9Nxve7dFiq/nd0+NTmqu03RCLrJ93F02FLGLfziidudZK8iBic/5pXJCeWJv8xgFP++ohDfDmJpYqo5t2Sa10KeyfmemUueH26Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrtd46Cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrtd46Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13561F000FF;
	Sat, 12 Sep 2026 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241318;
	bh=0htFd2dJnFhlTWLG9y7W4tSLiYQyZAJNM/U1EKVTPT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrtd46Cm4CfZKduy1JvW1RgMLXJUiwPPOpJ4xfPLGlPQ3UF/eFjeDBXn8wYFWKTOX
	 2D/ZGilteoLlBYioYw51d1qC7Fhylj7hzPe0VrKuNnpP9WYUEU3M6zRT7raPer5ua5
	 UdjXmSRTdY6Vm7qBk/ABGGCIVvZSPgBz/d5M5plU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 5.10 112/798] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Sat, 12 Sep 2026 08:55:40 +0200
Message-ID: <20260912065519.531139202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Yifei Gao <gyf161023@gmail.com>

commit f574296be7f46eb60beca851240b526df232f480 upstream.

On a readdir downcall, orangefs_devreq_write_iter() frees
op->downcall.trailer_buf with vfree() when copy_from_iter_full() fails,
but does not clear the pointer before goto Efault. The waiter in
do_readdir() is then woken with a negative status and frees the same
pointer again on its r < 0 path, causing a deterministic double-free.
A client holding /dev/pvfs2-req triggers it by sending a readdir
downcall whose declared trailer_size exceeds the bytes it supplies.

Clear the pointer after freeing so the readdir-side vfree() becomes a
no-op.

Fixes: 382f4581e67f ("orangefs: rewrite readdir to fix several bugs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/devorangefs-req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/devorangefs-req.c
+++ b/fs/orangefs/devorangefs-req.c
@@ -474,6 +474,7 @@ static ssize_t orangefs_devreq_write_ite
 			         op->downcall.trailer_size, iter)) {
 		gossip_err("%s: failed to copy trailer.\n", __func__);
 		vfree(op->downcall.trailer_buf);
+		op->downcall.trailer_buf = NULL;
 		goto Efault;
 	}
 


