Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D828A3B6BE5;
	Thu, 20 Aug 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239301; cv=none; b=F7gdir12XXrM9D9L8Vsq8gBr8TY4c5Afnv0t9oB4WkEQDMYsQFFHpgpLUdoME7QND6yYkTDK+uW1CaB69bwJiKm/6UNm010XhX9YKnbNLf2HELNfsB78Bz40RY+WcSR+LMp2WkqTchGnTfxXGyZlSlQkGgDCdIUuQDq8UciKAgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239301; c=relaxed/simple;
	bh=jSUHGDaKe8mBJCPj36UbynAxOWrEqJ4ba6E1kMVBH5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5jqprQxVAKROlQqYqj2S44MsofgMGnGM3d9uLnp/gpXigT+TMvn9i5mK+4THmr45UhInMhM7lMMEFSRnAZITD6DW+cgxLutAiAGD3+wDFOk04AH7XEKrT3Go4xPvsWtjg1K9wylkTom0LpCPlakIYfZc0XrbjhX11UIii9pKqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSq6HhX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSq6HhX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D54B1F00A3A;
	Thu, 20 Aug 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239299;
	bh=vonDLVYsfGOOthabE1BCDjmyZpFC+Qfw8CHiRAr3/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSq6HhX7xCaCI+SwNSwpGFEkdC8BWtAeucVTgMlwu/xP3Ol1J0Yzbugz0tGkFXseL
	 8PuZMXrMlNKSD5heq4mqLCW7hqB3mJWYkQAPvfiA5ab9efwQ3SPEtGy5CytGQmAjT7
	 ULcPRv/4FFu+dPA3mp24+8vSh+PIUaoLmtYRzuqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/217] drm/xe/oa: Fix sync entry leak on OA config emit failure
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145243.901126644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index 98df9ee1cac39..ff19553e8843b 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1567,6 +1567,10 @@ static long xe_oa_config_locked(struct xe_oa_stream *stream, u64 arg)
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



