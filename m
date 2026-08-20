Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB26C360745;
	Thu, 20 Aug 2026 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238650; cv=none; b=DsulVlKvH+iwK6wwkJYfgwf6cGbABqoAjE8b7Lw4bHD2A9i3cxERf+7Mw/yliZtQMDOGc088YePVwZZCWcVQtjup4nYz3qFdD96ZgpyVPiST3dM/LWHlky5iOLvx4KfwWM2uYjCRs2/xrb/ghRqFr6iz5uKPwezMJdPJwzD5Yb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238650; c=relaxed/simple;
	bh=ix0lKegvd5U0hPb0ibYDM2Mt0h3KnOWl2eGYhrZ/L4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4dwaAFua13JDcISqXkSaLl7pkmsluyXwupa9ULaj6zha9eGIYWxqh12Wq1BkJ62W+G7u5EsFIr7rEVcfPAEF5XV6aj6ha4psaBfeADFwaWx5L0Mo/WrVqL0b8Kh0tX9EPsvjQwp12JSTE3qbkw8+p8axWbqRsc0RnoDG4fMzIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DuUl19/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DuUl19/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D971F000E9;
	Thu, 20 Aug 2026 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238648;
	bh=Fpf6tXvscBxhzNWAlo3+YIAI7c9KqN8F3uZWBY/H2CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DuUl19/hEXlkXuoeIq4OIa+nSImkc9FsDSljzQMjfSRXC+2tNj3F8TyoKozjkSJK
	 5IMfJXJnN8fsZlclXXTBGnI3hS3kMsFS8TJmq12kOfDJPav38VpDeq8CPhxCzNv2ox
	 ybxvqnf+eBJg0niqV+cHpOeMAifw5I6FGQ1+mmWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 220/228] drm/xe/oa: Fix sync entry leak on OA config emit failure
Date: Thu, 20 Aug 2026 16:56:02 +0200
Message-ID: <20260820145251.749307482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 8d33c4987cd162527375a3905017ae129ba7c3fe ]

xe_oa_emit_oa_config() releases the sync entries and the syncs array
only on its success path. When it fails before the point of no return
(fence allocation, config buffer allocation or batch submission), it
returns without touching stream->syncs.

The stream open path handles such failures in the caller, but
xe_oa_config_locked() propagates the error without any cleanup, so the
syncs array and the fence references held by the parsed entries are
leaked. The next config ioctl overwrites stream->syncs, making the
memory unreachable for good.

Clean up the parsed syncs when xe_oa_emit_oa_config() fails, matching
the cleanup done by the stream open error path.

Fixes: 9920c8b88c5c ("drm/xe/oa: Add syncs support to OA config ioctl")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260731011932.3426219-1-lilinmao@kylinos.cn
(cherry picked from commit 8af97b3da2cfce04e6b457c6eb17ed3c1daf912b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 5111c6519c6db..3ecf4df868eb6 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1568,6 +1568,10 @@ static long xe_oa_config_locked(struct xe_oa_stream *stream, u64 arg)
 		config = xchg(&stream->oa_config, config);
 		drm_dbg(&stream->oa->xe->drm, "changed to oa config uuid=%s\n",
 			stream->oa_config->uuid);
+	} else {
+		while (param.num_syncs--)
+			xe_sync_entry_cleanup(&param.syncs[param.num_syncs]);
+		kfree(param.syncs);
 	}
 
 err_config_put:
-- 
2.53.0



