Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76FC409624;
	Thu, 28 May 2026 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999192; cv=none; b=diK4a0XgtZk+DYiJo1EyvdmFGWo+jdVbutas8i6FmXi5Mo5bmKGSG7k8vBRPOMcDssd0vCswbKR2vo+K4DFSxDNcA9eK6H4pdVaBTj1BswtlUlJnqvhVF1aV/zaJGsCxltKxQJV9A9XgjBE8k/cE4iBqUxb8KeoExCP5Lw444Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999192; c=relaxed/simple;
	bh=HFpXvFF/LVlN+SOPtYlW1cYktliAofmtUL0kCuTbDOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O92c/OE0vCcXimVwSghau6AB7iwihLEzI9JAMh94Htoww+23IypqyTQyl/ux3O2vymwUY9gimpNojJEdRyd+f9mSspoRWq0WD7JzGHMwVanTBKkVYPpVcac0su1rC/sQuMaRxSnKEwBFyayPrs4n8A1PXTExVoiNiUI+907hLRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fy0wVGzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fy0wVGzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF88A1F000E9;
	Thu, 28 May 2026 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999191;
	bh=Sc+FJcmu/v2KQ/HQcBPQEb5xA/Z9dK9iHD+HZSjWdCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fy0wVGzEOsDS4SE91XPygGtcQw8m+Ca3hxmObr2UMTFuzfmazIkGDBfG0eLrlY3OL
	 Ko/Zm2IXKgUmY5leMDD0Y7MCabURcQGjO0gutCK9NzVpSXvyxXWkPTqpBCUbn/uLXC
	 8CaRbF0GLCxJVxas8r0EgvNqCDZyUQRqr7lh80Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 442/461] drm/xe/oa: Fix exec_queue leak on width check in stream open
Date: Thu, 28 May 2026 21:49:31 +0200
Message-ID: <20260528194700.324594317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
index fa90441d30529..449a431ec1d4e 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2048,8 +2048,10 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
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



