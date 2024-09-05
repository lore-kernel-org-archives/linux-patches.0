Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CC114A08E;
	Thu,  5 Sep 2024 09:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529761; cv=none; b=SOGnp42VGPhNPBxTvetajFgv46QYAmCayU5q1o//1gbvI4KQ3eHzIKbmCOmLbRvpWrS53OQBAdsEEMEdaPZPBGwo3ysDJyNyy8jnYXanbW0IpaC4olfxhfHk1ZGhQKb67HIiYIMOmjUhimjEyDKa3XRwKFHs5Ykh8KCjJpz0zXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529761; c=relaxed/simple;
	bh=g1/gv6Ag/qm0sKBf4BYfrlZn977GE3r1RCjiN/9gW8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ5zkXVzS9x4EJAB90I1GB5+h1urYmhvVgWbarVEvTujSM+JsI0795cEo1gFPoZx9U/YRzqNty10w/Z0PXA+hgGy/l9iCpSPISJ5+7L9UL0n6vE6UpwuwHjXpI5mHLTcGL45sMfxBOXmX3VN1VDy1Q+x/xz7vgv0pKJoumvyhf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvxpR3EV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvxpR3EV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B307FC4CEC3;
	Thu,  5 Sep 2024 09:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529761;
	bh=g1/gv6Ag/qm0sKBf4BYfrlZn977GE3r1RCjiN/9gW8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvxpR3EVeEauvX98+eYuNJjKNK8P1ycc4p+JAeT16DKmqMy0W/wailLxJhOIP+WQH
	 HvABy7J+X3yEBN8OgyxlmTPiPGdd6I99PizZzse+d7sMGnGdlNy+j8mwFcnk/Yx0tI
	 1Hw02eIRbeGymDyT9x9dAL1WGnjk/hS+XQafvakE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 135/184] drm/xe: Use missing lock in relay_needs_worker
Date: Thu,  5 Sep 2024 11:40:48 +0200
Message-ID: <20240905093737.491250306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 8b01f970ee890574b3607c85781354a765c849bd ]

Add missing lock that is protecting relay->incoming_actions.

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240603081723.18775-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_relay.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_relay.c b/drivers/gpu/drm/xe/xe_guc_relay.c
index c0a2d8d5d3b3..b49137ea6d84 100644
--- a/drivers/gpu/drm/xe/xe_guc_relay.c
+++ b/drivers/gpu/drm/xe/xe_guc_relay.c
@@ -757,7 +757,14 @@ static void relay_process_incoming_action(struct xe_guc_relay *relay)
 
 static bool relay_needs_worker(struct xe_guc_relay *relay)
 {
-	return !list_empty(&relay->incoming_actions);
+	bool is_empty;
+
+	spin_lock(&relay->lock);
+	is_empty = list_empty(&relay->incoming_actions);
+	spin_unlock(&relay->lock);
+
+	return !is_empty;
+
 }
 
 static void relay_kick_worker(struct xe_guc_relay *relay)
-- 
2.43.0



