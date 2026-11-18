Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042423;
	b=uRmFaQRgPbTa+lSr/C1r+rAOOlw1EpLH+XqNEk+Ft6qjV0+f8RoSlyKinbYloIm5MrQ9
	 0+sW8vIGA3xENW13YHZ7DGnnjzxKj5LLRhlLk9fHHZvbXHbI8eJuX+fk5R+9QZY1iYcZ+
	 Rni/KLZPnrjTvpsHDVpowcSePaOhKDH3csEUfnJO78myxYNahwveLtvZT8qjOxRdcBHXp
	 56U7sdSrKtBbA3uigEVQS8vkvQVpJQLtf5epKBOzy4sK8y5dQEXgrOotvUPglMdYxA/UL
	 NuMvuQ3ysiC0ZflSVsMh8KOTozv0R4AHiSziAnmftLBXX1xUqnx+NFr1U433bMtoHNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9W0jPtwXe/2T1zW+Qk2Ed10SHoZnERJNKptweLsOBbQ=;
	b=AV1R0IAkrnqvq47fJOmExutuliVA9vGECsiY9VmsINy/QVwbTg79CsgyClykzOrVr7JV
	 6LPMPI1YQp4SzNIkYn8XxYlBtn4gOAM2MqKkxe+ftpHrJlBTs4flZ0663FAMxldc1G95r
	 DJ4YD2r0mVvkZjoIRGivYhvaaWcZozA5I6IbXiIojVKr68FsG2qBnu604chO0LSitfM1K
	 FnrmbF3Zy8x1U/LjvFPphhXUcbAp8wu+E28iJb5rzFbrsLeyXdAKRgi47ilGrb/lw6VtP
	 GKjUNhH7JNgdx5zrlA+2NhxvoDuZcr+n5mqZf5kcwWFVY7BTK5WN7Vw08UWJ/r3JiHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qj5vinpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9ED606A31C;
	Wed, 18 Nov 2026 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qj5vinpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBF81F000C5;
	Wed, 18 Nov 2026 22:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042423;
	bh=9W0jPtwXe/2T1zW+Qk2Ed10SHoZnERJNKptweLsOBbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qj5vinpwJzZxL3slQS4uWnqxXqouxIoayf6IK4Yq39mlxZ/2Xs2BOG0G1hM80Hj9I
	 bptY9vXeIo6isKAEdMjU3IyvxomZi0iI1tLEQOJw1c3yCZ6D9UWxie7ToHGT2BIVAa
	 yfD5Yix4RsmOdw8ykYLtk5UldjafbWwZ3dnYdbx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3166/3318] ceph: fix page vector leak on encrypted netfs read EIO path
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150454.820974212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b48ea3bce962a..4957a40777821 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -425,6 +425,17 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		osd_req_op_extent_osd_iter(req, 0, &iter);
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



