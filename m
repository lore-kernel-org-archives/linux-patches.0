Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4B4397E80;
	Tue, 21 Jul 2026 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666059; cv=none; b=MKPzl42cI1EZxdtL95UwFwRDyUdCuYIebPQnWH+BdGE3q6jfrx6rtkpSf0EhOblJKVqQLi0esiB6LWmsybKJsScDO5u0K1gzoGdWvS4f45AGh/RHy6u3CI5ihk8IzUNJFx8OemVfz70bCDDtYSXdDEvu5Yo4/CKnyvKda8igKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666059; c=relaxed/simple;
	bh=ZqM1N8dJyiYSvNToOSnikNSBDfbd4GNLtJmuYir9ixk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9EGQX2Itc9fJCAOezhv3fSDqZUoGmrsipEpXqeS+MJhc44O1yJECxec+i82eSl3WJqi60paY63UJL+Pd4z0OIbwGqJQxdwpA0snWm7lxsRiprS6+2LOKZAiWN0HwERYNtloTTJfJn+y354pdBNr8LAI5WCTsXsHF/fBxOlZ/mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaB4Cdea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaB4Cdea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD91F000E9;
	Tue, 21 Jul 2026 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666058;
	bh=wqZgF1kxpBLFCsS+guBeDih65kKKegbGTdnO0M36FRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaB4CdeaSiAvwVY0r1xAbwPTNJzTlmesVSUzBYtkU6oWWBcqo+R1poWNFaFq5Ysko
	 sbJoLsFOIPeow7GSFrzvUSFYweJWPLnrJUuRT8sWiYly4iZ7WZmI6Q1JY3eFSLkRZO
	 PAjLjbXWbtWZ25cDhaE0B+WCycuK+K8hsFf0KDNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0538/1266] tools/virtio: check mmap return value in vringh_test
Date: Tue, 21 Jul 2026 17:16:15 +0200
Message-ID: <20260721152453.905082839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: longlong yan <yanlonglong@kylinos.cn>

[ Upstream commit ec6177dfe98b9be1c3ede6c0dfe4394ea2a76959 ]

In parallel_test(), the return values of mmap() for both host_map and
guest_map are not checked against MAP_FAILED. If mmap() fails, the
subsequent code will dereference the invalid pointer, leading to a
segmentation fault.

Add MAP_FAILED checks after both mmap() calls, using err() to report
the error and exit, consistent with the existing error handling style
in this file (e.g., the open() call on line 149).

Fixes: 1515c5ce26ae ("tools/virtio: add vring_test.")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260605021446.1611-1-yanlonglong@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/vringh_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 98ff808d6f0c2d..16f3723b467129 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -159,7 +159,12 @@ static int parallel_test(u64 features,
 
 	/* Parent and child use separate addresses, to check our mapping logic! */
 	host_map = mmap(NULL, mapsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (host_map == MAP_FAILED)
+		err(1, "mmap host_map");
+
 	guest_map = mmap(NULL, mapsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (guest_map == MAP_FAILED)
+		err(1, "mmap guest_map");
 
 	pipe(to_guest);
 	pipe(to_host);
-- 
2.53.0



