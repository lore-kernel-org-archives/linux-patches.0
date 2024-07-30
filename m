Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78A29A2;
	Tue, 30 Jul 2024 16:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355514; cv=none; b=mO4uJZLe4z44fev2zWTmqOOXvb4zTl1Ug/3BctvnXSkdW7njnQ9sk44oIIndh7XURHgJOp9VOttMWxN5NcBjcGZM8tA4L2GEjWyUNN6ILlPYto9p4Y3WSQwWuN204FTnN9ICHeR2qekvtCX4RljIuej8rphYhAH5GhRbSLrNm6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355514; c=relaxed/simple;
	bh=XMvpMSUuv5o9EC/Pg1RPv0i72QU9hgf7Llw6DIW4P9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAuSBSYR82XR7cZgLpFnxSLfUvO8qyIz93fOVYQmvSonz72Z7wQ6z7DjudaQtVBrczr802aM/upwpXzgpOn/mQvY2MTyPg8eEwFJ4fmx2kdC6anLSJ+j3MhD/w6oKuSwul6BKNOux6wbQCcLc5hmI5Bkfq63fs7cI8e79ECa1IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxfuVSVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxfuVSVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFED9C4AF0C;
	Tue, 30 Jul 2024 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355514;
	bh=XMvpMSUuv5o9EC/Pg1RPv0i72QU9hgf7Llw6DIW4P9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxfuVSVjdEJ0+7CfhWYKsvrzYYtNCKGhD2Mqj0U/Jz+FQK+2Ra+0TCh6vCtqu6n8Y
	 +Huz3mYMFXKtyfjan0a5DnG4O5e8nThAMi6l+vB43+MnuKZ/9so7wr9HbIks4/zahO
	 dgh3SrwfiesCMSEYZPAoxap0CwzawkJNxfC1LnBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 062/809] cpufreq: sun50i: fix memory leak in dt_has_supported_hw()
Date: Tue, 30 Jul 2024 17:38:58 +0200
Message-ID: <20240730151727.093480234@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 6282fba6abd7c3c8896c239cc8aa9ec45edcb97b ]

The for_each_child_of_node() loop does not decrement the child node
refcount before the break instruction, even though the node is no
longer required.

This can be avoided with the new for_each_child_of_node_scoped() macro
that removes the need for any of_node_put().

Fixes: fa5aec9561cf ("cpufreq: sun50i: Add support for opp_supported_hw")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sun50i-cpufreq-nvmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sun50i-cpufreq-nvmem.c b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
index 0b882765cd66f..ef83e4bf26391 100644
--- a/drivers/cpufreq/sun50i-cpufreq-nvmem.c
+++ b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
@@ -131,7 +131,7 @@ static const struct of_device_id cpu_opp_match_list[] = {
 static bool dt_has_supported_hw(void)
 {
 	bool has_opp_supported_hw = false;
-	struct device_node *np, *opp;
+	struct device_node *np;
 	struct device *cpu_dev;
 
 	cpu_dev = get_cpu_device(0);
@@ -142,7 +142,7 @@ static bool dt_has_supported_hw(void)
 	if (!np)
 		return false;
 
-	for_each_child_of_node(np, opp) {
+	for_each_child_of_node_scoped(np, opp) {
 		if (of_find_property(opp, "opp-supported-hw", NULL)) {
 			has_opp_supported_hw = true;
 			break;
-- 
2.43.0



