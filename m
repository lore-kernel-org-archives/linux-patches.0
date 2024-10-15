Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9E1D5161;
	Tue, 15 Oct 2024 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998411; cv=none; b=VpVob4cc3IHLAtgDxOCiY4Noo4jeLdBaJdCaaCADVLPVtCnqsFrdivLRKTXrRps9BE5uY6+b+P8fWYtw5SqqR2ekmy1ZnzWoGTVPUVa+W0qNdWM9Zz8Y6rSCN7pSiFHvdTm+sjhKZ86WuJZZewQ1FpGnP9eXQswA9hpBh4pmNn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998411; c=relaxed/simple;
	bh=hvtClij2oyGF+LPeqSOMqVSbNRshvraBt84e8Q9wauI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNs85zzBI5V3a4blAnEBuavg3eNr/vqA7vjeVHrK8mBCaGE8fKBrpWmPhRzFTy+U1UBBoM3hKIQ5A/CGHcBC8JczexQkcfPXC+WPc7iL3yH4xaT2zC4XM/neIUNxSum175YwGpw+bBBMUYhR/UTuqCZPOJdGOYCwAkrIjyGCJyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ne1l/PAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ne1l/PAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B12C4CEC6;
	Tue, 15 Oct 2024 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998411;
	bh=hvtClij2oyGF+LPeqSOMqVSbNRshvraBt84e8Q9wauI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne1l/PALuqbE7iPB5nAqI3u2gt2aMqeMOLVXjiTsAEmvBb0bacmdgimMwzZV7eXKg
	 jbcDLTuhqFFQQ3pnEHL/X/b53lpHLin3HiSJzr9iTUspftpREh5GSG/zCd25ZTMg8s
	 6JM45u9fOixQhfP914tixHX+jHUqR8o7uc0xrb4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/518] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Tue, 15 Oct 2024 14:46:12 +0200
Message-ID: <20241015123935.068575567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df85e928b97f2..47ab755aee949 100644
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



