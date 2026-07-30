Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EE64446E9;
	Thu, 30 Jul 2026 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424385; cv=none; b=aiOYhCZgW8bxZN3x3JYfrpB7gX3OofXW81GCMNxCW+wGg2hi1BmBxhWMQantU0eDxwE9vCHApjP/zXqYJJYOEKNhXgYg2GQqU7+IPpxy16125ccAtgGyt7Y7/iqIFC2U+ysgvC8vJilOHQQL3urkHTAVsxAYo2lOrPSUCOtCbS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424385; c=relaxed/simple;
	bh=UtzlMjg7+RHaAt2ONAH95g02AZ7Q8inuYlDENbvtAlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2S80E3NUw1KtnORXEHabiFqUKgT7vbrybq1Dt0wsJ2G61a0bhG50veGiOJhbqU6GVTvcYET1joan/ddI7o1zhHQTan9erj4nRoN5XCc/FHS4WyKRWhnrT5Fz3whkNOk71W74GztadDUfbtOV8ZSni4gbJ2giQtmE3QlusscMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5WQ17rR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5WQ17rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2911F000E9;
	Thu, 30 Jul 2026 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424384;
	bh=lGNSE9ubazNOAuhy3bSWmFbWc7yfMezKxYjcfj9toXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5WQ17rR46dnt//lgPHGN0RwlN1o7R47ldvVoHG3TcHA+b0S1YHuaO+Os2Cq5NVOn
	 TM9ePD2mGdEt8cHmk2l3lDdigwPPvxEOmCE0eruQ47yl23JiJtQ01LmKlMl6Ha7kfy
	 ux3FLVhPsgafIS1OAkqb7AQyM2+9sv4KvVaRPoNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.18 376/675] drm/panthor: return error on truncated firmware
Date: Thu, 30 Jul 2026 16:11:46 +0200
Message-ID: <20260730141453.128043308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 4a2c8cbe9bcba170706fdf08b1c84b6cbcf5b044 upstream.

panthor_fw_load() detects truncated firmware images, but jumps to the
common cleanup path without setting ret. If no previous error was recorded,
the function can return 0 and treat the invalid firmware as successfully
loaded.

Set ret to -EINVAL before leaving the truncated-image path.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260714163056.22329-1-osama.abdelkader@gmail.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -777,6 +777,7 @@ static int panthor_fw_load(struct pantho
 	}
 
 	if (hdr.size > iter.size) {
+		ret = -EINVAL;
 		drm_err(&ptdev->base, "Firmware image is truncated\n");
 		goto out;
 	}


