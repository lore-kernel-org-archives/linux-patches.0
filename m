Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021737;
	b=chbjvgjLbzVYaqrZRzc3SmXJ6nri5mvM+MUWfLHF60AHwnpJamVnVfMR8U5jLJ0cFCPV
	 ziDG5Z4j5u8KRigQc+1eyxAhPOdGan4SoE5dCubS4cXs3JZSh6MbTC+itbt3I2z5Q2R1P
	 nMtyX0u3zpH5JdYdYPcTkteGlzI7ThbYkhqW9XSUdmW2BCglUG+MGvViezse191eYrzpi
	 U4V9X68TzjfKv6y1xUySWv4i8c7tHvsUJyDA6qe3zzg/HtKHwZ0wutwHulC+4o65wUPdK
	 TxuEc7/hTjd8OO7s50oqFMMBlzsH7ff0ErIQgI9D6e09Jql54BfKqf2TSUB4sjfFRUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNgN8MypmvOH6JqGwuIazlfPJgDJO8Eyv43ZNQ3WoLk=;
	b=ff6W69bTkwPTMzoW40EpDJwL9CwbqZlAln9xamNCsP/tOBFk5PMlM4Tnoso1VN6g3Sf/
	 lbnBjoUAoosSEg7m10v166TjQifJJBes7TEfoJQeKXkAVkAO2r83zDr7wPWBN5mtMI2R7
	 C6fBGMM0by2YNez1FWTuJvwLb5Tc19XrDIm4e4T8K30z7UMyutoSTRLdj7Hd3LA9a4nIu
	 lOtlE41aYCmTD8b/0+cl1JGwZ2COXVRw7wN8n8Zg1iPHm28dzhOgpr5CIKGNvl3FIQgay
	 Fj0bUrMSFTXI2J4yKri1a5Qd+dfPOzLKisl8opwUBJ9qvWi6g7eN2Pgtq5Q4+qW+Kmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mZiI+Mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44C60A5BC0;
	Wed, 18 Nov 2026 17:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mZiI+Mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF9C1F000CB;
	Wed, 18 Nov 2026 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021736;
	bh=oNgN8MypmvOH6JqGwuIazlfPJgDJO8Eyv43ZNQ3WoLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mZiI+MjIrq29ELtRancR7V22kAg1PxtsNlBwPtoIARNn9hQ1bUisuBmt3XRk1luK
	 X0bt0C8cmUiLM2uWuIrBUZA4z39RavVuCbzcIZaJ83gTqozAKcsCgmZIJfZMT3z/Sv
	 +/3FrhW3Rp9MvNpBJd3xfTT51qbOzmFbx2JiwBy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2414/2651] ceph: fix page vector leak on encrypted netfs read EIO path
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150412.192343757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f32a533f41009..5f34863d3724c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -450,6 +450,17 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
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



