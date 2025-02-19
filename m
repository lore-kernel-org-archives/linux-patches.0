Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DB18C011;
	Wed, 19 Feb 2025 08:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953956; cv=none; b=cQhc/ae7xQMmcA5UNqB533Tbd7VypEjKbHk75XpPg2iD8HYU8ihjOY+7LWm1ojeE9Yk8tJaYiq/j9s2FMJgPcQuLORACmGWuY5iTbkqIRwvfDyE253hWNmdq7F6hqGg3T8C+mOiqAuJBB+qIhNdDG0qOjHF+dkNiSWGLN0Aec9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953956; c=relaxed/simple;
	bh=op+v77RSnz36xDRONx+Gl1Go43HViNWM0asz0sPQl/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtDRUcHC2zgjrGbxxGplyLuXjbGfx0UJQNDwFklvEeBhWsXTacA3H8KNr1zKGH5z2CQm/nULZUvQJPAydATY/ZvzAjjUpTsXqe6X+3rcMvlgTjd6zQBMQySo3Jw2G2M2GjGbDIBKfAppqH8a5iiAYXXVmto1JFwXunLKOxbNnU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBQN+pV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBQN+pV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E85C4CED1;
	Wed, 19 Feb 2025 08:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953956;
	bh=op+v77RSnz36xDRONx+Gl1Go43HViNWM0asz0sPQl/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBQN+pV09IeY4t/1zivzb1rv82W3er85zZsB21cyj6mn55XQPB9ubnBm8bjQ0TGj4
	 DN32k94Or6M9c3u7m21cqPcpT/PLWyNt/JL87nF0tCEgxrdg6xvHxzNpVhNZgFZMfg
	 NySssSzksOP4DazdFOLll2/pKA0FEHLgVXai1sj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/274] thermal/netlink: Prevent userspace segmentation fault by adjusting UAPI header
Date: Wed, 19 Feb 2025 09:25:05 +0100
Message-ID: <20250219082611.518188330@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit c195b9c6ab9c383d7aa3f4a65879b3ca90cb378b ]

The intel-lpmd tool [1], which uses the THERMAL_GENL_ATTR_CPU_CAPABILITY
attribute to receive HFI events from kernel space, encounters a
segmentation fault after commit 1773572863c4 ("thermal: netlink: Add the
commands and the events for the thresholds").

The issue arises because the THERMAL_GENL_ATTR_CPU_CAPABILITY raw value
was changed while intel_lpmd still uses the old value.

Although intel_lpmd can be updated to check the THERMAL_GENL_VERSION and
use the appropriate THERMAL_GENL_ATTR_CPU_CAPABILITY value, the commit
itself is questionable.

The commit introduced a new element in the middle of enum thermal_genl_attr,
which affects many existing attributes and introduces potential risks
and unnecessary maintenance burdens for userspace thermal netlink event
users.

Solve the issue by moving the newly introduced
THERMAL_GENL_ATTR_TZ_PREV_TEMP attribute to the end of the
enum thermal_genl_attr. This ensures that all existing thermal generic
netlink attributes remain unaffected.

Link: https://github.com/intel/intel-lpmd [1]
Fixes: 1773572863c4 ("thermal: netlink: Add the commands and the events for the thresholds")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20250208074907.5679-1-rui.zhang@intel.com
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/thermal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/thermal.h b/include/uapi/linux/thermal.h
index 349718c271ebf..46a2633d33aaa 100644
--- a/include/uapi/linux/thermal.h
+++ b/include/uapi/linux/thermal.h
@@ -30,7 +30,6 @@ enum thermal_genl_attr {
 	THERMAL_GENL_ATTR_TZ,
 	THERMAL_GENL_ATTR_TZ_ID,
 	THERMAL_GENL_ATTR_TZ_TEMP,
-	THERMAL_GENL_ATTR_TZ_PREV_TEMP,
 	THERMAL_GENL_ATTR_TZ_TRIP,
 	THERMAL_GENL_ATTR_TZ_TRIP_ID,
 	THERMAL_GENL_ATTR_TZ_TRIP_TYPE,
@@ -54,6 +53,7 @@ enum thermal_genl_attr {
 	THERMAL_GENL_ATTR_THRESHOLD,
 	THERMAL_GENL_ATTR_THRESHOLD_TEMP,
 	THERMAL_GENL_ATTR_THRESHOLD_DIRECTION,
+	THERMAL_GENL_ATTR_TZ_PREV_TEMP,
 	__THERMAL_GENL_ATTR_MAX,
 };
 #define THERMAL_GENL_ATTR_MAX (__THERMAL_GENL_ATTR_MAX - 1)
-- 
2.39.5



