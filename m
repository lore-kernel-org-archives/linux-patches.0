Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6CBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B66C433D2;
	Tue,  7 Mar 2023 18:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215422;
	bh=akyYRHokZSNmQWCan4zCkNJahBuuH1/vcHo5kRvikYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp0PgMFN24epsbTXvXC2j5hItFXiWLT0OaovCODDLAC3F5Z0+A8Yo5kaCn3aSsgoF
	 xD7E/7bUNOv5ZNHHNrqEd7uMlKq2cnK7sqv6rUm4YDjGuwK8OjXx/IrJnctAdJPR+I
	 iatHtWfw8ziumsatyzdeR19aaNRuv5Ne4D8xGF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/567] nfsd: fix race to check ls_layouts
Date: Tue,  7 Mar 2023 17:59:51 +0100
Message-Id: <20230307165917.001671219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit fb610c4dbc996415d57d7090957ecddd4fd64fb6 ]

Its possible for __break_lease to find the layout's lease before we've
added the layout to the owner's ls_layouts list.  In that case, setting
ls_recalled = true without actually recalling the layout will cause the
server to never send a recall callback.

Move the check for ls_layouts before setting ls_recalled.

Fixes: c5c707f96fc9 ("nfsd: implement pNFS layout recalls")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index a97873f2d22b0..2673019d30ecd 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -322,11 +322,11 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 	if (ls->ls_recalled)
 		goto out_unlock;
 
-	ls->ls_recalled = true;
-	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	if (list_empty(&ls->ls_layouts))
 		goto out_unlock;
 
+	ls->ls_recalled = true;
+	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	trace_nfsd_layout_recall(&ls->ls_stid.sc_stateid);
 
 	refcount_inc(&ls->ls_stid.sc_count);
-- 
2.39.2



