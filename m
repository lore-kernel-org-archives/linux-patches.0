Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21D3D6CA5;
	Wed, 20 May 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295078; cv=none; b=TwqZ70p6LLVXYcNLbwFBTWrmF1x64ECNJrtn/YJ7vddIE5Mud3Samd40jDm2ovZrhkFOIFu8Wu11845phtOepCwHw68HQpOxQIxXgVf5MdSVNHs8a5i4H6rTcXOAOiAXM0IHCi6udoSao7o3gtgEhEmMqwObgBLCtNiH1EV2tM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295078; c=relaxed/simple;
	bh=7VGdNyMgn8efsaoWOZ7lFUQuOZxepuG5LTaNfuFPjWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX2uSEUF0e1COy4pk1sU5TD0lz7A2Dps+HumA+jk4kIvz0gonKZoafRE0mmkf3CeHQGpOZxNtm32fIgpAVl9mXDOrw9/JSmkCs06zwnCfxDx6gGWC2HYHOpH7DxppLQoa1NFpQi0TtONU/i5dh2tz1KEgObGiYlyxfqGv5f2jIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hww0axJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hww0axJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E88C1F000E9;
	Wed, 20 May 2026 16:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295076;
	bh=N1zTPwrQScrai0NqInlBo6qpMVAl8wya+eiLJGEUw0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hww0axJ/Qf/3zW/zVe32u2zqKvcIOM/6t7mFeywnlg4WImP7uoFuUPomeFV6xL+xr
	 1ld3ddnIGbA2Zxjk/zFCaPRaXJiAj22JbKohoO85ZdE7qgQDonXKW4QvQ66e99gOe3
	 4aVtBNFMKnKh9Qw4O4lgaHgmlF1rzBN2+UrJGJJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0282/1146] selftests/sched_ext: Add missing error check for exit__load()
Date: Wed, 20 May 2026 18:08:52 +0200
Message-ID: <20260520162154.599273312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ee25824b1cbe6..b987611789d16 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -33,7 +33,7 @@ static enum scx_test_status run(void *ctx)
 		skel = exit__open();
 		SCX_ENUM_INIT(skel);
 		skel->rodata->exit_point = tc;
-		exit__load(skel);
+		SCX_FAIL_IF(exit__load(skel), "Failed to load skel");
 		link = bpf_map__attach_struct_ops(skel->maps.exit_ops);
 		if (!link) {
 			SCX_ERR("Failed to attach scheduler");
-- 
2.53.0



