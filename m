Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E87474275;
	Fri,  7 Aug 2026 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117790; cv=none; b=IMeQo4iSEVuWZfl1H/h16UspxnVyXk/EmfEPfuIoNxDB8k+2RfIc9RYE9Xtywdsb9H4Jkz9PZSI5d5NUufHL02sZ/7Nxy4mne84afpiyRggSc1SC+PRhcEibuINfugvKVgN8HivQVvZKtOJPg4sC+jF4kXeLF2dCaBP23QmWucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117790; c=relaxed/simple;
	bh=nIaA5FQVjpoCc+xrN1ZE7wQQ3vPgk7uTIclaao72mis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw33N0qlYKPH7pR9Zi8F9LVLaO1TZGHKl92S21xbr5WQ+lqjZ8ITB+gHPbTMbpUzyKRAJlK2wqHm/xuQl4BH+BwZYNC61P/WE1v8MbJX3YATkW9JJVmdvP/FO7ViosczrmnOdBbADANsKOAjW0RxUceDnzA5lVzlfSXw6/W6++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/Z6uj47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/Z6uj47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6624F1F000E9;
	Fri,  7 Aug 2026 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117789;
	bh=ZLD+4R3wgy+bZe4Cl0h+ytzYmBJ5d5boZV3qLYQfIGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/Z6uj47SsJgHjg5sw12wIJ13vIK3BcyPPP/CQ9qJq8x2rBBd6d6xjafpUMQvon3X
	 V6qwSsITJphMheeBkyD11lKegpsacOQ6gTZ74CzSJJoNDryCQGRgyExQI1HY0u2QuL
	 W3IQ6lJB0fR0moL+2BhaEz7zmHX1kkBunHMUvOg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 405/438] drm/amdkfd: Handle invalid event type in CRIU event restore
Date: Fri,  7 Aug 2026 16:40:01 +0200
Message-ID: <20260807143436.597966373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit a9cdc85839e4fe2c760aa4ca6cc341c31ad1918a upstream.

In kfd_criu_restore_event, there was no handling for
the event priv data having an invalid event type. The priv
data here is untrusted and can be invalid.

In that case, fail with EINVAL.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2e8e9963cd5c41aa14fd5316bf9ec92e7a0e3097)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -524,6 +524,9 @@ int kfd_criu_restore_event(struct file *
 
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	mutex_unlock(&p->event_mutex);
 


