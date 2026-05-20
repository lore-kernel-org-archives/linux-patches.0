Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FBD3F7AA9;
	Wed, 20 May 2026 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300365; cv=none; b=DgtaWKW3IEaG6Plzdp98hIoQ1dqlZZYDozmAz5la3YvMOu4yIbtW8AIlFN+D0CQlUX+0e0ckil1yWNvS6gtgyE/t9ieaTXOQgAm9tf+iyglR962gTUpkA2BUvR1AdJzAFFvrgzAjYtQnMTcM6+dxO9gEv/NYomLJc8owsSDxiy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300365; c=relaxed/simple;
	bh=myL0ZE0dEBX2BtaklCf/iKd4JwvKFDqzGcqFHYLN/cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3Tc8Gu+t/Vzjfv6noEL3z3xsQWPOAO6P1UL2p3pzcM7aENICcaZQLmiuJOYvbguUYvIw+eRw0pmwTksM7aa5xbVeuH8C2nKibGQbis+pf2B4FpqyU2wKhJtknYmVS/7hqvVpbtS+XrMnuuoWZnDD2y8wOQlXqIVdAEsQoaYSW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMlGYaUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMlGYaUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EBF1F000E9;
	Wed, 20 May 2026 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300364;
	bh=5RHMIPM9Ff7AJ7fi1E90kB4guJzudk7p8jKPvFaWGIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMlGYaUaOUZTMh9IJi2pYC/6oa64ds38qbEBwBS+IiQMjkaFUmNLr83BzFTayYM4i
	 cRo7MHiF4mblWz/dnBPPbEy9CrdolJjrqcZ+IzfmwGI4URsdQRUAeg+2GXsOF+vTQF
	 ct6mGvzKNibp2FaO5jvqBNjauBeQCnTO8dPHz1us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/666] selftests/sched_ext: Add missing error check for exit__load()
Date: Wed, 20 May 2026 18:15:58 +0200
Message-ID: <20260520162114.394324483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 1d02346fec8d13b05e54296ddc6ae29b7e1067df ]

exit__load(skel) was called without checking its return value.
Every other test in the suite wraps the load call with
SCX_FAIL_IF(). Add the missing check to be consistent with the
rest of the test suite.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sched_ext/exit.c b/tools/testing/selftests/sched_ext/exit.c
index 2c084ded29680..b4a8dd630b550 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -32,7 +32,7 @@ static enum scx_test_status run(void *ctx)
 
 		skel = exit__open();
 		skel->rodata->exit_point = tc;
-		exit__load(skel);
+		SCX_FAIL_IF(exit__load(skel), "Failed to load skel");
 		link = bpf_map__attach_struct_ops(skel->maps.exit_ops);
 		if (!link) {
 			SCX_ERR("Failed to attach scheduler");
-- 
2.53.0



