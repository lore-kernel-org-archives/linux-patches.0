Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00012D1F40;
	Wed, 30 Sep 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793906; cv=none; b=SPHk3SERGvLJaXljJuf7kzlsxKcKFujAW5TDVGAuvt62nR4lU2AbQ3gAQ87J2tUwpH03TKPjGEgkK95D5DvZj1r1ywpuy4Pd5ZKLym1bRv33m7Pv47/6qsgERZp6Ld1hzM9ZN55dUgvNn6FbR5/8Y/OGxSGPqPmK0tw9GMILIMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793906; c=relaxed/simple;
	bh=WeNVBLMzO+goDeBdrqeJYkjzlP3ohvue2fEtksMhxLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uvu1sauzvulqwvEe2+EKBAxYIAXll2Jj/DALCmxEOidjP9xkXXgj5qiOjtdPKwzgMp30T2XRsn3eKnNzAKtKNDZg0w+V+rEG5HV+osUZMCqHen6kODboOqvmn7iKaPhShIJgrDNhiwQJSLdXPM6pBPCzjyBjPduBpceBxQ8CFa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoU49RP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoU49RP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21FA1F000FF;
	Wed, 30 Sep 2026 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793904;
	bh=AER2x6i+g20Fw3vh3s6vzH5WOmenEQrlcYTXGoAIxgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoU49RP5IsORqROWBrbatUD/ZlHxihsXJllWY5BLRQ+mgEbB7V0vbaKLhETjkhPYn
	 8JgAj/kJotf2LLhRUVY0imYXYeas2Y2m9x5ag9EKFlVT6LsNWURdBGZnnat8Mg9vNm
	 89LMZFGIRXVY7IEoHVh/PwTRer9G1Wvd2Zn7r8gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0024/1193] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Wed, 30 Sep 2026 17:11:48 +0200
Message-ID: <20260930152434.831330678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 99a3f4317b5ca..834fb56bde026 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1025,6 +1025,7 @@ static void tb_service_release(struct device *dev)
 	ida_simple_remove(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 struct device_type tb_service_type = {
@@ -1133,7 +1134,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);
-- 
2.53.0



