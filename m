Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920AB3AC0C2;
	Mon, 23 Mar 2026 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274041; cv=none; b=l+wYrmtOOeFOxCOoNwOTJ6b3YsSLlBS/wJ673ZGmgIAc6ZpSfEWHJpKwn6fOvVdrqfaalusI6LxwkLfgawP41XKRbXVCGb6/7vqQMEK/ddH54PTzmhsrYWdob+n75rSGgUApa08KleoDjsG5guD2gJAwzNOuR6l/W4mAdVX5asQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274041; c=relaxed/simple;
	bh=0DlzXo5ZC5gqygjUfly/3+aYPpZrShvxqbr6ybV17sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmTyDacwdQW8+s8VTp9s/mMv1vgzfoIQtAxOAPLE9hY7Uo8fGNaWGacvUVWKj5OYvidD5MLSiFN54pz2wr9YiS1fQTxt4TPZU9zdFUjLEp667hItffOGDV16kO38ir8tZu1N6Um9EF2Zb3gHi0IDHbJv+86XUxJ8AyMR8Mv6OE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVZpU3dA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVZpU3dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1644AC4CEF7;
	Mon, 23 Mar 2026 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274041;
	bh=0DlzXo5ZC5gqygjUfly/3+aYPpZrShvxqbr6ybV17sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVZpU3dAXLCu0zNx204qJdmWsQIQCY6J1NZmpmkXLp9R3GThGGX06/tUSmy+owKQX
	 q6Qle7ImNsvMyM/iRQfqkYXm+u6dRu7GgKTwSslhOL4AZEZRPRyHnGtqSmqE+I2FHq
	 sdh1JlqtOEAk9b6Fb386N1Flf1HlDyevRw6H1wJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.19 091/220] drm/xe: Always kill exec queues in xe_guc_submit_pause_abort
Date: Mon, 23 Mar 2026 14:44:28 +0100
Message-ID: <20260323134507.471094374@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 26c638d5602e329e0b26281a74c6ec69dee12f23 upstream.

xe_guc_submit_pause_abort is intended to be called after something
disastrous occurs (e.g., VF migration fails, device wedging, or driver
unload) and should immediately trigger the teardown of remaining
submission state. With that, kill any remaining queues in this function.

Fixes: 7c4b7e34c83b ("drm/xe/vf: Abort VF post migration recovery on failure")
Cc: stable@vger.kernel.org
Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260310225039.1320161-2-zhanjun.dong@intel.com
(cherry picked from commit 78f3bf00be4f15daead02ba32d4737129419c902)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -2410,8 +2410,7 @@ void xe_guc_submit_pause_abort(struct xe
 			continue;
 
 		xe_sched_submission_start(sched);
-		if (exec_queue_killed_or_banned_or_wedged(q))
-			xe_guc_exec_queue_trigger_cleanup(q);
+		guc_exec_queue_kill(q);
 	}
 	mutex_unlock(&guc->submission_state.lock);
 }


