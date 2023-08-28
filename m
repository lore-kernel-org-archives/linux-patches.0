Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB211C96
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A35AC433C8;
	Mon, 28 Aug 2023 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218681;
	bh=HV160Rtq+con/wRq5mBpxdY1LxWkNoIDUSk8UDZmZWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZAdrtV2YfekHYYGCuFCtAF5ZLhRKmyOM5tQPSAg2RP0P2HYRg8sH53FNpJe+HuqN
	 HJeGZUcfj6oHYtYGNSAu20igaFNHKZ/5ruuYWvVZF3SV+SJvR24kuqeOYtWkXMFCl0
	 5C7HRUSTbRW5OG/FH8GgpDofduqOFFxx1DopEiWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/122] selftests: bonding: do not set port down before adding to bond
Date: Mon, 28 Aug 2023 12:12:40 +0200
Message-ID: <20230828101157.902342410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit be809424659c2844a2d7ab653aacca4898538023 ]

Before adding a port to bond, it need to be set down first. In the
lacpdu test the author set the port down specifically. But commit
a4abfa627c38 ("net: rtnetlink: Enslave device before bringing it up")
changed the operation order, the kernel will set the port down _after_
adding to bond. So all the ports will be down at last and the test failed.

In fact, the veth interfaces are already inactive when added. This
means there's no need to set them down again before adding to the bond.
Let's just remove the link down operation.

Fixes: a4abfa627c38 ("net: rtnetlink: Enslave device before bringing it up")
Reported-by: Zhengchao Shao <shaozhengchao@huawei.com>
Closes: https://lore.kernel.org/netdev/a0ef07c7-91b0-94bd-240d-944a330fcabd@huawei.com/
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20230817082459.1685972-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
index 47ab90596acb2..6358df5752f90 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
@@ -57,8 +57,8 @@ ip link add name veth2-bond type veth peer name veth2-end
 
 # add ports
 ip link set fbond master fab-br0
-ip link set veth1-bond down master fbond
-ip link set veth2-bond down master fbond
+ip link set veth1-bond master fbond
+ip link set veth2-bond master fbond
 
 # bring up
 ip link set veth1-end up
-- 
2.40.1



