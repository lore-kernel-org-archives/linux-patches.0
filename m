Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E21E3559FD;
	Tue,  6 Jan 2026 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722576; cv=none; b=Bls4KpFK/QAjfSG/5Z5uF/5shD5LZhEjCBd3h4nD5lXIO2+bgedMwCUcY9HLmfKnl7JWcVwdK73VoJ0H25ERhtygj7i9y4sc19dgyPId9VV5ox3lyh76psBjKA1BP4gf6qaBzir0c0Aqsbvm2vLGzgeKn8xY2yy4KlIq4HqdbVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722576; c=relaxed/simple;
	bh=TcrD4+R4RwgUz5l5nXF0hcqhwbF1KiTzMcUOp2oqn50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKa0VxtlbKt/V2e2T0jHXEH4GL2p3I2Oj9TNb17qUqsKhkC5/Mz803W5B8/7Nc9zKVCjEbNiQnow4E2VE31zohIc5OA/YPKqG+q6/DpShrBL55rfvKt8QcFX63NaJ7kYg0rMoe68YC6HaoORz7Vcewaj/xWv/m735fwV0sdzOUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7UKj3t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7UKj3t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE8CC4AF0B;
	Tue,  6 Jan 2026 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722575;
	bh=TcrD4+R4RwgUz5l5nXF0hcqhwbF1KiTzMcUOp2oqn50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7UKj3t6LOFWATPt3yLeIrCilAfzHkoC/5yNuAvTJ5jZWdY/EYy8MiYr0hNaOOJFM
	 WdNARxe6v1vMw10S/fLtT5kVyaqpQS0oFUSRFXA3SwY7hlSZfEtGbeH7HMJkQQRNr3
	 893J/odNiBJq4GvQqNTK2t3THkDDI9yVwKcXd3rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Sanjay Yadav <sanjay.kumar.yadav@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 272/312] drm/xe/oa: Fix potential UAF in xe_oa_add_config_ioctl()
Date: Tue,  6 Jan 2026 18:05:46 +0100
Message-ID: <20260106170557.686420743@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Sanjay Yadav <sanjay.kumar.yadav@intel.com>

commit dcb171931954c51a1a7250d558f02b8f36570783 upstream.

In xe_oa_add_config_ioctl(), we accessed oa_config->id after dropping
metrics_lock. Since this lock protects the lifetime of oa_config, an
attacker could guess the id and call xe_oa_remove_config_ioctl() with
perfect timing, freeing oa_config before we dereference it, leading to
a potential use-after-free.

Fix this by caching the id in a local variable while holding the lock.

v2: (Matt A)
- Dropped mutex_unlock(&oa->metrics_lock) ordering change from
  xe_oa_remove_config_ioctl()

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6614
Fixes: cdf02fe1a94a7 ("drm/xe/oa/uapi: Add/remove OA config perf ops")
Cc: <stable@vger.kernel.org> # v6.11+
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Sanjay Yadav <sanjay.kumar.yadav@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20251118114859.3379952-2-sanjay.kumar.yadav@intel.com
(cherry picked from commit 28aeaed130e8e587fd1b73b6d66ca41ccc5a1a31)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_oa.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2407,11 +2407,13 @@ int xe_oa_add_config_ioctl(struct drm_de
 		goto sysfs_err;
 	}
 
-	mutex_unlock(&oa->metrics_lock);
+	id = oa_config->id;
+
+	drm_dbg(&oa->xe->drm, "Added config %s id=%i\n", oa_config->uuid, id);
 
-	drm_dbg(&oa->xe->drm, "Added config %s id=%i\n", oa_config->uuid, oa_config->id);
+	mutex_unlock(&oa->metrics_lock);
 
-	return oa_config->id;
+	return id;
 
 sysfs_err:
 	mutex_unlock(&oa->metrics_lock);


