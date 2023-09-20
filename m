Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C16F30FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E88C433C9;
	Wed, 20 Sep 2023 12:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212320;
	bh=lwuY3JCMPpzFxUOSqDBa0Kri8cjAX1lBMgQ4CzugVqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOGac/RWgxD46zVWGz1JuYCAPDBO6JT0GPw+pjv9XW7Qp4AFdo87niIqvJ1urKKRq
	 BF9PstiBWkXwzJkyPvM2+P9ec93PSB6weub0ATMQv+A7yZeSfYeEECErLiMeTXHqg7
	 fdoieKYVQ6Tb40flUkeADIYJiK9f4zaA3a02qHB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 205/273] NFSv4/pnfs: minor fix for cleanup path in nfs4_get_device_info
Date: Wed, 20 Sep 2023 13:30:45 +0200
Message-ID: <20230920112852.823301716@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


