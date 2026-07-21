Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB2318ED6;
	Tue, 21 Jul 2026 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665584; cv=none; b=FAgxqvN1WgIb6jxjzBBxke+cAzUWFt+rKKML0JO2qO9U2/u1lKE87/n+OzxZ+GuFce1dhH8sJwvtQSwNS89riuj6y1TGB5+FSuR3Ycxm75lP6N1oGy5KjeudFI30KE4Vf+Lai//GIz8RBuEkHTczBh+FIRvDeAPDhfXrW0Nyh3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665584; c=relaxed/simple;
	bh=7pJvObSHLiatt3WgiWbJDn5JazYubni1C95KQQQWmiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b81YZiKl35A5o3CNlsfd+xhC7EiSJ4bVol/niXqfKuglNzfOB6Zz+UrXo1pazNQefk9+ENpT+NvjCNeglsg/eNgjigs8UPEzJMti2/fGlBrCj16fEd4MPT6DNgrBB13IOHiuoSEktgwb6SRVSf+GE3qgUexqvRBI6F6dQTv2LQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9PDzXz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9PDzXz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193031F000E9;
	Tue, 21 Jul 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665583;
	bh=xvlJX5GEmDxkiDjF+d+WjyJyf/MX7xf/hXGiJ+6qFr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9PDzXz6nDCDXqmg+YBOQ/WNOa77Bswuzag2v8R3uVkyB2/822ys8aefzaopFMtSV
	 Wu4b7jc8s5NF24KPK86vebAFJESwavq86uTfMfNz9CJxI1UwJNjm1MaAC6Tg2h8T07
	 kdY/yQdtiiI7t4sMWb8YxnyAuLajiF2ibRMnb2nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 0322/1266] fuse: re-lock request before returning from fuse_ref_folio()
Date: Tue, 21 Jul 2026 17:12:39 +0200
Message-ID: <20260721152449.041652688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -912,7 +912,7 @@ static int fuse_ref_page(struct fuse_cop
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


