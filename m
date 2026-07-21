Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C76435A98;
	Tue, 21 Jul 2026 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672384; cv=none; b=CzoGHp8O8mLo0X1LnOY8OuCR3ixr8YXvSb8CD+uwhHpfiL7NCgLvObFSZt6A/GaI3RsCsKIwo6o5pYhUb/jmlaS58zCtO3lKUo9HGeSQxB9OSKTRT9oXkvnwL6NvSOsgvD7dyhLWM0hbPyzYwyVEEe2XU50KClQsBUgsWLUkNwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672384; c=relaxed/simple;
	bh=CA0eJr9cvKQrBxhd2Ow/uar3Wzjx3qTE3GiIFOzVJRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpcX6s3XuL9323iw8sqWQep6R997phbvCoZSYwuKAhdJkYugAyyHzaOGOctMGRtr7m1ed9h2CCuWpP3+aazARMM5DaAoLie/FFAzu8gNQQRCk4+/X5F23c3zWw7d2Xgx/gsqL7Gt34rDSCT+eaZ8rG7K1jomB5Hz6NMXbgLdxog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDLw6zoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDLw6zoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD731F000E9;
	Tue, 21 Jul 2026 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672383;
	bh=z2vJo5FtdKFbm3yLPedMwtceVLRDy85V/xXt04Ioa7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDLw6zoT77WLpu7YMqSOuxZVWkDwfnMusC67nJiL2zc5JfMqbdyOF7H8otAt1M6Cs
	 s2nTe7Vr2uYKA0Blf4Mted8vBU6jwH70HTs3A39sl0ISne974Q96lWQpZP+0+RWM0t
	 +CaUZnHeiWfyey+ok0U/fEjxsQIeldlGFOkH6s/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 604/843] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:23:59 +0200
Message-ID: <20260721152419.639456745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -139,7 +139,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


