Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28AB3EA83;
	Mon,  1 Apr 2024 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986952; cv=none; b=hB7RwpDMFcuV7nWQbgojrGHUlqbwtAlKH/s2hwcZaLw/MixBfxIUSdpnPssxmStsRn+22yk/FOkQXx/JATkn26wUzFUB4vN19oFuFgQwXp07Y1tPGMNnB7WA6h1Pt35eZi2cTECvfzZ7vEMVlXTwT1zBZkhBsnoYkQIn3RKb5E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986952; c=relaxed/simple;
	bh=cQcpSTdMPAAiYE+p4NkwKMe+b5lXUewzc5F1JECH8m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0iRbhunx6YGE0vbqqF+X4y3qnMSvGT39lRrYOQVcIgv2DyMi6tex8IUceCcXYwPmBsBK7RYNrpZPEd3wG8jo33tnSJ4J8AZ2Mrbzd4VUigQX3hLs6fNWOSK4IRYkqSb0AdxtvtcpwAHIxXc49IhFT3UpzGk6vg83+VEvmhiQwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2NIp0d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2NIp0d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A82C433C7;
	Mon,  1 Apr 2024 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986951;
	bh=cQcpSTdMPAAiYE+p4NkwKMe+b5lXUewzc5F1JECH8m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2NIp0d450uxJgu437u51CJ00arq7YjUusmdd8XAcHz/vaPcElfn3pdR0PcBgh0Mz
	 zJeKaRlt+8aK+wy9WTSuOadwdQ0vBJqSEP0SJBcFCuEjYSWHD5QdtGeQXk14OUliJr
	 PrWkWAKFYk8uJnKMIbJV+2QCARm6ygOQnG99tsqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 107/399] md: add a new helper reshape_interrupted()
Date: Mon,  1 Apr 2024 17:41:13 +0200
Message-ID: <20240401152552.381548754@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



