Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6BC3AAF7D;
	Thu, 17 Sep 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668801; cv=none; b=BxWN2SplTbpqMVRBilwA8ENr3dWo4u215jEsZBfLb/kUcDTofLGqojI5BiCDHKwFTzFJlx0IDoYNdLZlwZlvR9WWrZsHYjiEOTmI8ZoUD3Um+fhSpS9vhlKYw1/XK0yWQCQWFq8vwN5TkMo4vhYFiqEku0bNdJoVTwOAeB3SjS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668801; c=relaxed/simple;
	bh=s/weBjikucLmfa/1vVQfZDOJZMHCx1t5DRhfrTO+pSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fbu+Fze+3s20dbxq8xDSkmayj5G6W+i0IhHMubUIA+wVHG6cAGapyn00FJz7btvbM/0GPXXzPWfpmHU4VyU0H5tfKYEiZlGjW7jWcuKTQeingUW2hVPL6/8puFvMdEDMxBjECDIyBhGA1fhH9hspT1iFEgSDBTG7qbbT6Via+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5LxiNNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5LxiNNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8ED1F00893;
	Thu, 17 Sep 2026 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668800;
	bh=gInGIeGDvHHdf9PSN8SNXy+J9oiwXXKb8+fesFmTGP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5LxiNNjqHk1AL1NaABi6LFNWSyWoDOU4b8R8JBz7jfYLV2Ruasc2gW5A2oz6lwpP
	 42pzaftp7xH4+QmQqyQ9BOhSpcAeJ93CJR15X+3gcFoOxJdQEe5YO0Z6emfVA/qMsx
	 4sriRJ6VmHOU7mrYrFKlkdtEhogcLufPQoSwCqVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0544/1102] s390/ipl: Fix NULL deref in kdump without re-IPL parm block
Date: Thu, 17 Sep 2026 16:08:07 +0100
Message-ID: <20260917151553.484884500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 7f918871112e8e7c581e99eb8e545af4e59c8367 ]

Some IPL types, like HMC FTP boot or QEMU direct kernel boot, might
not provide an IPL parameter block. In this case, reipl_type_init()
selects IPL_TYPE_UNKNOWN, and reipl_block_actual remains NULL.

kdump passes the re-IPL parameter block to the dump kernel through
os_info. Before commit 3b9678472bab ("s390/ipl: correct kdump reipl
block checksum calculation"), the os_info entry was added only for
IPL types which initialized reipl_block_actual. That commit moved the
os_info update to machine_crash_shutdown(), making it unconditional. As
a result, set_os_info_reipl_block() dereferences reipl_block_actual for
IPL_TYPE_UNKNOWN. This may happen to work by chance when address zero
contains readable lowcore data and the resulting empty os_info entry is
ignored by the dump kernel.

Skip the os_info update when no re-IPL parameter block is available.
Kdump then collect the dump and reboot without setting re-IPL parameter
block.

Fixes: 3b9678472bab ("s390/ipl: correct kdump reipl block checksum calculation")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index c262d493a4cb1..ae363fbe83fae 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1156,6 +1156,8 @@ static struct attribute_group reipl_nss_attr_group = {
 
 void set_os_info_reipl_block(void)
 {
+	if (!reipl_block_actual)
+		return;
 	os_info_entry_add_data(OS_INFO_REIPL_BLOCK, reipl_block_actual,
 			       reipl_block_actual->hdr.len);
 }
-- 
2.53.0



