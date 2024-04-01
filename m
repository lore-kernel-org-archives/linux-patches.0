Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E2A3D961;
	Mon,  1 Apr 2024 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988257; cv=none; b=igHHYlXfqluWphGRHx3UIkHKSZWCZExA1Zpci2nPDB3ub54Q8+bEfprJtCKugI9P38kZVQpMTQ6ciInyDOxEjOw1glOg8w9eCkef1jaUHH7qf0vCKKJHW/QyWBw5k341lgKD5g4GzaQZpJboZi7cZ1yaEcfojQAWYdQWuNbEDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988257; c=relaxed/simple;
	bh=Etq7OAgXmOruMNuKydRFiuG7oSBp1rpdEfgCJttc/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmI3IYDwpFNQsw6NPp82x7Mg2NrIKh6vxjUdoAZM/axGV5G4wicAIb98SnXGpx/AoMVcqkXG7pxHmqhQLgfwdkiyqURceG+zQHza81+f+AYO1tpRGxX+gbOi3JOCNBCtId6QYxSGUfnUjC2FqXjwNmJPrpbGYjX3B211cqX7dyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l26dDA9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l26dDA9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CACC433C7;
	Mon,  1 Apr 2024 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988256;
	bh=Etq7OAgXmOruMNuKydRFiuG7oSBp1rpdEfgCJttc/4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l26dDA9aZ2UTk0ekUh1Kxb/hovnNR7Bx3Ch124fpu8KeTzRoY48IruDFT9Md3SuuN
	 jqWkMzwtXPit5W33ONY/rOZg8PV0Gzuvx55TDRTYlos9N/USLLMVuLf8JTHLyZ39fJ
	 47l020WHykd9OeDg2fWBRXS60bClAJJICJtSUR7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 103/432] md: add a new helper reshape_interrupted()
Date: Mon,  1 Apr 2024 17:41:30 +0200
Message-ID: <20240401152556.199505912@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 503f9d43790fdd0c6e6ae2f4dd3f70b146ac4159 ]

The helper will be used for dm-raid456 later to detect the case that
reshape can't make progress.

Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-5-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index db0cb00e4c9ac..ea0fd76c17e75 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -571,6 +571,25 @@ static inline bool md_is_rdwr(struct mddev *mddev)
 	return (mddev->ro == MD_RDWR);
 }
 
+static inline bool reshape_interrupted(struct mddev *mddev)
+{
+	/* reshape never start */
+	if (mddev->reshape_position == MaxSector)
+		return false;
+
+	/* interrupted */
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return true;
+
+	/* running reshape will be interrupted soon. */
+	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		return true;
+
+	return false;
+}
+
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-- 
2.43.0



