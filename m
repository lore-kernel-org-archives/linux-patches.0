Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A04713790B;
	Mon, 17 Aug 2026 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976503; cv=none; b=r0VvAnKYhMIWmfWxM/YE1FrAZFVbcWlWL+V753wJoAK6oiavmerbW9bbSwCcMmySa0k0wjN6RcQP8ET5+gOCJEzJM8RzvY2GeatmkZexm+SBstLANvfSY/tQOkE2oZ5XxyZJD7YqUeN6I3hYMP5bYZo8JpXx9DiBBix7P06pX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976503; c=relaxed/simple;
	bh=Gw7KXu2zk8VYY5x8mFSDjg0b/7rcWVC6AfW5UjCKqEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OovtnsgrU0XXNrj13OwHVofzLPByG++QTiqGRa5wXHvOdnUW3CFwkCdgTSYiizqW/W8IXDFzoArsGY6j57OJW34b5X0kdg8ykMSEygWeREwu2F3PL5tdjI0vNMprHCY4JMg5XZSfGfrQl8Njnq4PIvbbdQqcZuZpvB2EvQt055o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tOeq/yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tOeq/yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE421F000E9;
	Mon, 17 Aug 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976502;
	bh=QZqff5YJhc+3MHRbVwG/C22+NLca09VFaSfJiNlNCSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tOeq/ykGIosJC9gdctudI+qE6NbzWnx/0OBYJvYZVGHZ6W5JzSEOn8W1Mk+xfuOr
	 4wyflviKYfQ5k1314IoGKt5oxPgM9wRcrE21naa5vHShwn+2G8Rd6zejxm4gD1YzWx
	 SXPt0Z1bkvDRtOk4q1H7/5nuld0Yosi8fayK1sok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Lin <eddie.lin@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 5.10 369/389] misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free
Date: Mon, 17 Aug 2026 15:33:28 +0200
Message-ID: <20260817132553.095907584@linuxfoundation.org>
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

From: Eddie Lin <eddie.lin@oss.qualcomm.com>

commit 2fae94ee14f7fea11d3f95e10383a87c01d21518 upstream.

The 'ctx_idr' is initialized but never destroyed when
the channel context is freed, leading to a memory leak.
Add idr_destroy() to properly clean up the IDR resources.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Eddie Lin <eddie.lin@oss.qualcomm.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-6-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -342,6 +342,7 @@ static void fastrpc_channel_ctx_free(str
 
 	cctx = container_of(ref, struct fastrpc_channel_ctx, refcount);
 
+	idr_destroy(&cctx->ctx_idr);
 	kfree(cctx);
 }
 


