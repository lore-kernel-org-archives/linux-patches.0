Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75AA256C95;
	Thu, 17 Apr 2025 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914364; cv=none; b=dmkkMsqkdsxyxKXWHQwqsSUp4pc90HsYkRMMwXSVnaD64ut6zf6Isa5Vv9Zd8j/fyvUzWH59rkL8NTC9/vplRvVvzdec15ioUG8uML4XPa/jjb1GkHZ3wqA4toF1oUNHmz+nF9iJSp0dOTxeoQaBLduv7cvJKgNGDIkNMWHdR5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914364; c=relaxed/simple;
	bh=6FSwM3LzQ0ubrbDSfB8ELp5Nv8qTwRIuaJJ5HtZO63k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjE1v/ymAsg98wXuel1uA7I4gBgguDsTQjEhAKQX5j9w4Rjvhup5sj268AvJsTiq0HWGirfjFiR8V7UFmnJbKdTxghhOFiL6efH2/y6mvyhEMPxi0RO5Jd8EjS5F6WPx1b42rDu4blcA5+vclLOAhQifdyG22O5Du6+UA6h5Od8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8hmKLks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8hmKLks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF82C4CEE4;
	Thu, 17 Apr 2025 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914363;
	bh=6FSwM3LzQ0ubrbDSfB8ELp5Nv8qTwRIuaJJ5HtZO63k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8hmKLksRGgGQXKd33rYvDtJynmlfEpgejjwTP8tHcbVYrmaf4OqT+frCw7UqkCwm
	 oqRrJ01wQafAe5T+z2n7D8UMR4qaWXt3GFPS3qshp34eQ/D3I1ijEnl0R4GoF0MzK/
	 uWPDW98/s2tZs1EDWs2hD8Jk+v+gtbBR+heLM5Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 191/414] HID: pidff: Clamp effect playback LOOP_COUNT value
Date: Thu, 17 Apr 2025 19:49:09 +0200
Message-ID: <20250417175119.122734762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 0c6673e3d17b258b8c5c7331d28bf6c49f25ed30 ]

Ensures the loop count will never exceed the logical_maximum.

Fixes implementation errors happening when applications use the max
value of int32/DWORD as the effect iterations. This could be observed
when running software both native and in wine.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index ffecc712be003..74b033a4ac1b8 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -690,7 +690,8 @@ static void pidff_playback_pid(struct pidff_device *pidff, int pid_id, int n)
 	} else {
 		pidff->effect_operation_status->value[0] =
 			pidff->operation_id[PID_EFFECT_START];
-		pidff->effect_operation[PID_LOOP_COUNT].value[0] = n;
+		pidff->effect_operation[PID_LOOP_COUNT].value[0] =
+			pidff_clamp(n, pidff->effect_operation[PID_LOOP_COUNT].field);
 	}
 
 	hid_hw_request(pidff->hid, pidff->reports[PID_EFFECT_OPERATION],
-- 
2.39.5



