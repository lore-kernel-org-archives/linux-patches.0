Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8698C6EB56;
	Thu, 13 Jun 2024 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281322; cv=none; b=eZC8cIA00AhvZKfFqlvq+1eYnIHLv/Oqzevk7Oj6u+kcjWeT3PEtNb+lFHkyxzGuV9Ycv+jJw5kFwIR+mh4FZN7anNCSoh4fohMpug+pe3J1+iJk7xONvAmmTcPEhD3fopPTkRirQLOwSBtei/qVGpoWuF9mVCIMW9AwTpYGDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281322; c=relaxed/simple;
	bh=AUT0glqgx0lYeHLJNyn+RNVQsBsD8yDXimjUWQ3C2P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCazZx/Sot47wsgq5DyKlHmKwE+5Sd6qZhFKGaq8imRzgsojzQl2LTVPzIhcBZyxnbJPKva3eHdopJ2C1lbTUbB7SSVgJLnPmSYkQBlOXO2IKAVFBjjl9HBFwtAOm5qrjuKxrFXxNR9GzjFPYpBv3aJ1fhE8XmUPcLt3yzBo4XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHKuDvDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHKuDvDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9216C2BBFC;
	Thu, 13 Jun 2024 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281322;
	bh=AUT0glqgx0lYeHLJNyn+RNVQsBsD8yDXimjUWQ3C2P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHKuDvDSbPCSM+CbtElPyQBMYrsgw5QMU/8CnbJ4pXK0mDLdKy7Golg7kbOAxDwDU
	 QMWk27VUnLM/rLwudoh6RNIW8beC2ue9YPNc3x+R1KyVQTOfAfaAp3PPsirTzYYJJZ
	 8/I2ddFEFPby9kGgtw2W4Jq1lxBKOT+IghrArrcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.10 215/317] media: cec: cec-api: add locking in cec_release()
Date: Thu, 13 Jun 2024 13:33:53 +0200
Message-ID: <20240613113255.871606920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f922a2196b2b7..893641ebc644b 100644
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -672,6 +672,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&data->xfer_list);
 	}
 	mutex_unlock(&adap->lock);
+
+	mutex_lock(&fh->lock);
 	while (!list_empty(&fh->msgs)) {
 		struct cec_msg_entry *entry =
 			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
@@ -689,6 +691,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 			kfree(entry);
 		}
 	}
+	mutex_unlock(&fh->lock);
 	kfree(fh);
 
 	cec_put_device(devnode);
-- 
2.43.0



