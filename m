Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4474B35581F;
	Tue,  6 Jan 2026 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720513; cv=none; b=jLfdqte2kERbWjueRcw0EyUDcvt4+6FF/eWzRLt/G8Pt0UhgmFabiFtW0f4XcMjjWJbxzVixTrzS85aef1tNpb4TesRcQTWEI556MkXj05YucaDSQ0uB7DDNIVi9hOQqHizKUvKljHgp2SpCsb+7OBPduMSLp+LuL00Pnk5onnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720513; c=relaxed/simple;
	bh=RZyDLazuhOHW/4E7QgKM8DX+Mtlm6E9e9OIra200nB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4HW+jpkf7Ki5vXwlHxUFsujIYrnBY8Zcc9wIjUYbwnynPo7XEnR49QZNuLd9/AAXlcIO4MuyqTrqsRrucpctP3Yki/7rorwe0EGzvwrqP34k+5zpE/N2vrRPdQg51iAw7hg05UykW14VvzZ6/tK07ARIrEpEXbCRIzxrMgCYhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+kt6ELy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+kt6ELy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7EDC116C6;
	Tue,  6 Jan 2026 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720513;
	bh=RZyDLazuhOHW/4E7QgKM8DX+Mtlm6E9e9OIra200nB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+kt6ELy7WpcXwhDKYdM7da8HgETnDjffjqakz3ym1QcM4dLK3eZ2LDN7oP0Duoem
	 XE+9Njm9jtFPoGXiqCQv23ys6DxXXMX8VwOFOnHfD+eEnpqKpX8mOI3xi0p1VAcPJB
	 xDaBxCXdKAqPCg5jyd50QBk6Iz7V8BrTgRKXf6Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/567] hsr: hold rcu and dev lock for hsr_get_port_ndev
Date: Tue,  6 Jan 2026 18:00:42 +0100
Message-ID: <20260106170500.935688665@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 847748fc66d08a89135a74e29362a66ba4e3ab15 ]

hsr_get_port_ndev calls hsr_for_each_port, which need to hold rcu lock.
On the other hand, before return the port device, we need to hold the
device reference to avoid UaF in the caller function.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: 9c10dd8eed74 ("net: hsr: Create and export hsr_get_port_ndev()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250905091533.377443-4-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Drop multicast filtering changes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_device.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -682,9 +682,14 @@ struct net_device *hsr_get_port_ndev(str
 	struct hsr_priv *hsr = netdev_priv(ndev);
 	struct hsr_port *port;
 
+	rcu_read_lock();
 	hsr_for_each_port(hsr, port)
-		if (port->type == pt)
+		if (port->type == pt) {
+			dev_hold(port->dev);
+			rcu_read_unlock();
 			return port->dev;
+		}
+	rcu_read_unlock();
 	return NULL;
 }
 EXPORT_SYMBOL(hsr_get_port_ndev);


