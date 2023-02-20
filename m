Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB2363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A817C4339B;
	Mon, 20 Feb 2023 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900356;
	bh=DyLMqw/wU9+Sw+P62UvMVjM3SLkgIev1sYNapjRizWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL0s6BOVh2SVgyufgiPP7zU0Ae40CLRvfw35Gxfuw2HvlU1SXPbWl91IxILuYm+2s
	 8VvjbC+fG2U09IURRzOp5ttDlny3YepPkUK5eq7WhNJkFc6+UGa/NkadKWuyAcvf3D
	 U4n2zw7RmdUmht4jAW6ut8KZdcIri4+d0/5d2S9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lianhui tang <bluetlh@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 48/53] net: mpls: fix stale pointer if allocation fails during device rename
Date: Mon, 20 Feb 2023 14:36:14 +0100
Message-Id: <20230220133549.881242028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

commit fda6c89fe3d9aca073495a664e1d5aea28cd4377 upstream.

lianhui reports that when MPLS fails to register the sysctl table
under new location (during device rename) the old pointers won't
get overwritten and may be freed again (double free).

Handle this gracefully. The best option would be unregistering
the MPLS from the device completely on failure, but unfortunately
mpls_ifdown() can fail. So failing fully is also unreliable.

Another option is to register the new table first then only
remove old one if the new one succeeds. That requires more
code, changes order of notifications and two tables may be
visible at the same time.

sysctl point is not used in the rest of the code - set to NULL
on failures and skip unregister if already NULL.

Reported-by: lianhui tang <bluetlh@gmail.com>
Fixes: 0fae3bf018d9 ("mpls: handle device renames for per-device sysctls")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mpls/af_mpls.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1344,6 +1344,7 @@ static int mpls_dev_sysctl_register(stru
 free:
 	kfree(table);
 out:
+	mdev->sysctl = NULL;
 	return -ENOBUFS;
 }
 
@@ -1353,6 +1354,9 @@ static void mpls_dev_sysctl_unregister(s
 	struct net *net = dev_net(dev);
 	struct ctl_table *table;
 
+	if (!mdev->sysctl)
+		return;
+
 	table = mdev->sysctl->ctl_table_arg;
 	unregister_net_sysctl_table(mdev->sysctl);
 	kfree(table);


