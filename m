Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1D050EC01;
	Wed, 30 Sep 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785817; cv=none; b=PFl4BFHuY0RGBrHBlZs2Hi/h4RKTJ59a7fRDK3DsqkAVcoWajaBhxCu08+GyyJOL2kJo7VwZfobxMqUxDWRLsCYtRuTjXJLb2FBKuz4wt7BLds8tVs0mrxUwhQP0DrscMp/u5TsYmk8Ov8sd6BSvz/QeYaJw+T2fRJf+jC9gEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785817; c=relaxed/simple;
	bh=ZRIrClhb6TWXvxWFPm57MjKnF/TBtTzOh9yb4O1OluE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrt2vrS0v8KFd/5YDJRRGmafwwaG3ZtCmCxIOQWNLTRogYa0Njs555Xs129vlI8H2iF+VtNvFRMhSvualsUIc+eI++02l17Qh0s3OUkY1s6SyWIn7C+R3lvx6VpJJvNrAKhgY+17f/kwN3uMIRRrOPE0ZSeva0DxYEi+O82htrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzM+CKs3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzM+CKs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889CA1F000FF;
	Wed, 30 Sep 2026 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785816;
	bh=nYRBOanoW6kLR6y9XW23JmRhXwxz3Y/cbGA37C+1N3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzM+CKs3TUtj6qGco5yBtu/LzS43Xbns7K8zmJvxLiQpxf8DqkAbVCfw+sMDSLDW0
	 vv5LnUN0RtFsypM32UakZlF3A6WF7jPUsPERcsPgg6rF0AXAy4edJUB8QGSykwhA27
	 Aql3MD7z6AqLXo49SeTkV/hilrtk4+CjzyWfiCrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 597/982] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 30 Sep 2026 17:22:13 +0200
Message-ID: <20260930152429.604927395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 2d85e783ae267..aa27eb5278520 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -628,8 +628,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.53.0



