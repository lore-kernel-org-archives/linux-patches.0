Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3617B38F62F;
	Tue, 13 Oct 2026 12:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893523; cv=none; b=V+ghU32BtojhVmlRxWhscMeg61PcOVDGmhc//3UCaT7KN1C9MdYDPOy/kzQggLy0NaimYuksnWn0yVtpT+LDIGs3ZbdkyXnnaHfmsAmDO0OlPBN7QaIP+ezuo11VmLyAISnHGEcvMo5mE7eXhv06Wnm2KHzS9VKUYGlPqmD9YqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893523; c=relaxed/simple;
	bh=bn6ZrFNMvDYmv3Beh7WkEGYXMBR9yn2bbq9Qt10xMuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/N7Zj34SEiYLnymlCuEkMdXfm1tYSEmus10xio5J9/svrPkuKJSybCUOj6Y98cQVcY8n+A8bbsR0GNVsmv4b2+X5qcxfA2lEKKXoRVsmNgGCB+5TNLupdxXsgEECnbcsndxV452zFAGJh0vIHyekF6XBVLHo/NgI4P259IFCpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF5b8LAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF5b8LAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAAF1F000FF;
	Tue, 13 Oct 2026 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893522;
	bh=CGNfLKJyi9efKiBhxAJjJ73FFQMaPlVhELiSOqYNubA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jF5b8LAMW9XGoQjV8D2YANAHt9jo/A7PgshrHEHyIYBZo+YtwjJBzsx3Zw47v9guc
	 aGgXWIGOlEWvwS71Nl4UUQjw55bffK4gizHCU5DPEfhUZ2eqmgyJY11JVJBEzOZTvb
	 SHuX9ZPqOOdpsZ3YpsCFDySBVBzNGMwh58fAzCzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hristo Venev <hristo@venev.name>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/621] ceph: put folios not suitable for writeback
Date: Tue, 13 Oct 2026 13:33:25 +0200
Message-ID: <20261013112925.844435594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Hristo Venev <hristo@venev.name>

[ Upstream commit 544576f0f05c4a759806acddfaaeb686f14fb4b0 ]

The batch holds references to the folios (see `filemap_get_folios`,
`folio_batch_release`), so we need to `folio_put` the folios we remove.

Tested on v6.18.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/74156
Signed-off-by: Hristo Venev <hristo@venev.name>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index faa3de95caff6..cfbd88412f047 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1338,6 +1338,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		if (rc == -ENODATA) {
 			rc = 0;
 			folio_unlock(folio);
+			folio_put(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		} else if (rc == -E2BIG) {
@@ -1349,6 +1350,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		if (!folio_clear_dirty_for_io(folio)) {
 			doutc(cl, "%p !folio_clear_dirty_for_io\n", folio);
 			folio_unlock(folio);
+			folio_put(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		}
-- 
2.53.0



