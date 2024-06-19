Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98A1E492;
	Wed, 19 Jun 2024 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803875; cv=none; b=nO2/FCoTtUNyziiGo4D1eBAmQA+585WUMeYXvoSq+jkFBi75uJxYHlHInruZk5MSal3uHmtrU78ee4u6Kp7dAZ6D196uGPlRymFijZAzc7uEL/QXpmYAcp80Ef3rldQ84sqTVDzybVCSe7DoC2oh2MXuZD3OSUcXoJmUePCh+t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803875; c=relaxed/simple;
	bh=ypalvhVOYV1/kJev/nK1VTlJgr9NwYbjjMIO0wmDOmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8fBO0k/Ct10xuepTjI/CBdR1VR5yKSW06PaQnM/ama59+gBRszVHZiRl962fYrMhlTvu/YqEOmcO71dr4tOkavIvjkLNzEOEhHyNpr0mi27Sdcr1RUwd/1kMWsY8ssjuM9P2V1/uKLSwimFZZMFmuyl0d8jkByfyU6PO3bvf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/S8+Df6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/S8+Df6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7394C32786;
	Wed, 19 Jun 2024 13:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803875;
	bh=ypalvhVOYV1/kJev/nK1VTlJgr9NwYbjjMIO0wmDOmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/S8+Df6aGHeoXvkUIxN/FsrgKfwvLDLCoo8XSd690wAn/YkzDltgF6unsMIeKrot
	 sl5L7T9R0NTxGMnmQL3DGDMdf18WJ+5vCE7XwsAHp1/1SS0q8zQ79tuFMwDofyobaS
	 qqDLitx69MdyzN9IdD1HzMzcnrw4TEUe080/O2Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/217] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed, 19 Jun 2024 14:56:15 +0200
Message-ID: <20240619125601.783084084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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



