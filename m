Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577E1305E3B;
	Tue, 21 Jul 2026 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671660; cv=none; b=MtXQSQEnC5+w5OCk0OC0pZUdkrd5/TrxdeKaUjhvBIxDf0FKfzZAZzsllmoMYWSVtctHOoL23zWiLcttXkOOs3q722Ot6Sq8NDaGBx3zoZqCVYjJEor0CWReBPTJKbTbRr46Y+69hj8oy4VM7joC74SmhpQS4FYOhZ0YxSpYjoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671660; c=relaxed/simple;
	bh=Dbkg2Aw7CJWXm6wUQuLlw7NVyYn0VDGSS+9cEOvDN3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpb8z9FtLNNHM+L8hLg67803/sy8oCPx3M6H/417jCV7aq9XQnJI+YuvPUolCwWtq66lj1C7AnVh1nqyaTIGpE63Yfrz4sdIQxZdLzVqYoQdfH+Um3hqqRZVnrkzYytnn7ot9zhpWaaJrnCnF9znVytvPGzpctrdB/UimZ/8SbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E81A/LNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E81A/LNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB361F000E9;
	Tue, 21 Jul 2026 22:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671659;
	bh=7yNp0yh7zrwW3TxpG/sqXk+dUemLe3ML3J/w1Drzr4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E81A/LNeqEqtvSXD+L01ifFtzHe5lEdImqzAXcQ8TmOpl/wvqVE8EiCuXOa5v8PGN
	 muVkidKsVG7smuLQNNFXB3qp/LQl3NgodiCMb0rNCDaGjmqBsJNPl95UcTUysCvWar
	 VIQxd3vgnmUtZapYpamyjc3Tia0M7AQxMf+mZw5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/843] tools/virtio: check mmap return value in vringh_test
Date: Tue, 21 Jul 2026 17:19:25 +0200
Message-ID: <20260721152413.442713858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



