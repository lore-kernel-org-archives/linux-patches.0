Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3615C26B96A;
	Tue,  8 Apr 2025 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116803; cv=none; b=dHPMJ6kIxnT8inVA4uD+lzwxksV93oLwJHPA42/y/aQ7+b7clumOtNEHtDi3QUSkB2Ct6q8T3pkHGlhe2NNvKCUTA3aDwiPSFsbrtaVvO5rbLpG2xZxsp/25qUZwSbpgpeWZkYotyofTnDW1SG6XM+85hvqIpVJDGn8gOH5eGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116803; c=relaxed/simple;
	bh=WfG8DOzYKaJP2AfAzq/QBYoburwMIIrGB53ki5avYJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRxTjFMQrNWUGy40vgBMh1wM6MP7/MOaooTWOV5ITYx0wAuRpDAktG7rDAPEsVedJsQhZYba0Zlzzt6BRzkw0ddByOtyagmbXf9HAJw3EBH28Ngp9lJgor9Ej8I6CtTwaXp7Jo4C/aBl633+MJWBrl4zcdhRy4IboLJgIW8ZHx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snVXP+qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snVXP+qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A40C4CEE5;
	Tue,  8 Apr 2025 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116803;
	bh=WfG8DOzYKaJP2AfAzq/QBYoburwMIIrGB53ki5avYJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snVXP+qPDWY+mgIWoFONgg3gYxed4Uzcrr0z7KUM00LMeQvD3jQcv4gkWwJfgVL2B
	 EwrHBLhDWhcCRdfFkcTpGyBmnu9mM3dsMpyqL+3tLTzxLcO+BJcFdwWiRD4OZSDPu0
	 VhYn4/A6OJdCQyZ74xjEmWRap4fAKEXXbV6TQiAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/423] exfat: add a check for invalid data size
Date: Tue,  8 Apr 2025 12:50:01 +0200
Message-ID: <20250408104852.171427168@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 13940cef95491472760ca261b6713692ece9b946 ]

Add a check for invalid data size to avoid corrupted filesystem
from being further corrupted.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index e47a5ddfc79b3..7b3951951f8af 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -639,6 +639,11 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
+	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
+		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
+		return -EIO;
+	}
+
 	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
 	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
 		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
-- 
2.39.5



