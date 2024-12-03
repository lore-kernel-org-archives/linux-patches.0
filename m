Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A01E81ADA;
	Tue,  3 Dec 2024 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242238; cv=none; b=aTBCjFeKE6R23pRBd0jajxmS3uR0UC9jyLsyxLMztD1PSEXqouF10Pn8/e1RODQj4U3NSpX5OkHnHU5OEwiu4G8aiYsJCzlAn/7SJ19LbMUG9i8Q7HNh6y6yNFXoDTG+y1h3nq3OZxesxJYEGDmXKqKrrev3wc55hdDATfEf43A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242238; c=relaxed/simple;
	bh=M7fSw4ZoNMGK8A9ZnvOGroYglUNws0n+u8ADygtOBTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6Yu36sAw84SdqUD/IaQq2M1q4PozIstDsfzOFpzcUyCS0fqjvQ5tpzgUFJ3ZwsjTA0UVylS7Y4TaDJAMgcKY0dInBOyUUHt1ZsDgDdEr0OZvCt/tEG8fEa20Js3SgyWOhvyEfCFEA9MbE56DaZnfyafU6+g/uS9H1j8X8mgNTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReL6udIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReL6udIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F9C4CECF;
	Tue,  3 Dec 2024 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242238;
	bh=M7fSw4ZoNMGK8A9ZnvOGroYglUNws0n+u8ADygtOBTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReL6udIXci7SPfg1u3MtYujQQO+ReFq4S3CypWk4ba8ZKH9ZhkBlbfPsHrdziU8jo
	 o+b6UqSS0gh8d6mr1Kg2jU6c2qxVpAT0o0ycV8umh3hXuy9JT7vGLOIPeNk+h/zojF
	 RahcgjvHM4V55MhoyX8vIHD+xWtgM3mjypx2diDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 616/826] drm/xe/ufence: Wake up waiters after setting ufence->signalled
Date: Tue,  3 Dec 2024 15:45:43 +0100
Message-ID: <20241203144807.782846472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 37a1cf288e4538eb39b38dbc745fe0da7ae53d94 ]

If a previous ufence is not signalled, vm_bind will return -EBUSY.
Delaying the modification of ufence->signalled can cause issues if the
UMD reuses the same ufence so update ufence->signalled before waking up
waiters.

Cc: Matthew Brost <matthew.brost@intel.com>
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3233
Fixes: 977e5b82e090 ("drm/xe: Expose user fence from xe_sync_entry")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241114150537.4161573-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit 553a5d14fcd927194c409b10faced6a6dbc678d1)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sync.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index 2e72c06fd40d0..b0684e6d2047b 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -85,8 +85,12 @@ static void user_fence_worker(struct work_struct *w)
 		mmput(ufence->mm);
 	}
 
-	wake_up_all(&ufence->xe->ufence_wq);
+	/*
+	 * Wake up waiters only after updating the ufence state, allowing the UMD
+	 * to safely reuse the same ufence without encountering -EBUSY errors.
+	 */
 	WRITE_ONCE(ufence->signalled, 1);
+	wake_up_all(&ufence->xe->ufence_wq);
 	user_fence_put(ufence);
 }
 
-- 
2.43.0



