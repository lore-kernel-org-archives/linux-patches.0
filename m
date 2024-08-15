Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6D963C;
	Thu, 15 Aug 2024 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732172; cv=none; b=UU8r+6WEe/jLtmIfrDDfMIYdlYMpg71fGtHHxhUJU8qtVY4V2urltV0Sj3/c933OCDWuGTGgI2xjjl0vj7NAuIuwT5ZvmcirhOXDjX5DC/wlQAK9mPjyL1saqyKWdg6RHzONAQGAjfNtjKPF9/xcVoy2dxWk1zmzeYZV/3LS1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732172; c=relaxed/simple;
	bh=du4+ICsE6/nUN1i+/z+RpTBDPMCd/l9lr41oEwxCWPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSoyGhmXxSTjrO4NohxuF5QU1BprhNWKPCwZpajLFmoVBL05m2qqHkqXiioVe65kwF9syhGwn8qIzLyuoqODLbz80bYKTb3AsOMgKJhrRpMxqMRwbW741+0Ornw/SznrK3Q1ff952e+qozxC5UEcLg9je5lI0c8jp6aiAFlVkQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcHE920D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcHE920D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3668C32786;
	Thu, 15 Aug 2024 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732172;
	bh=du4+ICsE6/nUN1i+/z+RpTBDPMCd/l9lr41oEwxCWPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcHE920DSqUtFitb8ZXaLpE/qwa8gTd7arV+/rzRuu4rwDUankgocnLB7f0zRKnGJ
	 CWs6DNqnoQeW8OuyQd5+Y8NX7gRJ2Kiqwo1xQ+G3W/peQ2osRdmvxAkTzO9Qx1mZ9y
	 Fgc91TW0adcG36pDtee2EFFm+pW6ifdHyPewkCd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/352] coresight: Fix ref leak when of_coresight_parse_endpoint() fails
Date: Thu, 15 Aug 2024 15:22:43 +0200
Message-ID: <20240815131923.009045437@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 7fcb9cb2fe47294e16067c3cfd25332c8662a115 ]

of_graph_get_next_endpoint() releases the reference to the previous
endpoint on each iteration, but when parsing fails the loop exits
early meaning the last reference is never dropped.

Fix it by dropping the refcount in the exit condition.

Fixes: d375b356e687 ("coresight: Fix support for sparsely populated ports")
Signed-off-by: James Clark <james.clark@arm.com>
Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240529133626.90080-1-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index c594f45319fc5..dfb8022c4da1a 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -323,8 +323,10 @@ static int of_get_coresight_platform_data(struct device *dev,
 			continue;
 
 		ret = of_coresight_parse_endpoint(dev, ep, pdata);
-		if (ret)
+		if (ret) {
+			of_node_put(ep);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.43.0



