Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF3268FD8;
	Tue,  8 Apr 2025 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111591; cv=none; b=CgCppnvmrM/V4EilT23V2hzuVjt6E3qpCnz5BRSYYGr6UTi/PKK18mmpODutv0Rk1bv36o9ykON2pfI+djobKAoJC0mlrBWDLaP2lUhY38YtavEH/Vl9uR8dJ44HrC2Qb5XrXPhpWrHyCvHoqxI6QTyID8z68J7KVfriUw1sBXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111591; c=relaxed/simple;
	bh=V0aJtgdz+YU33SPbnSAGHhCk2ykbPTVvCTN/GIvaBc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwCRdxaYNDt12ZPkFjHFYI6Elr3GQeO+v5M68WRMDo9YTEsMnzBjUZP+65e7Kl1vtT2uWukpqLD/5rMnarSwToLga08sRq8D34e+Cl1NCa175qdAbCM0jKHrd9wVWCv+S6SvmB4g8CIwoNnflYoVfY/9vf3dLGixpDSWQfoA+18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iM6ZuBz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iM6ZuBz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7125FC4CEE5;
	Tue,  8 Apr 2025 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111590;
	bh=V0aJtgdz+YU33SPbnSAGHhCk2ykbPTVvCTN/GIvaBc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iM6ZuBz4OJdf+Kv7+D2Pa/NvxMu/VsPR0t44Jzu3MpmEPJg7EDZFQgVk7zNpu/D7t
	 7UtT0WicJ/kFc62U9KZ6hDEvX+WBCho61zu5h1w0OGi0pHFRJg0+PoN+C02FK3Hyup
	 IRtHDYa9u/o2dT5RtC5wan+UY7xBC6QieDsiQAEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 486/731] soundwire: take in count the bandwidth of a prepared stream
Date: Tue,  8 Apr 2025 12:46:23 +0200
Message-ID: <20250408104925.581203745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 08ae0d61c3d79bb5d52ae30ad4fc12442e966a23 ]

When a stream's state is marked as prepared, it is ready for
playback/capture. Therefore, we need to include the stream's bandwidth
when we calculate the required bandwidth of a bus.

Fixes: 25befdf32aa40 ("soundwire: generic_bandwidth_allocation: count the bandwidth of active streams only")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://github.com/thesofproject/linux/issues/5334
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20250310073653.56476-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/generic_bandwidth_allocation.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index 59965f43c2fb0..f78a2a16581a7 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -194,10 +194,11 @@ static int sdw_compute_group_params(struct sdw_bus *bus,
 				continue;
 		} else {
 			/*
-			 * Include runtimes with running (ENABLED state) and paused (DISABLED state)
-			 * streams
+			 * Include runtimes with running (ENABLED/PREPARED state) and
+			 * paused (DISABLED state) streams
 			 */
 			if (m_rt->stream->state != SDW_STREAM_ENABLED &&
+			    m_rt->stream->state != SDW_STREAM_PREPARED &&
 			    m_rt->stream->state != SDW_STREAM_DISABLED)
 				continue;
 		}
-- 
2.39.5



