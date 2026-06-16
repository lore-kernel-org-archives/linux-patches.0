Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B11A6803;
	Tue, 16 Jun 2026 16:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628382; cv=none; b=LrXFRERwyKhO3F4waQk3AmNMopKQ4bUhHlSmstWhEB/5gz8KZsPnh8GlwAogwjUvkzcLGVS569EaYtopi6P6JBTHzQHrT6dVa1NzhsNXz2RNJxz8Ei7I670nqVSxIqtB03DweQDlj5ZSDAKr2n/UsQU3HDBSNoOj40zVQ5RFZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628382; c=relaxed/simple;
	bh=MYmNZZiSJrGO03fIdU3KZ804tszd3JVdIpVl/Q6u9yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lynD5ULX+s58TcXxkEJtRjXDByGbP3b8YfB6t4swjxfjMlmVjmokzjl7yZH6SoFGGCFUeo3d6bC+xH1nr6S1W1pXwA0F5ZByGkGk7sYLJ6KQUhJNFI8mlFodHg0hf5uBXQSK4neRUhFIjq6Q6DX2hfXEnXnG9as5yakCPfUvCMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG5NuCdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG5NuCdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F51E1F000E9;
	Tue, 16 Jun 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628381;
	bh=kXusn3/bDrm0lD2Ehs3g4eHn9bIsKI/EGe6TwCqe0bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aG5NuCdlP8nikP7BZFIP6+DDsALrBgSjOZj/m0Xifg+CG9o75OItz03Qe7gZXtYEV
	 +G2IwjfvxYLW53Thlqz66KFhsS5OsTNuAYHflecvCbHKwaac+84T+WJSHQhLhE3dV0
	 iDjMq8hzKWH9vcPzMB+51Z7zyOIIZT5WlZerLq5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 085/452] usb: typec: altmodes/displayport: validate count before reading Status Update VDO
Date: Tue, 16 Jun 2026 20:25:12 +0530
Message-ID: <20260616145122.329884439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -311,6 +311,8 @@ static int dp_altmode_vdm(struct typec_a
 			}
 			break;
 		case DP_CMD_STATUS_UPDATE:
+			if (count < 2)
+				break;
 			dp->data.status = *vdo;
 			ret = dp_altmode_status_update(dp);
 			break;


