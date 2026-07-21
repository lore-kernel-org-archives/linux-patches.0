Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEEE46EF86;
	Tue, 21 Jul 2026 19:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662068; cv=none; b=VQo3in7a7R4J2shJYuedh6QZLELIWWoIjwaXW0556ti+rKzFeX5gBr3aiUio11/QhqIAh94op9n7tJ5qnB9zle+gUEniMk/wi823v/tgUaL74fRuN3cyBipikmvsxhyhJzLxI/E6gFmdPvMi9kjvfG/LAdLiz/kCZ8wmhOdspX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662068; c=relaxed/simple;
	bh=rPUcO4AsRxiOthf6Zx4zDdnXsdntmzz8CdhphIDhb5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWdtRXx6lPTR9RhJtvAvsvK/BhzbzJJWLUNj/U4/1fzkubgH4sGQt+aujwVUEqT/Uy0mDNe4K6thHHhd+dHnV8ZKtXPmz5lCXvvfQ4F1knr8tnnlDhz8lSgqAaLib2xF6WPtXCX/ZzyJ2pBLreaH4eJwv1d/Vf30Xzogb64K1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnXqaZxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnXqaZxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E601F000E9;
	Tue, 21 Jul 2026 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662066;
	bh=+ldpt3sEYZjo9JEi66r8M0uxJ5PDb8iez6DY6LAvsD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnXqaZxcC0la5w9FnF2mD5bCHBBeBbiVk9TbYgsxnbo6IOQO1G3uj964YVq/VGpAr
	 F+I2ozXOV8gNGKZWjz8r+I0jVvBW5WypJJwhj9FB0QQnZsB/e8CDOisOkWfFhhgFb2
	 Fl/eN8f+EnlWwPiOl8ctx9n0cSq1WmgUhIZOQclI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0303/1276] tools/virtio: check mmap return value in vringh_test
Date: Tue, 21 Jul 2026 17:12:26 +0200
Message-ID: <20260721152452.874302505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



