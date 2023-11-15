Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2A9182C1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyfHm6VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248F4C433C7;
	Wed, 15 Nov 2023 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078667;
	bh=pLIwTlMlibQy4naC0io6eUKeSMb7jEYMrTE3qOUlvvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyfHm6VRHSkBoYslwoyDgGQeFqG2yGwX8Uh8xFPPVhN99cu3vJp2HZUH2Pow7M6FZ
	 xOZkjYGnP6qYy5mRkQ7s1ZqKkTbbqLX9YywTli88nW0kmVkOIh4TKpPa8ckWl7OARK
	 nJoHdA7wc3R/yjp2HQhLFnT3bZnvM7SItoM/3eqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/45] media: dvb-usb-v2: af9035: fix missing unlock
Date: Wed, 15 Nov 2023 14:33:12 -0500
Message-ID: <20231115191421.668380410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit f31b2cb85f0ee165d78e1c43f6d69f82cc3b2145 ]

Instead of returning an error, goto the mutex unlock at
the end of the function.

Fixes smatch warning:

drivers/media/usb/dvb-usb-v2/af9035.c:467 af9035_i2c_master_xfer() warn: inconsistent returns '&d->i2c_mutex'.
  Locked on  : 326,387
  Unlocked on: 465,467

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 7bf744f2de0a ("media: dvb-usb-v2: af9035: Fix null-ptr-deref in af9035_i2c_master_xfer")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8a83f27875ec9..2ed29a99fee1e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -337,8 +337,10 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
-			if (msg[0].len < 3 || msg[1].len < 1)
-				return -EOPNOTSUPP;
+			if (msg[0].len < 3 || msg[1].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			/* demod access via firmware interface */
 			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
@@ -398,8 +400,10 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
-			if (msg[0].len < 3)
-				return -EOPNOTSUPP;
+			if (msg[0].len < 3) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			/* demod access via firmware interface */
 			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
@@ -474,6 +478,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		ret = -EOPNOTSUPP;
 	}
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
 
 	if (ret < 0)
-- 
2.42.0



