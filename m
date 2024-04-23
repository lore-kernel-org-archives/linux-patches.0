Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061DF14389E;
	Tue, 23 Apr 2024 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908653; cv=none; b=EdI0iENsvSqfbQj4qfw8rSXpMLRbNXBi2ETu7fPcjb9HWSRR+VR7iJP0cshUy5KXyJsJBQCePtH3dQ9lJqDg+Rn1tl08piX1I2HAAu2sNoRrEJLM0ppAle3m50x3WW4yj6HQ3PGXVEX0yjUjSF1HITSocfHbur5FuvXMhNb9nDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908653; c=relaxed/simple;
	bh=sOQpHRaRU1hKvB4zkNMNWlRd6n2WS9/yG9hF2viIDvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/WuDmp9TFpPN5xiYxXAcay6shGFIdYU7vkQst1nFICSpdAiHuTiK4tvM2Y4YkLa1EFImH/irwC+Crv1ISXgjMmn7bAl6BHhFWRt0jQEAS9q/5jB4wXc52L+Rq2DifBgwg+nIKA7AMZEsYYKgZZB4iWr8GsjrDI5pjpIvVRdVrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiXa/GZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiXa/GZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F1CC116B1;
	Tue, 23 Apr 2024 21:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908652;
	bh=sOQpHRaRU1hKvB4zkNMNWlRd6n2WS9/yG9hF2viIDvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiXa/GZuk7k1NAaJSkyiPT15Zr/ya+K/Le3Czmm+N6zaXsOsjLWA3BXE6USTe9pNW
	 cPiq6hh2UoXUvKGY44khT8xbSoqKw0TYv+Xj8WDL8v8uHzHe0ZO9OBj9sdelGon0bL
	 emjl7R0qPnXQ4iBFHV8a1OJCyO5iRXHfYexbofjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Harish Kasiviswanthan <Harish.Kasiviswanthan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 142/158] drm/amdkfd: Fix memory leak in create_process failure
Date: Tue, 23 Apr 2024 14:39:39 -0700
Message-ID: <20240423213900.307239485@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

commit 18921b205012568b45760753ad3146ddb9e2d4e2 upstream.

Fix memory leak due to a leaked mmget reference on an error handling
code path that is triggered when attempting to create KFD processes
while a GPU reset is in progress.

Fixes: 0ab2d7532b05 ("drm/amdkfd: prepare per-process debug enable and disable")
CC: Xiaogang Chen <xiaogang.chen@amd.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Tested-by: Harish Kasiviswanthan <Harish.Kasiviswanthan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -818,9 +818,9 @@ struct kfd_process *kfd_create_process(s
 	mutex_lock(&kfd_processes_mutex);
 
 	if (kfd_is_locked()) {
-		mutex_unlock(&kfd_processes_mutex);
 		pr_debug("KFD is locked! Cannot create process");
-		return ERR_PTR(-EINVAL);
+		process = ERR_PTR(-EINVAL);
+		goto out;
 	}
 
 	/* A prior open of /dev/kfd could have already created the process. */


