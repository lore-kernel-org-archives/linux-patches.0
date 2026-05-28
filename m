Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7FC2E7379;
	Thu, 28 May 2026 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001062; cv=none; b=AOfLc0a9SHxchEMQiG9T1aHqn40CLURbb3YrHQiyFF4IudZJUaxxnbUV4VNsALH4aHyJgtjgprkbL7bk1A5Qn7f9lEDgPIK8yyVVwuUeozzg8xBWwZPKTqyV9qlpLNKRpRBaFFOLqJEeO5dxIOzW5FEunzNsIndcK4eQWEayJCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001062; c=relaxed/simple;
	bh=XWWWDbc90aLtqSVcYcIUhjsfK/ZrWvffyYap3GsYO44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq5hyv8lrHBacY8i6cCV+I+XAxqo9RUmowG2xdWIg91VS/nxA14moJhQSyBMQ4c+Jv/jocnqh1/Q3LQVjiROm9QcfLMtvt83iKENdWj0dqTQH6STLUHlQpnn6dHmiyKvFKD2zV0QC1w5T5e38Fa657xGA0aIocusMo7dT84xQzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiXq53zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiXq53zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CAD1F000E9;
	Thu, 28 May 2026 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001061;
	bh=92kDdwGyRhrrjn3YpJY2tEwqhq3sdXjPN+G5ZJvlbYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiXq53zzOsp03DNf3VpfUV2A32ijUyyEGf9S2rmsCx/hgVvFYBPBO/ZdXKrx5w2XJ
	 WPqP/guWDfpHGCN37zz1wrHuY9jIuyl6gQ3dCPg4Vyxa+rlBFLnnIY2llxXHKLPWto
	 c4jH28fcb/qRUx6N/rsXypnZ7XJ6sl63DqpFs0A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/272] drm/xe/oa: Fix exec_queue leak on width check in stream open
Date: Thu, 28 May 2026 21:50:40 +0200
Message-ID: <20260528194636.531053236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 4d25342543c01310fc4e0cba7cb17c775e2421e2 ]

In xe_oa_stream_open_ioctl(), when param.exec_q->width > 1 the
function returns -EOPNOTSUPP directly, skipping the existing
err_exec_q cleanup path. The exec_queue reference obtained by
xe_exec_queue_lookup() is leaked.

The exec queue holds a reference on the xe_file, which is only
dropped during queue teardown. The leaked lookup ref is not on
the file's exec_queue xarray, so file close cannot release it.
This keeps both the exec queue and the file private state pinned
indefinitely.

Jump to err_exec_q instead of returning directly so the reference
is released.

Fixes: f0ed39830e60 ("xe/oa: Fix query mode of operation for OAR/OAC")
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260514203210.593488-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 339fa0be9e4a5d69fa47e91f4a36574224fb478f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index fe997494a6f99..5e38afc46e20e 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2019,8 +2019,10 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		if (XE_IOCTL_DBG(oa->xe, !param.exec_q))
 			return -ENOENT;
 
-		if (XE_IOCTL_DBG(oa->xe, param.exec_q->width > 1))
-			return -EOPNOTSUPP;
+		if (XE_IOCTL_DBG(oa->xe, param.exec_q->width > 1)) {
+			ret = -EOPNOTSUPP;
+			goto err_exec_q;
+		}
 	}
 
 	/*
-- 
2.53.0



