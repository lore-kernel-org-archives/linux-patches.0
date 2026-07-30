Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A8450901;
	Thu, 30 Jul 2026 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428309; cv=none; b=FskThrsfLuxR8ve6i305f9+UqaDW+C3Amzt8Ao946j1/JFVoMqMdhnC3JPDCyCGcYmKlm0uM1l15oGrkhtX8+etNd/9B1pDGCvP5J73FPw/MYg+5rqKWKKPaOvW5KrfGu8pkDZcxKWD2ouJTWwME9GDHC9fif9xI3peCrwKxxHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428309; c=relaxed/simple;
	bh=kuZuEPEpfE7s1JvoCNrbUS4cRuLrqMZSme0967JcRh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QelppeEM0xD0kaVd25cRvi8iC7f8xmqkyxFjbnKRwQWoMVrBkF81dqISGLt4VKXsQbEF2il3YA8RvTYVibp0GIXLiUDgeAu+2YLya2CHbhbrcevURdGlRnyUdf+OYsRtNXZ3MIoIW3gNWHR0UGRnaDsWm1FOv8qc2nkyrH/M1cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xusil7oE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xusil7oE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF11F000E9;
	Thu, 30 Jul 2026 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428307;
	bh=PdHEcSvjHN8SfJNvR2mrTlbO/bWIz0i6KDZkw27C/GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xusil7oE3GpvjJb0wvIV7QM3o9VxyDivXZJVh7issTnVJ4R46RY/8V+s7pyYi6RJD
	 k6RgLu3XCzbV0Yd5f3mPKTV9jAd6usiCjj+2bFYg7Gv3Fkqa1pOjzCgpXdxgXGmRDJ
	 5USnsi6KTMjHbwTKUQ4Pxxu+Irvs6Ergmz3gb/CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qian Zuo <zuoqian113@gmail.com>
Subject: [PATCH 6.6 477/484] coredump: fix pidfs file refcount leak in umh_coredump_setup
Date: Thu, 30 Jul 2026 16:16:14 +0200
Message-ID: <20260730141433.856501938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qian Zuo <zuoqian113@gmail.com>

The backport of upstream commit b5325b2a270f introduced a reference
count leak for pidfs_file.

In the upstream implementation, pidfs_file is declared with
__free(fput), which automatically drops the initial file reference when
leaving the scope. During the backport, the code was rewritten to manage
the file pointer manually, but after a successful replace_fd(),
pidfs_file was simply cleared without dropping the initial reference.

As a result, the pidfs file keeps an extra reference and is never
released after the usermode helper exits, leaving associated objects,
such as struct pid, permanently allocated and triggering kmemleak
reports.

Fix this by explicitly calling fput(pidfs_file) after replace_fd().

Fixes: cdb61a705f5f ("coredump: hand a pidfd to the usermode coredump helper")
Signed-off-by: Qian Zuo <zuoqian113@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -560,6 +560,7 @@ static int umh_coredump_setup(struct sub
 		if (err < 0)
 			goto out_fail;
 
+		fput(pidfs_file);
 		pidfs_file = NULL;
 	}
 


