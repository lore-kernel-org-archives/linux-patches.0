Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032878;
	b=ebQaQ0hzc/H95RpPpKOHIrzkhy7uaztl8IJmTcDEYZ/iwOb/m+aCWn8ecoQZKPWkXGvB
	 exdxvi+VQQKML4O+yO1LFsVMRMA0Q3IvRAoqXlfOKK0HR2pcoTnZVL1tQIHQOLylX1wqX
	 Yhp5lwNsjJNY4egOxcVEJeQNZfw//QJniw1p9JNuSR14lzvAsKfwGmZ3n9mysSLsgQgaX
	 Wle+Yz3DOzLToPQc3wtuVT4WWhR862t+mpkZTp8DNA0OAx73RYDOraEi2yAqezrs57UJx
	 vinDD/XLtn846gA4U1tc6PKV4m4pFHf8eHk1zW1SsrlOKK+prHU4rWvgYn2tsPKkayQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhaHRGCmJmhYBhZXWzchGHKr4b3hcRUDruvIPMoN21c=;
	b=Kjy3P3xsexf2QghMACz6uVsOfZvlgF4fSaO0mqcJus9sGLL8hTm2BYE+Df3OXh4FkoT5
	 XQjPsbci2cE/hvqWZjjVNJhu4+Pu6IpPs51OU621BdWzN0eAcwsupEqtykwsRVAOcGCVn
	 xyjG5ge+TlVVtRUCA/6BvJ8I6PMNqJtCWBPSGk5/++gxvtWIg/+yPEGWL9/7CXFZbfHcb
	 MGdkEKrU30uW5MUDoH94OPx+YgyLErQcoBNaYatrrhWacYNfLVUoKSGO+5kBgeFZpOwad
	 FrO4SAfiJ2zLgpZXTDSuejXH2Qkx/lRZ2eeVgf5XrTl1FZJI3ukgkzOadlIjSn87YLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKtvC0pa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0E60A260F;
	Wed, 18 Nov 2026 20:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKtvC0pa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E51F000C4;
	Wed, 18 Nov 2026 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032878;
	bh=DhaHRGCmJmhYBhZXWzchGHKr4b3hcRUDruvIPMoN21c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKtvC0paAx9rMXxn2GIMaqeXsCj3wsK+In6pskF6k/jOA9w4mud3SSwgO+Sc+ithj
	 TIpTO2vcDd/e1C8dFnkh1L+u895JX9wy3FUDDxEbxq5VAtNSMiZo7l2MoM3PP2VphE
	 Vsh+tADW/tEmX36rji4NGffeQZeoH5rOucmPjYFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1569/1756] ceph: fix writeback_count leak when a bounce page allocation fails
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150112.156992619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 7807710d88ad03e7ca9b5f79f518f040db2a4e09 ]

ceph_process_folio_batch() calls is_write_congestion_happened(), which
increments fsc->writeback_count, before calling
move_dirty_folio_in_page_array(). If the fscrypt bounce page allocation
there fails, the folio is redirtied and never makes it into the page
array, but the count is never dropped.

write_congested is only cleared when a decrement falls below
CONGESTION_OFF_THRESH, so the leaked counts set congestion early and
eventually leave write_congested set for good. Every WB_SYNC_NONE
writeback then returns 0 and background writeback stops entirely.

Bump the count only once the folio is in the page array.

Fixes: d55207717ded ("ceph: add encryption support to writepage and writepages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902-remove-wait-on-page-writeback-v5-0-0b512e77e75b%40columbia.edu?part=1
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index cb791f468d376..3edb0f7097aab 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1387,8 +1387,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		doutc(cl, "%llx.%llx will write folio %p idx %lu\n",
 		      ceph_vinop(inode), folio, folio->index);
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
-
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
@@ -1401,6 +1399,8 @@ int ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
+		fsc->write_congested = is_write_congestion_happened(fsc);
+
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
 	}
-- 
2.53.0



