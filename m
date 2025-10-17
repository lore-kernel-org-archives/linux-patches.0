Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8133396E5;
	Fri, 17 Oct 2025 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714530; cv=none; b=mkGzLcBvqlfzdiN4+WpPRzUYzSt933UTqPMW2MyS7fAh31NGcCJ3cF8Gi7+JW8hq7Va3A9omQUtsw7K7R2fwGP4st64YYQugQrRjdfFqFXHUo1Yvod607eiTpTz9DUwYdr4UBzHLNpz2LslTqga6UZTwIHCYob8GwaHXJREXN94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714530; c=relaxed/simple;
	bh=jA03EU3MjkqZYH22oeTDOHTUoxykLYjT/mltUs+kA6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okbwmBnWDxWCm1phfGSLYf9dT6p4wP+o64JrjioSM66L608/Ve5TKL80EvPDc6CqMUJ25dIaUM7818KBh3d4vh0ADkJsdujgHneI/MV3P6hfEt4O3+n2NYHncGYabyGD5YXQuV5u6f+Qszu7L5b1fGTQ4zD2YcaoYcJz8Zi3tyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJBk3XeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJBk3XeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF48C4CEE7;
	Fri, 17 Oct 2025 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714530;
	bh=jA03EU3MjkqZYH22oeTDOHTUoxykLYjT/mltUs+kA6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJBk3XeIxZKKHN7XSG+WfGmo70BtlwFd7nZzM8DjSTJvOnOAyJK0ZjmeFFvlyfEkB
	 l5xowcXBaFBhKgQyQIlqIRMqBce4XuMVrXS/aOHE7K1JpmOjBwXCeXAinvyV/+DFdg
	 6+iJvj0EIV1md3GfHQ744dReciKOFDQizY47lfRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 134/277] fuse: fix possibly missing fuse_copy_finish() call in fuse_notify()
Date: Fri, 17 Oct 2025 16:52:21 +0200
Message-ID: <20251017145152.018618756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 0b563aad1c0a05dc7d123f68a9f82f79de206dad upstream.

In case of FUSE_NOTIFY_RESEND and FUSE_NOTIFY_INC_EPOCH fuse_copy_finish()
isn't called.

Fix by always calling fuse_copy_finish() after fuse_notify().  It's a no-op
if called a second time.

Fixes: 760eac73f9f6 ("fuse: Introduce a new notification type for resend pending requests")
Fixes: 2396356a945b ("fuse: add more control over cache invalidation behaviour")
Cc: <stable@vger.kernel.org> # v6.9
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1989,7 +1989,7 @@ static ssize_t fuse_dev_do_write(struct
 	 */
 	if (!oh.unique) {
 		err = fuse_notify(fc, oh.error, nbytes - sizeof(oh), cs);
-		goto out;
+		goto copy_finish;
 	}
 
 	err = -EINVAL;


