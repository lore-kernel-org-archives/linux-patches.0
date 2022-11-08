Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2157D15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BA9C433C1;
	Tue,  8 Nov 2022 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916115;
	bh=bqPkD1QPbT3aDJ0oBiF3trdy5bO/vWDb5s5mUqQjazo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqNF+7kx1/lSTMv1luWBRzb6JeMJ3Z08tngDstug5WlHJQ6oIeciSvvD0hP88oCyr
	 p2zJWJOmHeFdf6KxdvdVLp9IVJwSxS3h2pkr4BpsPl3dDxq0T0jbn/wjwfpgQUcZma
	 xH37DeMB1SC9HZpVePW55FOgnP+i9lUspEu53JfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/144] s390/cio: derive cdev information only for IO-subchannels
Date: Tue,  8 Nov 2022 14:39:04 +0100
Message-Id: <20221108133348.123420265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 0c3812c347bfb0dc213556a195e79850c55702f5 ]

cdev->online for the purge function must not be checked for the
non-IO subchannel type. Make sure that we are deriving the cdev only
from sch-type SUBCHANNEL_TYPE_IO.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 1b6074112742 ("s390/cio: fix out-of-bounds access on cio_ignore free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index c27809792609..ce9e7517430f 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -792,10 +792,13 @@ static int __unset_online(struct device *dev, void *data)
 {
 	struct idset *set = data;
 	struct subchannel *sch = to_subchannel(dev);
-	struct ccw_device *cdev = sch_get_cdev(sch);
+	struct ccw_device *cdev;
 
-	if (cdev && cdev->online)
-		idset_sch_del(set, sch->schid);
+	if (sch->st == SUBCHANNEL_TYPE_IO) {
+		cdev = sch_get_cdev(sch);
+		if (cdev && cdev->online)
+			idset_sch_del(set, sch->schid);
+	}
 
 	return 0;
 }
-- 
2.35.1



