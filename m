Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03981D0492;
	Tue, 15 Oct 2024 11:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993325; cv=none; b=PdJ/J9Tij+XCWHHwrKy+nInqm8JTaGF3YVYT3nTAV79s3jugboCO5QnhG3P7VDXKLkgCR2e75+YO1ThfC3L1QrNh9cxOm+HJqnpFtV6sdR1C4UuBilvPvx9PnKlyU7BT+cP91un0NDQF5QhWh2jjo8enccaUHWGOsIU8ub+7Shw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993325; c=relaxed/simple;
	bh=rlRLmArb+FAsOLV3Za44tsVWhLj/UU1G47l80YtsJSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1lCH1Xyv9GzWNgUaJJp37JCmA5vx97d5Stkh1489v8sFRWXxK9shHmS1Aqvq27brxYBAm3IgM0AliTu53gVOdOIWSmdex/TZYFF3qFhVmo8G5eEJDwmGjqx2AkKXgxi6EcWD2bN8I2j3ygjm5Sc3utiuVZBgyuuRUAxhAvYafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeuSyIsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeuSyIsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F50C4CEC6;
	Tue, 15 Oct 2024 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993324;
	bh=rlRLmArb+FAsOLV3Za44tsVWhLj/UU1G47l80YtsJSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeuSyIsplbDAzE7X4Rf0RIb+2Nn3AADmJ1QMjNEaFGTnDinc3vZMuGRBf6W4bB94h
	 j9WDuA5YyKIrSyWAY609HMDHVJv/nNr1Qcm3u1yZgwehbi312bmaQs+7wT8yKkDnc4
	 PLQooNcxuA/3BBR45UBiMTsi6vRoQb2UT0lEfKHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/691] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Tue, 15 Oct 2024 13:25:24 +0200
Message-ID: <20241015112455.268905487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b218a26291b8e..e1096ca1a39b1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -95,7 +95,6 @@ static int ceph_set_page_dirty(struct page *page)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



