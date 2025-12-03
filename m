Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04AF35BDC0;
	Wed,  3 Dec 2025 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779778; cv=none; b=Zhevv2/mn2au2kAosmw7cCwt9u84Jg7ySC4krD40FGY3pbTW88CGghM4SPP1RfOe7E4Ipj7Tz880mOls74De+itPV/JB3yycAF+MCertfYpees7qrIgblzyJj9rMJlqJ9aBUJ6egqRsz72smisu+l4hWsZ4m+NYmI7JE3+Vsfsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779778; c=relaxed/simple;
	bh=gd5dO5wz9yMYhsPkm/ReYEjql/7slNy83PaYGepAmbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxQiaGmoI4UUZfSmdMExZ3J5xaPyT1oGShzqhVxiP6aBBAF44KoRZJ4/dEpxxCPGYs4Jfm3KNC7XYywBUhrS6guJHR9eT8rnwDol4CKQUQgY5oeMmRNJUSU/bxL4EPNwI09HTrIL3nsnsGFD/aB2lGHu9cg1Xy58CpYVgDXWzFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLtzOZjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLtzOZjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D117C4CEF5;
	Wed,  3 Dec 2025 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779778;
	bh=gd5dO5wz9yMYhsPkm/ReYEjql/7slNy83PaYGepAmbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLtzOZjp5n0qlo9wf+Cyrr2vQ7hguhgav+aJs1Rs8gyI6UaKDSH+c+HleIAQUoW8K
	 /UABJH+8cMdsuOrZYfN532gNPbKliONw8ok4xcGWgkooXcq5hk3roLy2LF5F8MvnOX
	 Ox8SHbdMnpo/Be0HPR6LM0uxbY+Xe8jR4h0HyA6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 351/568] Bluetooth: MGMT: cancel mesh send timer when hdev removed
Date: Wed,  3 Dec 2025 16:25:53 +0100
Message-ID: <20251203152453.560912955@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 55fb52ffdd62850d667ebed842815e072d3c9961 ]

mesh_send_done timer is not canceled when hdev is removed, which causes
crash if the timer triggers after hdev is gone.

Cancel the timer when MGMT removes the hdev, like other MGMT timers.

Should fix the BUG: sporadically seen by BlueZ test bot
(in "Mesh - Send cancel - 1" test).

Log:
------
BUG: KASAN: slab-use-after-free in run_timer_softirq+0x76b/0x7d0
...
Freed by task 36:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_save_free_info+0x3a/0x60
 __kasan_slab_free+0x43/0x70
 kfree+0x103/0x500
 device_release+0x9a/0x210
 kobject_put+0x100/0x1e0
 vhci_release+0x18b/0x240
------

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Link: https://lore.kernel.org/linux-bluetooth/67364c09.0c0a0220.113cba.39ff@mx.google.com/
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 9bd4d5bc84db1..b89c3fc364b83 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9501,6 +9501,7 @@ void mgmt_index_removed(struct hci_dev *hdev)
 	cancel_delayed_work_sync(&hdev->discov_off);
 	cancel_delayed_work_sync(&hdev->service_cache);
 	cancel_delayed_work_sync(&hdev->rpa_expired);
+	cancel_delayed_work_sync(&hdev->mesh_send_done);
 }
 
 void mgmt_power_on(struct hci_dev *hdev, int err)
-- 
2.51.0



