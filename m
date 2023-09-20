Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C19168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC68C433C8;
	Wed, 20 Sep 2023 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213474;
	bh=FwqdeRgHPAjFXInKwcrnlj5729dPqStP4kK0GWghxBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1hnubG1n9wQGlvIEwN5P9QF/6pB+CeCM7/A5tTueKhiLUUqu/ffJaK0EjkRqrSG/
	 5Lu4DvrHwAKbcFWOiijwCiOisC18eVFSTIFqdCoGMtxVof8pGuMp8g/EiZ0OJV9wKc
	 mWzUrcbz3EoO3lX89wHrb8wqnTwKlle3rValD9yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 251/367] NFSv4/pnfs: minor fix for cleanup path in nfs4_get_device_info
Date: Wed, 20 Sep 2023 13:30:28 +0200
Message-ID: <20230920112905.053999118@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 96562c45af5c31b89a197af28f79bfa838fb8391 upstream.

It is an almost improbable error case but when page allocating loop in
nfs4_get_device_info() fails then we should only free the already
allocated pages, as __free_page() can't deal with NULL arguments.

Found by Linux Verification Center (linuxtesting.org).

Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs_dev.c
+++ b/fs/nfs/pnfs_dev.c
@@ -152,7 +152,7 @@ nfs4_get_device_info(struct nfs_server *
 		set_bit(NFS_DEVICEID_NOCACHE, &d->flags);
 
 out_free_pages:
-	for (i = 0; i < max_pages; i++)
+	while (--i >= 0)
 		__free_page(pages[i]);
 	kfree(pages);
 out_free_pdev:


