Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFD015749B;
	Tue,  9 Jul 2024 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524533; cv=none; b=U/HyLz7vquKtVBjTBhzSYAKmOooMmDGmWmuwkszi65etQ4AneqsyoKwbiAReDB+efst/unrKU/xZHMXyo4qUTuifA/uoUUFtT+1qHmhqjkd4dRc2P8y3FPxU3gq17v4N/CXwanTjrvXrk1P0jJ3m6A9W1enELCIZxh0XiYHf0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524533; c=relaxed/simple;
	bh=kyOzykdjX/qUTl64Xn5t0ksSvRiSMPT+n0a1T55tEqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NibkY3LLQzWnyviXn2uDgt8vvXRRIo4xQbhyA7ws5Ks9bICJisr8rDkNF78xtGWuqJu/47R1FS43eq3huNr+BXiZe9zoUxf9wFr/H2oKTTm4NE57gWhSDDgJEq7q3ulYlDlxsnDWmJ9IOOdgFHX1j1EUrD7Ge4hVry2fMp+7hL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujA0g9VK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujA0g9VK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE0C3277B;
	Tue,  9 Jul 2024 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524533;
	bh=kyOzykdjX/qUTl64Xn5t0ksSvRiSMPT+n0a1T55tEqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujA0g9VKFk5pLW69pK7BExmq2xkIKEU5/SAQHBQSxzOih/5GI8FtnvR/F1G4v3s3W
	 jDtVnv5q24ymi0yA5TlLa5fWSrRbFhDtavOp4J3AINiww1VDSvm5NZKbBiQLUdg7Fm
	 9ngcmThy0R+omInzK3bbCNWbA4WD++jVqNl4+NbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/102] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue,  9 Jul 2024 13:09:38 +0200
Message-ID: <20240709110651.962623132@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 1357b2165d9ad94faa4c4a20d5e2ce29c2ff29c3 ]

[WHY]
ENGINE_ID_UNKNOWN = -1 and can not be used as an array index. Plus, it
also means it is uninitialized and does not need free audio.

[HOW]
Skip and return NULL.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index e2f80cd0ca8cb..83898e46bcadf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2146,6 +2146,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



