Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF81144D0B;
	Thu, 13 Jun 2024 12:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282422; cv=none; b=QwaQcpfJ4+N2nIJsJUfRGZY+GwdWIAelw1z2iN9SOmU/J7aRf8z2CNWK7Dd/fsBoXR0eHrF9LTinFbpqiPEdDXyjBw54Z6RroRp3dm1CXzi/dAou1AWsIjAN9ZuT6MFpLtSbxlQNkskargizn7XqQUivqVXUxEv8BCHPAb51G7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282422; c=relaxed/simple;
	bh=5Hz8K5i/BuyGuDg5bYi3upiYk9AjOUMyfB3XuTojTKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF0XuRiv3EnHyfnlEuLNc6u8QneEphNKWmdYeHAVxoqGCVHPgUnVMwqDrlyjFY/kwsTeDPl7puuACFscj8P4Hq0RFpJNFKj7AcRGFDGXfh7umETdlBAjUy6tOS45voMPHCvupouQhJvQVktjWAL2MvUMB3jCcqbt8ysHk08+GxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxCi+jEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxCi+jEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD31C2BBFC;
	Thu, 13 Jun 2024 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282421;
	bh=5Hz8K5i/BuyGuDg5bYi3upiYk9AjOUMyfB3XuTojTKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxCi+jEnOoXgE72XmMJ4OEimoWcv/DLSDeIHQ488aIL1SaYHZ+/i3H78f2huXF3Jt
	 nSyGFeiIzHcsCU55FrnvBH5nSQH23Jznv0P8xoFCYkl0N1XXfvh3nflckpgeSi2E6J
	 jp3Ygg7+5KHDwVkvpY74Khmbrw46QqRKXGblTA68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.15 271/402] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu, 13 Jun 2024 13:33:48 +0200
Message-ID: <20240613113312.724995296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 9fe2816816a3c765dff3b88af5b5c3d9bbb911ce ]

Do not check for !data->completed, just always call
cancel_delayed_work_sync(). This fixes a small race condition.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: 490d84f6d73c ("media: cec: forgot to cancel delayed work")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 01ff1329e01c5..1b72063f242e0 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -914,8 +914,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	 */
 	mutex_unlock(&adap->lock);
 	wait_for_completion_killable(&data->c);
-	if (!data->completed)
-		cancel_delayed_work_sync(&data->work);
+	cancel_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
 	/* Cancel the transmit if it was interrupted */
-- 
2.43.0



