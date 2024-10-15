Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A51EF933;
	Tue, 15 Oct 2024 12:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994255; cv=none; b=s7FlOdzqwJQzWovMz3bMIzXxIaL96C87uEadnFFxuZTe+B+d7bKUeWyuXjz8fA30elWp3y5TbvFZfVxeGwEBo7S1mxG7mlX0H1V2cgbtGODz2l0P7to6qb0wvjpvVg4jnEVm1m/nKQLCtUviW/mI6pAav8OQM+yKeOb+rMjviI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994255; c=relaxed/simple;
	bh=q1+ZrtkEoWpd8AxyK2YgBGpbl110mtxWSp/f98ov0bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEHT7UWLT1D3XVydH+xoT48XvustCGa1H7qqKgn3EEkq/Lm0OG/8VQ65gx5zP83F/Bht75UnD36oGTUQC/6Hh/vTC+hWCQ+imrigVW7SxoufqlBvFG0wXnj3rDxkC/q2vJ7Q1/142Q09+CIuOZPCmB2rk72SFPFCU3Jz1T0ul70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8SSaauP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8SSaauP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E4BC4CECF;
	Tue, 15 Oct 2024 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994255;
	bh=q1+ZrtkEoWpd8AxyK2YgBGpbl110mtxWSp/f98ov0bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8SSaauPpxD1YKXUQrEtLjZVXSPQ1WvBr1B3TNLstxwZEVjf6RGuhSgSXf7Bq7UG3
	 kV0xCweuyHXBMAx9j5ip/yhwjvdpQElPnN7Q/fzeBL7kh+vJV73auISwql3c3EsQGZ
	 k8dUsByk3T4My6evIfEEAuA//zoXWeJQB2EnTT4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 620/691] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Tue, 15 Oct 2024 13:29:28 +0200
Message-ID: <20241015112504.941366989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c0fd973c108cdc22a384854bc4b3e288a9717bb2 ]

Return -EIO instead of 0 for below erroneous bus attribute operations:
 - read a bus attribute without show().
 - write a bus attribute without store().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240724-bus_fix-v2-1-5adbafc698fb@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index d171535fc18f5..548291d15c290 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -104,7 +104,8 @@ static ssize_t bus_attr_show(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for reading a bus attribute without show() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->show)
 		ret = bus_attr->show(subsys_priv->bus, buf);
@@ -116,7 +117,8 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for writing a bus attribute without store() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->store)
 		ret = bus_attr->store(subsys_priv->bus, buf, count);
-- 
2.43.0



