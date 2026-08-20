Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0DD46D091;
	Thu, 20 Aug 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247288; cv=none; b=hmKpdr2woTb9bhadOJ1tT3zgicrVTiV4sQ4R+dnU2OrdHfMY3+j5nslbBNRY6dNggq5w3NCpk9u/dNkMChlDpY3h1F6RzR5odKF+67fx+jI9TegT07HdcpX60nOEwLC67EZxcE492QboyqbVJWuG77zfSJx2MreJ6vTFHgcilLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247288; c=relaxed/simple;
	bh=/ALMSKNZJPZgRGkUIpPvy3g1PBODxvHpfC7eQRHTJlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGq6PLN/y6LMGGUUEWqIudTZwPF4qFH34RRkr6QLbM+rH7KN4TMbM+MDFGO08ZWPBzYIb/MNAhhCSTFS+NvGm61xQqy6g3tLB3+KUc+msqkATNNNPnfXJnwNPzbSJnreWPkrNL/qTJD2Da4eyw9VjYURsr80jTo9Q0yL8CSNelQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1cvrKEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1cvrKEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A871F000E9;
	Thu, 20 Aug 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247286;
	bh=KbvVnwU+bmVZQ459rlP+5U8GStOzL+yZxhCjsaaMezo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1cvrKEx2oXrsYnRax7XU50KQ2oIB2Al8+YT7rCUriy/SDNKoqgs4VKumhBlQG5PC
	 qzL1HW5hn3+LYdQ5bby5Q29rSMSvBmBQvfmD0BFHM8rOipkPkARFQjiw9ea1Dgjg0P
	 AkMH6lWxErbC6pvVEgaOhJ4RoNDEcnq3bBhj1gxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/220] drm/xe/oa: Fix sync entry leak on OA config emit failure
Date: Thu, 20 Aug 2026 16:56:43 +0200
Message-ID: <20260820145229.934908939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 476d887749a9b..ad55c7f2b09f9 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1483,6 +1483,10 @@ static long xe_oa_config_locked(struct xe_oa_stream *stream, u64 arg)
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



