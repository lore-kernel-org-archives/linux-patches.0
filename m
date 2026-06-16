Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1CC44D031;
	Tue, 16 Jun 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626021; cv=none; b=E0wcpl6qOmiRHcZNWk1SAo/w0cdU+JQxWbYCXjFczrKFhvVWZDP0mOeVfLF4SSbigpo9kEuuUxtwhQlrymsDHIM1zxX+E0jhCNlTE4DK237+bv5aIW/iGPR26ESj7WKH/68n6bZBRBA5VFTAmZo1s0hJaDWGtnYL6YjsI9EjSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626021; c=relaxed/simple;
	bh=R5sK5IPvUZct87mZUgbXIOKuAVLSAkAXVoHxoUGe17E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cieuhhq9NamEDVMrM3ls8EOts1ymUE19DRdolvsuXZrrrtQAXv7Kn7InC8f1oA1/uRqXluruyDcauBbekavKGK+XRRQ8vyx7YU2LW5MVZaEFLskubwYJQZvBz2VsOryCo8h+0c9bihKUNZ4vL23AlUjZuEIS6jzQEakX50IM05I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvXQGjB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvXQGjB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E151F000E9;
	Tue, 16 Jun 2026 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626020;
	bh=ztAhCbAzDt4KEtPUENmh5HZZ0g7W7xESvaii41dnUXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvXQGjB8eEBoZU+a4wwrVFNo5qPVTsMhIqkJOkZTYt899tsQNPzJJuO+6C6uWg5Z8
	 1Q1oWwSQhkIqVyDip0V4bxuW0olO7NYXPbrxfSpa9K14IMlqbLmkybNR+owKUCICSc
	 ZdYBYakW7TsBeTBoadJCDJUj9Jp8oheaxkEPZ5RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 218/325] fuse: limit FUSE_NOTIFY_RETRIEVE to uptodate folios
Date: Tue, 16 Jun 2026 20:30:14 +0530
Message-ID: <20260616145109.053494215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 4e3d1b2c48ca6c55f1e9ca7f8dccc76f120f276c upstream.

FUSE_NOTIFY_RETRIEVE must be limited to uptodate folios; !uptodate folios
can contain uninitialized data.
Since FUSE_NOTIFY_RETRIEVE is intended to only return data that is already
in the page cache and not wait for data from the FUSE daemon, treat
!uptodate folios as if they weren't present.

This only has security impact on systems that don't enable automatic
zero-initialization of all page allocations via
CONFIG_INIT_ON_ALLOC_DEFAULT_ON or init_on_alloc=1.

Cc: stable@kernel.org
Fixes: 2d45ba381a74 ("fuse: add retrieve request")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260519-fuse-retrieve-uptodate-v1-1-a7a1912a37f9@google.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1928,6 +1928,10 @@ static int fuse_retrieve(struct fuse_mou
 		folio = filemap_get_folio(mapping, index);
 		if (IS_ERR(folio))
 			break;
+		if (!folio_test_uptodate(folio)) {
+			folio_put(folio);
+			break;
+		}
 
 		folio_offset = ((index - folio->index) << PAGE_SHIFT) + offset;
 		nr_bytes = min(folio_size(folio) - folio_offset, num);


