Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447EF22332E;
	Wed,  4 Feb 2026 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219061; cv=none; b=M+ZkIU2+p4bZGB1//yTH78w/8DRKcEQYuQMjufsf/3SbE+yD5OoMKMpiqNkJDd0dMNKCVI6OL/qOsEJaVoxaAWXhtQU17+YfCTgViB6U0+0l0kJuJVRj2WO3i6zG/LALpg30l3DdY8xk4zHsPBMYYaoEW4oF81ffA6dnZd40ZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219061; c=relaxed/simple;
	bh=iXIGT5fuAQYVzUsqdWSvEKJT5e7bCbEyDLRaThxH4Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2F9dGTJSjvoxd5GpEADPJ9TcBCjn4ZxaeIhNRM/1GUiKmU98fv9WSukbXYBnQuDDOowbF8ouB0+YbQYhbiaURFgNdAPcGHbiA+sMidaOe0CqoJAl6iMSYoUloCmh8Sh4DWxp35V4q9RWwna1km6L8Wl7O92h5LxqKu13laPKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIvJM3EA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIvJM3EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FC3C4CEF7;
	Wed,  4 Feb 2026 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219061;
	bh=iXIGT5fuAQYVzUsqdWSvEKJT5e7bCbEyDLRaThxH4Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIvJM3EAx+GzrUrz4uVVAOpUejTfg6t6NE+m3pfKRtXX/2CQilgcFeWZHbTNPdOUy
	 5rwx5wx4q3xd5W6Lu3wYrS78R7jtu9O2WNZzIDv0n2SmcK9ExcOTOQBYy/gjQWA0As
	 /N+/tWM4gq+rt3wPCbOYRtykh7/hF0HMrtYNTF9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/122] drm/xe/configfs: Fix is_bound() pci_dev lifetime
Date: Wed,  4 Feb 2026 15:40:36 +0100
Message-ID: <20260204143853.798466033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit c1ed856c09d0d730c2f63bbb757cb6011db148f9 ]

Move pci_dev_put() after pci_dbg() to avoid using pdev after dropping its
reference.

Fixes: 2674f1ef29f46 ("drm/xe/configfs: Block runtime attribute changes")
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260121173750.3090907-2-shuicheng.lin@intel.com
(cherry picked from commit 63b33604365bdca43dee41bab809da2230491036)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index 1396634231857..6688b2954d20b 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -258,11 +258,10 @@ static bool is_bound(struct xe_config_group_device *dev)
 		return false;
 
 	ret = pci_get_drvdata(pdev);
-	pci_dev_put(pdev);
-
 	if (ret)
 		pci_dbg(pdev, "Already bound to driver\n");
 
+	pci_dev_put(pdev);
 	return ret;
 }
 
-- 
2.51.0



