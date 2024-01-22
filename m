Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D234E1AD;
	Tue, 23 Jan 2024 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975089; cv=none; b=g0vNMJA/cvsSSlKQTC5KlGBN8uNrOho6LJrIMpdyCterVVUy28qWFvmruoI+6zP46w+SjE8BhM5F0s42Gv7UV+I2Epltwk2C6lVSePkJqdNvEedq1+DFviaoVnhPRHh3GD+CPXWdJEii+sWc+d59mc5UB+jc2AgowDeEiPe/uZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975089; c=relaxed/simple;
	bh=owmShYNwcaWJ462hD2bfGkLszbpbPG7EOaGx+2excMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRDtpE51+lx4DSNICAd2FoDEQ6uZICQPFuptamYbvexEn2vodGGbcD1N2XG9RKhffqV2eKkvsg7vSjYULmA661/OiltAFPvmHzsuvvJJyMwqnYg7ZoYA1qP2wuvvPO5Pz3oXxYEon76BB10Vq44F7p/IV2vQwM9P+vMBQ7XXj0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqJkKq7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqJkKq7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF1EC433C7;
	Tue, 23 Jan 2024 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975089;
	bh=owmShYNwcaWJ462hD2bfGkLszbpbPG7EOaGx+2excMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqJkKq7lYrR4ryU6pUluBxbTuKPPG4dzNs5zsevvHgn8HKNJaIQ3NTqAh4vWFMxje
	 pVNXoRqXuQdTJi9H8OPYvQyrPN5vZEYVESWMe3PCd4gsWeSsog2wlhqN9c+4B/4YrV
	 2RYMzqsybXx49qGabACe7WohLA56mNW4aSDAcF1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+621409285c4156a009b3@syzkaller.appspotmail.com
Subject: [PATCH 6.6 233/583] media: pvrusb2: fix use after free on context disconnection
Date: Mon, 22 Jan 2024 15:54:44 -0800
Message-ID: <20240122235819.117359027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit ded85b0c0edd8f45fec88783d7555a5b982449c1 ]

Upon module load, a kthread is created targeting the
pvr2_context_thread_func function, which may call pvr2_context_destroy
and thus call kfree() on the context object. However, that might happen
before the usb hub_event handler is able to notify the driver. This
patch adds a sanity check before the invalid read reported by syzbot,
within the context disconnection call stack.

Reported-and-tested-by: syzbot+621409285c4156a009b3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a02a4205fff8eb92@google.com/

Fixes: e5be15c63804 ("V4L/DVB (7711): pvrusb2: Fix race on module unload")
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-context.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
index 14170a5d72b3..1764674de98b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.c
@@ -268,7 +268,8 @@ void pvr2_context_disconnect(struct pvr2_context *mp)
 {
 	pvr2_hdw_disconnect(mp->hdw);
 	mp->disconnect_flag = !0;
-	pvr2_context_notify(mp);
+	if (!pvr2_context_shutok())
+		pvr2_context_notify(mp);
 }
 
 
-- 
2.43.0



