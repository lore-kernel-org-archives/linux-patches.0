Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189622969F;
	Thu, 12 Dec 2024 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019262; cv=none; b=pyVk8172wN6V7hAfyMK9oKQe4DVefY9S5L6sg6XFw9euIMaVWgJHWwgPCuuQbPKjlzbMqJmHreJh9olD82wQOaHHMNjn2H6ACJ4QXSDCs1s6LQE/1DDPmj57+Ezek1jrCRyaipEL3A8JY8XIvyhWH+k2uIiZ02OWv3SNSSd60oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019262; c=relaxed/simple;
	bh=Q1jjvcgB54NiChc2TmXrd+PKyyupXx8IGeK9VS62biY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNwmO9HXlyxBdOnwO7gtQlDLLv+J0bu0fXzfD+oPwcETyNHcWbSIHTkKAWRYceZ1GesBkLs2oSspyPRi4jIQIMXFK0YGm9bhK+yPY2lVvhFPdCSeFGa8wUELHncRhP65w9tvQ6kGzqHsXTwdwSq/3HNh5SMW5wXd4wnyv/tA254=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BH2tu5ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BH2tu5ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DACC4CECE;
	Thu, 12 Dec 2024 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019261;
	bh=Q1jjvcgB54NiChc2TmXrd+PKyyupXx8IGeK9VS62biY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH2tu5ye+l4SrJF27G71/t5GJDsZLqi3jpSKRIprza4xQ3Etspx7W4KHkbp6rCJhC
	 wg7H7fpFDTiEUGD9aOs5SSXtoIYHg70R1rjiJgD57KXWwg2LNCEbcI2OmdlOzoDwBm
	 tKgta52DawTEKCLj3wNyhBrK2NdI8t2PXi1KiEUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/772] wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()
Date: Thu, 12 Dec 2024 15:51:16 +0100
Message-ID: <20241212144355.345124618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 8619593634cbdf5abf43f5714df49b04e4ef09ab ]

I found the following bug in my fuzzer:

  UBSAN: array-index-out-of-bounds in drivers/net/wireless/ath/ath9k/htc_hst.c:26:51
  index 255 is out of range for type 'htc_endpoint [22]'
  CPU: 0 UID: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.11.0-rc6-dirty #14
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Workqueue: events request_firmware_work_func
  Call Trace:
   <TASK>
   dump_stack_lvl+0x180/0x1b0
   __ubsan_handle_out_of_bounds+0xd4/0x130
   htc_issue_send.constprop.0+0x20c/0x230
   ? _raw_spin_unlock_irqrestore+0x3c/0x70
   ath9k_wmi_cmd+0x41d/0x610
   ? mark_held_locks+0x9f/0xe0
   ...

Since this bug has been confirmed to be caused by insufficient verification
of conn_rsp_epid, I think it would be appropriate to add a range check for
conn_rsp_epid to htc_connect_service() to prevent the bug from occurring.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240909103855.68006-1-aha310510@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 99667aba289df..00dc97ac53b9d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -294,6 +294,9 @@ int htc_connect_service(struct htc_target *target,
 		return -ETIMEDOUT;
 	}
 
+	if (target->conn_rsp_epid < 0 || target->conn_rsp_epid >= ENDPOINT_MAX)
+		return -EINVAL;
+
 	*conn_rsp_epid = target->conn_rsp_epid;
 	return 0;
 err:
-- 
2.43.0



