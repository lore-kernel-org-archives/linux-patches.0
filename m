Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F114265E;
	Thu, 13 Jun 2024 11:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279017; cv=none; b=lPISZnGLEvqkt1nNGMwCjGOwhkezyToHj6r7V/5ptGwzdfPHoK/Eu4B4eZI10dYO4GA9OOZU6+iK/jXBxHt6M0HBbeG+YyIaARv6uolUdyvAhryU+0hCAoY5xFfdg+1BLXlOy/o/WdmJ+hJqLnNUiAKj8B3qxg4VgxGn7hVnBk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279017; c=relaxed/simple;
	bh=4LaZbl16NS/zdoIH0y7j1e8U1rw+RTSfs38AdULsJAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIpRC75MF2a66w+PuwBXRp8kUExXqXQQKtLNG9YxtM97hL/zbruTz2o7MBkH0wrT9acj65I272mrIHMVn0GNt/NOctDjNu1P3Q0hsSxuO/yQJrhhymWKWws+LTOcBFNRWVoLZ/VZxOo4yqhmSU5xUXtriS5wTDcMdOOvJX+DPXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fewH832i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fewH832i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17751C2BBFC;
	Thu, 13 Jun 2024 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279017;
	bh=4LaZbl16NS/zdoIH0y7j1e8U1rw+RTSfs38AdULsJAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fewH832imI+4puyBddl/UOBQ0AYCWj+Cho6HoZTiDaQvbke9FpB3F/UgSqs7yf1Zd
	 gXhfajgwxb8/JxarIHKQjlKyWePVNPjZwKwxly+stljCidlRLGugquXTn52jOBwXhY
	 7BRvMq5nTG4FX0AfPCqWacCKZwUzZlqm4skPa4rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 4.19 117/213] media: cec: cec-adap: always cancel work in cec_transmit_msg_fh
Date: Thu, 13 Jun 2024 13:32:45 +0200
Message-ID: <20240613113232.512176594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/cec/cec-adap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 2f49c4db49b35..d73beb1246946 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -863,8 +863,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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



