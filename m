Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAF81C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F237CC433EF;
	Mon, 20 Mar 2023 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324939;
	bh=WKWGOh7P8dwbtyzqCjRU4JbokhqyWKBW6VLePktxMuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPiki6vqwxxDIAUXaG7gP720tvZMEXG/vcC3f/QJ8IWeL2M/9RSLF1UBh5Jw9Mgct
	 ojT3neVRqJCYArKQfSLqosjoMGL0G240cY32YVVvxkqYwuuSCUsta7zT2wzb5SWY+F
	 lg02Qd+6lqR40S13iJKyr/ZjbQ+NeaveQbVGVJQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/115] ethernet: sun: add check for the mdesc_grab()
Date: Mon, 20 Mar 2023 15:54:22 +0100
Message-Id: <20230320145451.503282399@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 90de546d9a0b3c771667af18bb3f80567eabb89b ]

In vnet_port_probe() and vsw_port_probe(), we should
check the return value of mdesc_grab() as it may
return NULL which can caused NPD bugs.

Fixes: 5d01fa0c6bd8 ("ldmvsw: Add ldmvsw.c driver code")
Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/ldmvsw.c  | 3 +++
 drivers/net/ethernet/sun/sunvnet.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 50bd4e3b0af9d..cde65f76e5cef 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -290,6 +290,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 58ee89223951e..dcdfc1fd3d2ca 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -431,6 +431,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
-- 
2.39.2



