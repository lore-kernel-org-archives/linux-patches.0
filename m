Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22335CB9D;
	Wed,  3 Dec 2025 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779208; cv=none; b=s4pbIE+vuvgxZvSkM+iR1FKlA+4Ya+m09kWTCEtgRZmjOMpm5fhHMh8vdlDHOtxrzu/PQEUkPA9V7FU1ervdLykbJP5r59TCEIsATiu3g3gdQShFWmeoxSP7ztc7GV2/74kyis3vy78HY8jZtJKHqpBMFgDmovIft3f+1qDqXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779208; c=relaxed/simple;
	bh=KYISZawtX3CjV35dJmGYjJ36FYJR9czbe5mhyJ+Bu0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKhhpex8T4dIrCpw5EYw1ADjUJ1MWT3rNIRo//9A1RSPKAM5+Ol8ew3DK7wPVyK9QlBTOhVn1lbWmdeFruX28YNQL62lmeGPHC9sTZL6GT4APA80xmKv65vhROw6UTky+E44diwUFzTNVvwJ6PuVo8rYhEcler/F1E8iCwszg9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9wwy598; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9wwy598"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78168C4CEF5;
	Wed,  3 Dec 2025 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779207;
	bh=KYISZawtX3CjV35dJmGYjJ36FYJR9czbe5mhyJ+Bu0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9wwy598p6beHz+ZMJOhqatSdVJV9D9rq0hL6WA+jYlPYi/RVv0q1pC+7zU334jzO
	 iNIS2gDhgLDmLEhDPJqnwfxp7GhgpmVZiWApeNshpdjjHzYvs2de6QJIn88BPEg6Z8
	 k2+c+p2pB6ofR3xEo8uwIivNVHcdj+/GL92xU8Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/568] drm/amdgpu: Allow kfd CRIU with no buffer objects
Date: Wed,  3 Dec 2025 16:23:10 +0100
Message-ID: <20251203152447.611509509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit 85705b18ae7674347f8675f64b2b3115fb1d5629 ]

The kfd CRIU checkpoint ioctl would return an error if trying
to checkpoint a process with no kfd buffer objects.

This is a normal case and should not be an error.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 890c2befe7dce..77af134842feb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2480,8 +2480,8 @@ static int criu_restore(struct file *filep,
 	pr_debug("CRIU restore (num_devices:%u num_bos:%u num_objects:%u priv_data_size:%llu)\n",
 		 args->num_devices, args->num_bos, args->num_objects, args->priv_data_size);
 
-	if (!args->bos || !args->devices || !args->priv_data || !args->priv_data_size ||
-	    !args->num_devices || !args->num_bos)
+	if ((args->num_bos > 0 && !args->bos) || !args->devices || !args->priv_data ||
+	    !args->priv_data_size || !args->num_devices)
 		return -EINVAL;
 
 	mutex_lock(&p->mutex);
-- 
2.51.0



