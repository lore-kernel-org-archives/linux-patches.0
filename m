Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037161741C4;
	Wed,  3 Jul 2024 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005482; cv=none; b=KId1VEweCosqayEe2kaCJJb3DeaxChuPsFH03v8aIorKSsHTOJUzxhkC4XZcWpoODDvseiU6kreGZv3HjwN83S98UQIGboi8INiwAZGLdsxpsGn/dVlcf+/G4Qhfb+gesybOM0HWGXdigxSugEiWoaZYwygWqcZ4CIycq79yVas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005482; c=relaxed/simple;
	bh=v1tLD4EfvZ+OED0w8Wh15p6y5ULoyxvjQtYgI3FsdsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WI/lxV0opQi1xbHW5w4ONsNWJOqRhfx9w/0U3BH4EGxCvKOupL/7UM0QOlESxAzl4rEvvggIqLDdAij5OKkfC/fCJDFygR121R0nJdc3AHNrL/q7AEGzCvQCRjtrZcyWZar//RlNsb0VUllFFq75b1SdyJWHXydTY0YbbN8bB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcdsC2s4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcdsC2s4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256B7C2BD10;
	Wed,  3 Jul 2024 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005481;
	bh=v1tLD4EfvZ+OED0w8Wh15p6y5ULoyxvjQtYgI3FsdsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcdsC2s4nfnw4KlMwgdCs77J/O5B9c+ZgzyTG81v6YhRIR065aQGP+tmkEi1UxUa5
	 3u4pcEJF8E521r3sKN0FV269pUaR+HRP7QNLcMadliVGpH6sHYZPc/3pFkn1Frry2y
	 oNne8VBG4PAOijRqW9HCLuEGIBZOudI5k0SSMDO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/356] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed,  3 Jul 2024 12:37:11 +0200
Message-ID: <20240703102916.697951272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ce3af2ee95170b7d9e15fff6e500d67deab1e7b3 ]

Fix a memory leak on logi_dj_recv_send_report() error path.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 57697605b2e24..dc7b0fe83478e 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1284,8 +1284,10 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 */
 		msleep(50);
 
-		if (retval)
+		if (retval) {
+			kfree(dj_report);
 			return retval;
+		}
 	}
 
 	/*
-- 
2.43.0



