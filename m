Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3935F3D8137;
	Wed, 20 May 2026 17:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297329; cv=none; b=YOpo6Gn/c7jGaAfmJXU5t5u52KHgy1P4UYIKABW8I1QsDl55TBTWGMWpu+wKHUn8RJzz0/UVy91jniQlnI0Dx3OXGXgAfAIYX1wkfcVSeOfcCIBVG+8F8CGEdxlWa73eU3e1Tpr/1xExUMXzJX+Qe5ed7XejkYmerLYJh+Di++M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297329; c=relaxed/simple;
	bh=KtDkyEbi5kQCXjyzdTO7BtXQ8W3FRDkcPLjyAL2b9A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHOvy8lNBD9/3L9tkarDPxm07ZRjPyKxxjgRjaIpj7EjQeu4ZJeamcEja2soivia6dc1DADTpFq2MquvS27pn7PPXXhh+RVjnbQVk1q3TLZdRSkYQrsSU9KNt63V6DWOsb8PJP7sNkxVer/v3YGf9Dnb6QnK0Gkg43ixkWVkRaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8FkV0+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8FkV0+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A781F00893;
	Wed, 20 May 2026 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297328;
	bh=aTGfqL+PAwvIFlov48O4bGYzK+Ee1468MNfJztO8QVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8FkV0+uVr4yyqHUg5aPhid7qr7Ka1aeFkg4zsrJZfDpwj0xCQaj5SC7Wlw20uim6
	 k+mcg/367ds450WgSPS/ZHkiSuEBBUcYSfTv2PQZ7vHdFSrwddjkRfTcHThBjFKP/E
	 A9ccfOXYKUzP8Cgm9zGgLygXDS6WmYM9sl+zOKC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hristo Venev <hristo@venev.name>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 1096/1146] ceph: put folios not suitable for writeback
Date: Wed, 20 May 2026 18:22:26 +0200
Message-ID: <20260520162213.046718077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hristo Venev <hristo@venev.name>

commit 544576f0f05c4a759806acddfaaeb686f14fb4b0 upstream.

The batch holds references to the folios (see `filemap_get_folios`,
`folio_batch_release`), so we need to `folio_put` the folios we remove.

Tested on v6.18.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/74156
Signed-off-by: Hristo Venev <hristo@venev.name>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1322,6 +1322,7 @@ void ceph_process_folio_batch(struct add
 						  ceph_wbc, folio);
 		if (rc == -ENODATA) {
 			folio_unlock(folio);
+			folio_put(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		} else if (rc == -E2BIG) {
@@ -1332,6 +1333,7 @@ void ceph_process_folio_batch(struct add
 		if (!folio_clear_dirty_for_io(folio)) {
 			doutc(cl, "%p !folio_clear_dirty_for_io\n", folio);
 			folio_unlock(folio);
+			folio_put(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		}


