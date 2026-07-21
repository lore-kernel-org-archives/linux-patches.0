Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5746EC84;
	Tue, 21 Jul 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656578; cv=none; b=nRy5m18IorLc1c8qNDrwWXt4v4lqonNaN77HY3grxBb2p9q8QGoeAckhn0CJ892uiFyBNwQjUhs7QFbBOhxa7YmADMtMXdzI3BHUyzcalSJrEqWuTO3p/O25GnBFaZ7pup86/rHZMzKzBlnXheGdzZIHUfwfAiIQiB/vbjCZsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656578; c=relaxed/simple;
	bh=lZuRIthj7uvmfq5DanRV1cw0eYdz+JogLa0FgVnwChM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgA7qNuF/KPYqwE9Ys/5nWV0hALl4PnYzp4zpq9+KOHfQSO8uGJb54Lugts2KuixWc7FbiXG1ofoCZ3v1gZAEH+S0pZHto1GH4xfdvf+h4dXaxH7MbUDcM+JyTLZp2ZKS+P4VEqjtnYh6xG8ox7qMscHDcbm1BjZsF2LkqgrEUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZm2oX62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZm2oX62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709FC1F000E9;
	Tue, 21 Jul 2026 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656576;
	bh=GP3/wL+BldZ4lgyn0zGwpFkRylNYtxQM1l557u1DwBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZm2oX62VX2rPSa/ijMrLrH6YzEx9DGJbgdW4XuYkFHtgsZEuq6aariKDh27tTXkb
	 tTSmbw4eEFE6eFosz18s6AsLflOwXvEsw0NSn4aL2xPFEM5GIRyNFG4mUSWroFhhku
	 Dmxrh2gUpmCw9olq/q7a4XMeKC246XMxCosyMmXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0440/1611] tools/virtio: check mmap return value in vringh_test
Date: Tue, 21 Jul 2026 17:09:16 +0200
Message-ID: <20260721152525.185105765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index b9591223437a64..5ea6d29bc992d2 100644
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
 
 	pipe_ret = pipe(to_guest);
 	assert(!pipe_ret);
-- 
2.53.0



