Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9C92D3A69;
	Sun,  7 Jun 2026 10:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828350; cv=none; b=Q10Yxq96G1qGc6xAsbKDCk3XyzLWZydSPLaiB1NiVfFEarX+I4zW/lNAQbvqxGZATdP241Gfq39DCZgsZSULwKhg9BM3bkpMGy2vnVBjTiKCQhb5TnhiChUW0KTetNu6jgSa1kovzdml8/DeBAJj7aqyYGEzXQTZa027DMtNSfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828350; c=relaxed/simple;
	bh=Qt4BBaNLZ08Hsk+hegKv3Zm/+r6qCP6MS2pa02K5rz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiWxv3xS7/ENLGouqT8M2S2HYL+JKAUqn9quCTJBMRUziouYRwElnqv4C8IqexAAvBjaEL+tkNzzXTRHCfn0Ie9wc7+1r+wWxeGxgSQzCwLbZ68C1GYI0GQDHd0hsl2ZHE1HmBCvlQfc16ShXP9UFgsEHNqS49BFaU5CAjR+EF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYwGbd1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYwGbd1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5541F00898;
	Sun,  7 Jun 2026 10:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828349;
	bh=7ncqu5YWZUulQMXiaBYL8tBAvFv43DoGBqZejlDBNaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYwGbd1EcI4vJXJAOkLZtsgo3YRIpHyJIFjXznltGUa2suYnmlpyHjldU985qpVqY
	 Hv8wGskL6CQiPcODxy33gc7+glExDlrGQAmVvggLGQuL4GrQGVKQVMeivvIoqC6lKD
	 QVa4yI4Z0NfF6A3nkQU/hrlGf8r/Sg9gyqWY0dv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 131/307] usb: typec: altmodes/displayport: validate count before reading Status Update VDO
Date: Sun,  7 Jun 2026 11:58:48 +0200
Message-ID: <20260607095732.566401774@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8a18f896e667df491331371b55d4ad644dc51d60 upstream.

A broken/malicious device can send the incorrect count for a status
update VDO, which will cause the kernel to read uninitialized stack data
and send it off elsewhere.

Fix this up by correctly verifying the count for the update object.

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/2026051350-reacquire-sculpture-4244@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -386,6 +386,8 @@ static int dp_altmode_vdm(struct typec_a
 				dp->state = DP_STATE_EXIT_PRIME;
 			break;
 		case DP_CMD_STATUS_UPDATE:
+			if (count < 2)
+				break;
 			dp->data.status = *vdo;
 			ret = dp_altmode_status_update(dp);
 			break;


