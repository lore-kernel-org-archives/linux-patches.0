Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027903;
	b=BEPGk4pSlXrLbo63YAr/bqFH5KB+SgjWFZrguyglwkUVHAidC/OmA6IE801yZeklsDCI
	 bzOSIls2IML6fG9fG+C7Waz2jHzkD0tGGnr4OcYgTGcLOLeJlXOW8t5LMNuV35aDGYt9y
	 GH865uJdzck09tnVZXUcGXQDW3nFpHguOLpkH3IEbVanvOOShQdWY4nxm4Y6TEh+xZ56e
	 4xDV3pWDiYuCceMJuGZj/FB/zHB99U2LzicWoAkqFsesOKhC5gBYV55ZpS2VppB4bvRJj
	 LwXNmQyX3E1CzioF1EYLqQEbHvFTpoErqGBtt4w47LBtL0DWJtlKDzOsd2omr2QC1JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fg2Lh0VI/QFIqCGzLhocx3RX9LYRW4HivKY716SmnLU=;
	b=iDd2iix+NgpssPeWj9ND3jqPr2v10p4e7VhvwxUpA63JUUt0T3ESCA5n4szJpcYQNKwh
	 M64fIuvDGmPZeuOnK6TGRswwDSZ2yGHhaKeAvA+cyDaN00Zp89B6zrciYGJi0GQrNuy6U
	 E4qECxHxybl8ttr5GapGLlRjZpVIQv1gTC8m08IJSjW9hhjsoc774J73u3vtjMfyzcOEJ
	 X99ywFbkfrh2yVcCkrly16QJrL3mgPKAMp6AG4oSiTNmoEkqKP3Z6TMghTgBi1yaSJfbG
	 wc6T3+279GFu2KFU7L3KyuN14MBSfAeO+9/tCOlk7DNVseHkpH733AT/Akd4KdlpHvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Enri95YG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B6606A331;
	Wed, 18 Nov 2026 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Enri95YG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E661F000C5;
	Wed, 18 Nov 2026 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027903;
	bh=fg2Lh0VI/QFIqCGzLhocx3RX9LYRW4HivKY716SmnLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Enri95YGjnhUeTnxbC0KTLL+aCm/Etor9p3DtBtJtoQ38g5Nl57zfkq72VgzbJzKC
	 PVwmrvwXKSO6etLFW5HbLdF45GXdx38KQm97eY4qB6bH7qA6ZvEyn6xDYAxSKNQh3d
	 ybv8csl9PDdaVEJoDUy0f4HCXK50LGvrXg7iYEgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1952/2151] ceph: fix page vector leak on encrypted netfs read EIO path
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150232.871327232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit 00a0d7f377f6af59bc559b2e07dffff63eaa5544 ]

ceph_netfs_issue_read() pins pages with iov_iter_get_pages_alloc2() for
encrypted inodes and attaches them with own_pages=false. If
ceph_inc_osd_stopping_blocker() then fails, the request is dropped
without calling finish_netfs_read(), so the page array and the
references taken on those pages leak: ceph_osd_data_release() only
frees pages when own_pages is true, and __free_pages() would be the
wrong destructor for GUP-pinned pages.

Release the vector with put_page() and kvfree() on that error path,
matching finish_netfs_read(). Unencrypted ITER reads are unaffected.

Fixes: 1464de9f813e ("ceph: wait for OSD requests' callbacks to finish when unmounting")
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f6c8d9214362..2ca479647c320 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -442,6 +442,17 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		osd_req_op_extent_osd_iter(req, 0, &subreq->io_iter);
 	}
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
+		struct ceph_osd_data *osd_data =
+			osd_req_op_extent_osd_data(req, 0);
+
+		if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES) {
+			int num_pages = calc_pages_for(osd_data->alignment,
+						       osd_data->length);
+
+			for (int i = 0; i < num_pages; i++)
+				put_page(osd_data->pages[i]);
+			kvfree(osd_data->pages);
+		}
 		err = -EIO;
 		goto out;
 	}
-- 
2.53.0



