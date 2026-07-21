Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4AF372050;
	Tue, 21 Jul 2026 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649592; cv=none; b=dVaN7pQbgSvxou7GEJoA+FmJqKTqa40DV2yFEnnyu8sjxE+aomiVJzAEUY1jz/yoSTtsNY3gUJgRe7p060zw3rIiKLysFRQICkKzcmcCayQL6KZD5UuYRL83gxk3JuaoAFSTNJN7agtnb5eA516UElYVXLXJwwUhoOU82bDjUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649592; c=relaxed/simple;
	bh=kbmB952KbBjCn4PtHwIUFACus9WwIjD+fwDiHtx7BCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghKkW8W+gEpqKf+XxAULH9hMLY0nktwy4VM3DcMZh9lJS349C1xBctCCs58rnDF0XI6djB34U2SWckx5I80b4sVjHW6NV0Vc4VCsYgvIcFuy2YEcCvBc3IqRuGdSW5S5H5bwi7HCiPVM5dCvXhQljEF5tx8xfe+vUXwBMmyYu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmeTEP8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmeTEP8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746901F000E9;
	Tue, 21 Jul 2026 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649590;
	bh=3gNwzIIF+n9sT5XTPxsXyT2dBT89vrHTfNy50QgdVM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmeTEP8UEaZCNjKQHfi85cg0MU3fW5vXk8QeNiPHz8cWdNqM9L/t8dJNo0gLDxrU9
	 9xVkujE33hF0Ycj1697VZmD1UBw8ylFI8srarnvccFipdGoETtZAOVD6hkEOD54T/b
	 LT+PTkL9kA3sXSi18wKXixyPBPnmYRTEPHQDov1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0634/2077] tools/virtio: check mmap return value in vringh_test
Date: Tue, 21 Jul 2026 17:05:07 +0200
Message-ID: <20260721152607.762784357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



