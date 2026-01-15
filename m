Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B4325228D;
	Thu, 15 Jan 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496088; cv=none; b=ios8QP0J04ik9vBygL1v+EEkFxgXO+S+JbxlE35sFttE66VLOpMleTNnnd3OMBHI+R04S55aHpkGDxoY7W0Lc1TnfQAmAk/TvUVxv9N5MnwBu/0RF4HnrfEl58gOwgYrjDH6/r11M5MkDD9AFFfURiKjrDSyTsxWrzWPqTNjQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496088; c=relaxed/simple;
	bh=WByh/SD5F8zKw81FPBwC4z50bxDU9epRXNNFa6EjmCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUNmNmKc5w7I6cAhry6+XSbhRk/rCa8n7wHM8ED4XuWELetRSIKNAj3yz7lSwCHcfKo8I9Wzuhvewm9wqFSO8HarqwuENxI37Ui+SPta4VKc3nUWiNIjuclutArzb7/RWTgy45Kmm2hFdYQTDshjKytRck6khLPvff29DiepTnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVSa/Oc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVSa/Oc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67275C116D0;
	Thu, 15 Jan 2026 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496088;
	bh=WByh/SD5F8zKw81FPBwC4z50bxDU9epRXNNFa6EjmCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVSa/Oc/7BiWdcC5nWAROCQxazHPyL/WgAIdDH1vuiFk5Nv4yTRzgnsNKzbGaN2Aw
	 7AiIim1NpHlpwJA+7htcD8LuBWwUEv9ylrmgaNHJgu64lsPuchNKV1vwTKcWcIeFVy
	 gTZ3hNOdK5GwSdpjXuvdiR1eqhQIfNVOUR3sPEPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 040/181] libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
Date: Thu, 15 Jan 2026 17:46:17 +0100
Message-ID: <20260115164203.775563365@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit e00c3f71b5cf75681dbd74ee3f982a99cb690c2b upstream.

If the osdmap is (maliciously) corrupted such that the incremental
osdmap epoch is different from what is expected, there is no need to
BUG.  Instead, just declare the incremental osdmap to be invalid.

Cc: stable@vger.kernel.org
Reported-by: ziming zhang <ezrakiez@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1979,11 +1979,13 @@ struct ceph_osdmap *osdmap_apply_increme
 			 sizeof(u64) + sizeof(u32), e_inval);
 	ceph_decode_copy(p, &fsid, sizeof(fsid));
 	epoch = ceph_decode_32(p);
-	BUG_ON(epoch != map->epoch+1);
 	ceph_decode_copy(p, &modified, sizeof(modified));
 	new_pool_max = ceph_decode_64(p);
 	new_flags = ceph_decode_32(p);
 
+	if (epoch != map->epoch + 1)
+		goto e_inval;
+
 	/* full map? */
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {


