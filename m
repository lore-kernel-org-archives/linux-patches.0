Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B383819DF6F;
	Thu,  6 Jun 2024 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683499; cv=none; b=FVTMUgmFm30t2gas1RHyTAJRmrWXQM22ibIS1zUW/I1am5WToPJJiCBdYXkN5VnFanjJcsJS/copNbmmxRIRfFwq+mUJFN/dZFx+LTamR89yp5Ce2673EWqorOhOfLEX67f7mifrs4kW35knpujq98ODtNzIvFdH5M1S2vMNaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683499; c=relaxed/simple;
	bh=6x6qRTRKh4X6Skt1X/a3lih8WN28pkhHPAMsCKO6Wv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxQAHqBi5RDYv5vqPSlHhYDzOSJSkaLfWuTVLlCIl4ulEtnPcLxfdpwT/hDM+Na0G2UVaTnBw7Lb/Ndsyyg+HHpC+vHZQtLyPEuYvHz4rPEGOrCDInY8uaEUDw9Us/qXMBv/hMbIHUp9jRTaWVUaPK2j3/HIocTHVaOdG6+B2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEY8175D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEY8175D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92488C2BD10;
	Thu,  6 Jun 2024 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683499;
	bh=6x6qRTRKh4X6Skt1X/a3lih8WN28pkhHPAMsCKO6Wv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEY8175Dz8Vpd7IBd3jJTBihjNtDVmKUFbHgbZgSflZgZysubMijTzF1jPl5nOd9L
	 sP03wBtTRlAVEqxXF2OWPNKFoNRAXuweiIA3PZi7iddqVL9qEgGY9XTJFUmFgvSSV5
	 0I+8faLmE1GMPGTxIumldsKVOFnE6irHd23Er4xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.1 389/473] media: cec: cec-api: add locking in cec_release()
Date: Thu,  6 Jun 2024 16:05:18 +0200
Message-ID: <20240606131712.708986451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



