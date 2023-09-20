Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19A30FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7161CC433C7;
	Wed, 20 Sep 2023 12:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212396;
	bh=4830YdIPsO53D4pEScVVdNHeKFAdBc7zCVlNDKBxySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B30X/DbOq+0KZqCfmImMFL9gteQ97fELmsOd/FCKwbnPyjmImQ6/OabmoihwhH1w8
	 bkKJ/Sb0py710AqLwBqIiPyIEqYKNfdOEf6BNPAgMNDxwl+TNrJSQAVgB5SaS/gLoB
	 dXNta28gY5sA/Eecb5FQPVqKXFuO1MwgDecgpPiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/273] media: tuners: qt1010: replace BUG_ON with a regular error
Date: Wed, 20 Sep 2023 13:31:40 +0200
Message-ID: <20230920112854.294537765@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

[ Upstream commit ee630b29ea44d1851bb6c903f400956604834463 ]

BUG_ON is unnecessary here, and in addition it confuses smatch.
Replacing this with an error return help resolve this smatch
warning:

drivers/media/tuners/qt1010.c:350 qt1010_init() error: buffer overflow 'i2c_data' 34 <= 34

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/qt1010.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 32731b6464145..3236e2277ab33 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -351,11 +351,12 @@ static int qt1010_init(struct dvb_frontend *fe)
 			else
 				valptr = &tmpval;
 
-			BUG_ON(i >= ARRAY_SIZE(i2c_data) - 1);
-
-			err = qt1010_init_meas1(priv, i2c_data[i+1].reg,
-						i2c_data[i].reg,
-						i2c_data[i].val, valptr);
+			if (i >= ARRAY_SIZE(i2c_data) - 1)
+				err = -EIO;
+			else
+				err = qt1010_init_meas1(priv, i2c_data[i + 1].reg,
+							i2c_data[i].reg,
+							i2c_data[i].val, valptr);
 			i++;
 			break;
 		}
-- 
2.40.1



