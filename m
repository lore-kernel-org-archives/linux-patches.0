Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057942;
	b=W6ToeqYitPwEkqRADwr3t8ASOJAfLoBPk6Pgp5hztTk4PDzk5CmSWVF6ZXq+NhubN+E6
	 csDQFK9VXk48752z/lnF4YPuJp/NkKWd/7uh4zFYjCAXGVZam0SLfeMG1eyyMKRyCfSQJ
	 JdhaPQ8mToEH7cEtQj5RFFgnmG45SR694I1fYixKfY1g62YA8GAsjenNrLan9qLVYp+yd
	 n/V6ibx9RKYNjY7taD9McEL0+9zz18Hn/+6FEQ7fg/wsn9yEW+G6akBeeGj91kbd6euBE
	 jU5312bPspowNzMe8s6Fe+G8M5QoR2+YnQk/vm2AtT1MFaWnRZKPXa/wXU7WREfPtLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOzXB/7/hOIIdAZ9Q5RTlCXHTtO97gKKzYrJV65NnMU=;
	b=j+zi9aTPCyv19cx9+L8VZe3Zft6+e46ytVuUx8h4tP70qqAARUusyZXuS0gXvghMke8g
	 Bg4FeNz5jZWmbPM57qCN1jDcxa7Di+CecvBKK7Sd1Q6SZVbTij+lSSQdNokBzYEwTxGc7
	 iEgDgdglMDuoDpuNoN+Jt69ocKzgsdX0NIBRmbz7rXlE3S+gUNG4eDH3b4uvi6jHCOuVc
	 1G5dIFehkqwnVaZWGR+EJN4T1zDGOIXo/ENFPamgVBdBIDB+ZJ7ffOl9bQPCBUbAJHoum
	 uB89/MEVwlI4eI/sfz0IQfA6RvrObe6zzbgLfUDKokXQKCP32JL+w8DHfcDUFfckYkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HidJZaND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB73E606A320;
	Thu, 19 Nov 2026 03:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HidJZaND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4637E1F000C4;
	Thu, 19 Nov 2026 03:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057941;
	bh=TOzXB/7/hOIIdAZ9Q5RTlCXHTtO97gKKzYrJV65NnMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HidJZaNDBjD4lBX6++SbZ8/XXSkRgTaxDnQfr/Tv2HHWntjb1o5Os7GR3oOMj2xhq
	 Ze+7S/QWesQawSzcgZQT+NNm+IskSYBTeskX7n07VfAphLsrWWEbKvebw/C88udmJt
	 abd+EdJNdPNmZH3GcUTK6s2wErwez/QZ1zdENZac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 0268/1848] ovl: fix a torn path in ovl_get_redirect()
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118145923.512024117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 2001cd7ca5560198131e46c6ca3c3472b06145c2 upstream.

A hard link of a metacopy file that races with a rename of an ancestor
stores a redirect to the wrong lower file.

Each component of an absolute redirect must be the name that a dentry
has in the parent that the walk continues with. ovl_get_redirect()
copies the name under d_lock and calls dget_parent() after the unlock,
and the callers for a hard link hold no lock that stops a rename across
directories. A rename between the two steps combines the old name with
the new parent.

With delays in ovl_get_redirect(), an unprivileged user hard-linked a
metacopy file while renaming its ancestor to another directory, the
stored redirect named another lower path, and after a remount the file
showed the data of a root-only file.

Fix this by taking the parent first and checking it again under d_lock.

Fixes: e04527fefba6 ("ovl: fix dentry leak in ovl_get_redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -988,7 +988,19 @@ static char *ovl_get_redirect(struct den
 		const char *name;
 		int thislen;
 
+		/*
+		 * A rename can move d to another directory at any time.  Hold
+		 * d_lock to copy the name that d has in this very parent, or
+		 * else the path mixes the old name with the new parent.
+		 */
+		tmp = dget_parent(d);
 		spin_lock(&d->d_lock);
+		if (unlikely(tmp != d->d_parent)) {
+			spin_unlock(&d->d_lock);
+			dput(tmp);
+			continue;
+		}
+
 		name = ovl_dentry_get_redirect(d);
 		if (name) {
 			thislen = strlen(name);
@@ -1001,13 +1013,13 @@ static char *ovl_get_redirect(struct den
 		if (thislen + (name[0] != '/') > buflen) {
 			ret = ERR_PTR(-EXDEV);
 			spin_unlock(&d->d_lock);
+			dput(tmp);
 			goto out_put;
 		}
 
 		buflen -= thislen;
 		memcpy(&buf[buflen], name, thislen);
 		spin_unlock(&d->d_lock);
-		tmp = dget_parent(d);
 
 		dput(d);
 		d = tmp;


