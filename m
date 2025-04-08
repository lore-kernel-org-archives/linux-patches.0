Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF8374C4;
	Tue,  8 Apr 2025 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110964; cv=none; b=YzNQWmIKRW15gldSmGF0IZsRK60zkeKkmQNcA0v40WMH751JSiH/zmO/0SRspTZg42nqFLrGnuTdE3YDmO2QvBazrWF6BRFxuPnMj8XlR+tobqJ1yyDRw4gCjM07/ZXJ9kQXzJCipMywpGQ6Sx6Q9dkj5rPdHMi5h+4K+vVuRLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110964; c=relaxed/simple;
	bh=dXAVTBaP8A+qvB5y8ddwXhwYuoTDL5wOqoDMVvPQegc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv/XHJkHc/wOAx+VZm7d0aXL0v8uF4FMEQw8+JhekRKcTaV7gOL3GKDjNml3cZbMeaQ/P8s/L+8Ea307+h9v+JKAtHws7BXuPWNtxqDDRmUYgXgdO7+tlcuwFnVVZiiUIOnFz1adZ6wCtqDk/pGnKke5j6cU5bv5hPMZBRHPk2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N40c3lED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N40c3lED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B7C4CEE5;
	Tue,  8 Apr 2025 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110964;
	bh=dXAVTBaP8A+qvB5y8ddwXhwYuoTDL5wOqoDMVvPQegc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N40c3lEDnAQ+jVfM7y5f37yor9xWS2guLNb2vj5W6nwQioCaQJ9K4OC+Ky+8zy6+h
	 D8vPIYA5FbwE85paWdfRJyfcnkxRd6G8kwJ+GaoIWYAseg4biFV+H7cPuvNfnqhS9l
	 ZFuJg3R68k4wg96dqkeC7GIRt2JzCCtgdpyYCcwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jan Glaza <jan.glaza@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 209/731] virtchnl: make proto and filter action count unsigned
Date: Tue,  8 Apr 2025 12:41:46 +0200
Message-ID: <20250408104919.143484185@linuxfoundation.org>
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

From: Jan Glaza <jan.glaza@intel.com>

[ Upstream commit db5e8ea155fc1d89c87cb81f0e4a681a77b9b03f ]

The count field in virtchnl_proto_hdrs and virtchnl_filter_action_set
should never be negative while still being valid. Changing it from
int to u32 ensures proper handling of values in virtchnl messages in
driverrs and prevents unintended behavior.
In its current signed form, a negative count does not trigger
an error in ice driver but instead results in it being treated as 0.
This can lead to unexpected outcomes when processing messages.
By using u32, any invalid values will correctly trigger -EINVAL,
making error detection more robust.

Fixes: 1f7ea1cd6a374 ("ice: Enable FDIR Configure for AVF")
Reviewed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jan Glaza <jan.glaza@intel.com>
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/avf/virtchnl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 13a11f3c09b87..aca06f300f833 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -1283,7 +1283,7 @@ struct virtchnl_proto_hdrs {
 	 * 2 - from the second inner layer
 	 * ....
 	 **/
-	int count; /* the proto layers must < VIRTCHNL_MAX_NUM_PROTO_HDRS */
+	u32 count; /* the proto layers must < VIRTCHNL_MAX_NUM_PROTO_HDRS */
 	union {
 		struct virtchnl_proto_hdr
 			proto_hdr[VIRTCHNL_MAX_NUM_PROTO_HDRS];
@@ -1335,7 +1335,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(36, virtchnl_filter_action);
 
 struct virtchnl_filter_action_set {
 	/* action number must be less then VIRTCHNL_MAX_NUM_ACTIONS */
-	int count;
+	u32 count;
 	struct virtchnl_filter_action actions[VIRTCHNL_MAX_NUM_ACTIONS];
 };
 
-- 
2.39.5



