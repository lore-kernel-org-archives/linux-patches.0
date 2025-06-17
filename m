Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADE62FA654;
	Tue, 17 Jun 2025 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179493; cv=none; b=ZqIrpknYanKxYjG5eWCYN4aj2XojYhjpLxZJx+Kg/FEuQrHDGDpi5TnTCgWUPs2BLlOGwOtTXNLXxzF/m9vg20SBC75uj7Rq22PxJt773wA19yUT5bY/nshlcXl9VENSsI+GAsvsKHIk43oDfw5eOF59NeJcqH9qQp0TwEy3k40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179493; c=relaxed/simple;
	bh=+cEXI/S87VoS6fz9dhJhUS/kH4gMyy/bjh4PkBzm2uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNRHWS4+pefUtjI9VunagUkHlVl7hiXQ0RbCK2WF0XjArGv1UJtsgQOv2Jp4DoOgMjMKIkLRWYHrT4/hsOj5TcfszdnDNP1YdKnMSY5R/aDh5t9vLFRHOHgFmKN2iwINTJVm9IMG/Tpul/d7iOb5ddbEX90yqZHEAwULEFb+Kms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwwg4NlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwwg4NlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8862C4CEE3;
	Tue, 17 Jun 2025 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179493;
	bh=+cEXI/S87VoS6fz9dhJhUS/kH4gMyy/bjh4PkBzm2uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwwg4NlPahkjpWjbj0UqFHGVTxGYCZJpYDcrTvi2Jxv8koZBbIwvRgsocI35DPqcf
	 FtJbeDmN+j31uCDqMNbsVRYZP0mGiP70/g05gwkRid6qBiV6B1YVuYNvYnN3RC36VB
	 zu9SjtfQAKUOJClsS82BbaXJPvgGl3IRVuKX0HzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	v9fs@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 762/780] 9p: Add a migrate_folio method
Date: Tue, 17 Jun 2025 17:27:50 +0200
Message-ID: <20250617152522.541972255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 03ddd7725ed1b39cf9251e1a420559f25dac49b3 upstream.

The migration code used to be able to migrate dirty 9p folios by writing
them back using writepage.  When the writepage method was removed,
we neglected to add a migrate_folio method, which means that dirty 9p
folios have been unmovable ever since.  This reduced our success at
defragmenting memory on machines which use 9p heavily.

Fixes: 80105ed2fd27 (9p: Use netfslib read/write_iter)
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: v9fs@lists.linux.dev
Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250402150005.2309458-2-willy@infradead.org
Acked-by: Dominique Martinet <asmadeus@codewreck.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -165,4 +165,5 @@ const struct address_space_operations v9
 	.invalidate_folio	= netfs_invalidate_folio,
 	.direct_IO		= noop_direct_IO,
 	.writepages		= netfs_writepages,
+	.migrate_folio		= filemap_migrate_folio,
 };


