Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6931DF266;
	Wed,  6 Nov 2024 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895300; cv=none; b=ckXeVEbnh1haUvjs75asky2nZAD8eEp7troskRFiD7m7s04Q1wfP6gaxtoR+fjKBqBWpx+O/nO3xRs833JuiKjZLQcfvAcXBB10NyH3cC5swtJeEIT6mKekkiksJPoCUEP/RKneK0eKyFKw6KIC2Xe68aZJD18Ftx18godmxFtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895300; c=relaxed/simple;
	bh=Vj2UrazLkGkZ5JFz6wyHEWOAn86DeYEki/oo6x0Om1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXyrItwEb2WYzZGkVHfzsRUThOZU2kWAhNPKVtiS0mXSu3k4hyBe0MVokbQy72G2EmejZqcdSa0HORagQJxAV6VqaMS3/GkyQqdYzni4sjPHgKRxx7rehJknGGfrIdV9O5FsKPFl+XyZjLcpoRpLJ44gMbeXM+vzLRtwXjOb0sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+XTA658; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+XTA658"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCBBC4CECD;
	Wed,  6 Nov 2024 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895300;
	bh=Vj2UrazLkGkZ5JFz6wyHEWOAn86DeYEki/oo6x0Om1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+XTA658TtBoHyOhQqTrvOvDXyFsONArGkyVUDrps9Zr6vCpGkB68WlHW0Jhcxu9F
	 pgghAwRGbmfg/UgIQPe9jpI1/ttIhVherBEASGel5Z4exPPFCp62DkGsqaTAXTGdzi
	 tq3eu5eQwzEIlyXTxxn+621rL9bhjTuSg8/zagxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/350] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Wed,  6 Nov 2024 13:01:02 +0100
Message-ID: <20241106120324.218372595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit c08dfb1b49492c09cf13838c71897493ea3b424e ]

When doing the direct-io reads it will also try to mark pages dirty,
but for the read path it won't hold the Fw caps and there is case
will it get the Fw reference.

Fixes: 5dda377cf0a6 ("ceph: set i_head_snapc when getting CEPH_CAP_FILE_WR reference")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index de10899da837c..98b17992524b0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -88,7 +88,6 @@ static int ceph_set_page_dirty(struct page *page)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



