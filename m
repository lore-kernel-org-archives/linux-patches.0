Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17260367B63;
	Tue, 21 Jul 2026 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673427; cv=none; b=WjWejvf1xHTlSI1tExn7h402AnHdWOVhYr687rDUEZjG35ozr7EveI0DuK5TKR1F+ve698/t59C6bkBi0eyg6LhGnI0MZqNzkiCPrueamtnsDUuyk4Inkb8YRHVe6igXdVtf9xcDkJZm6ODn8e4MoXGoeUdwsS0ol+00BpjFpIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673427; c=relaxed/simple;
	bh=CoLttRy44o3E9kTFkXCG4VpMrstNeN3wn33HblraioQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGltFfTD3ADLFRJq+mxqizsIrAbP0b+j/swAb7Kj+R04eqr9k1v6Bl4Uv9C1BZy1vPiEmhMg4jEa6bQAMsOTL8nFMdtxCDMscv7r9ub2rDt//wnFD3oHrOU8BRpVovT8rTvlsUgl+/leeXC6P3DHwBYQzsrv3W8/JV+TihUcK9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD/1MhMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD/1MhMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C091F000E9;
	Tue, 21 Jul 2026 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673426;
	bh=0FV7HkTPfWEfIYp7hTsLhIGJcKUwrhJBjqnqIEh6JQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QD/1MhMaGdqFPU7T1SwiqQornaQIrQDRQeSPHitLUjP/k96O85gNm4qEjVgHP2RKU
	 m0o/qtFsr9p+ePLEv4Y/QAqiyqXd2lAcZL6gzsqNxU4if+icjEtE1hOCReuBHX5saz
	 uMn4IkVMIsT4HaBQ5I/mWi4yyIdMhS1uJ2TN6+N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 157/699] fuse: re-lock request before returning from fuse_ref_folio()
Date: Tue, 21 Jul 2026 17:18:36 +0200
Message-ID: <20260721152359.243934332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -927,7 +927,7 @@ static int fuse_ref_page(struct fuse_cop
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


