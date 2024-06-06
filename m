Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69819754E;
	Thu,  6 Jun 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683719; cv=none; b=jNgRgM2/vWhm6w+ELMiA6QPCSRVuo27t/KaZ7o2GsMkkpmPwGOjeNi67IkSCC3oMH6vS6ZMmoxJ4ZgUEl2bmfxOtVQ3DHaBlH4yU7piJxBSJE7HZ32OL89MdKAAuphljfbLMgWVndDcPzulEC8wKxhe+G1/dZ2SGshhYknQN4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683719; c=relaxed/simple;
	bh=NBkfdUaFjuazjyvN5fEAuwGHPf+CnW++DY+3VRl9RQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnlczqdHunc3OEdsE60OoH10JRj21O0goMWesAVJ0fUQv1x2Q/AR22UUYluBowwtHgfiOE6Ir6uqtA7PuR1aOzPgZgR0PTl03GMgE9oZoB4nt0hdX+8gaWitqDKgHHHuV1GTZzWQRU/orGy5UYgkgW2fxppv9dFgYcgclSeZH/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWlUrZg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWlUrZg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B88EC32781;
	Thu,  6 Jun 2024 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683719;
	bh=NBkfdUaFjuazjyvN5fEAuwGHPf+CnW++DY+3VRl9RQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWlUrZg1xlXJbN9t8QNDh/IOxChWanOiWiuuIJ2iHoXP+FSCY40ZGRfyd91DOqF/E
	 4/DoaYgnk9qSUCJx+nKQNee/R7NDqYJ9zFjr8ehulLcaIlhgWxd2/H/A+vggZ64bsa
	 rvUHF2otenruve2LBdDXJ/aTVaRYpLoOqyY0Go9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.6 608/744] media: cec: cec-api: add locking in cec_release()
Date: Thu,  6 Jun 2024 16:04:40 +0200
Message-ID: <20240606131751.987029459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 42bcaacae924bf18ae387c3f78c202df0b739292 ]

When cec_release() uses fh->msgs it has to take fh->lock,
otherwise the list can get corrupted.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: ca684386e6e2 ("[media] cec: add HDMI CEC framework (api)")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/cec/core/cec-api.c b/drivers/media/cec/core/cec-api.c
index 67dc79ef17050..d64bb716f9c68 100644
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -664,6 +664,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del_init(&data->xfer_list);
 	}
 	mutex_unlock(&adap->lock);
+
+	mutex_lock(&fh->lock);
 	while (!list_empty(&fh->msgs)) {
 		struct cec_msg_entry *entry =
 			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
@@ -681,6 +683,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 			kfree(entry);
 		}
 	}
+	mutex_unlock(&fh->lock);
 	kfree(fh);
 
 	cec_put_device(devnode);
-- 
2.43.0



