Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A1214A9B;
	Tue,  8 Jul 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993350; cv=none; b=L5BdMc0F9v84/U2ajEyqj9ONnIHN+bsYMzgf5D2hqst5E44P87W+QsI3i++UmP0bz9zK2f+w+4bFJOJuINwhtO2YoKr+69K8RBTY9PCdVlvYGGdOoqNbYtIZCbi8woWLkrZl3vs9ksFZDWyn7klToBdBHOFTEVw1D0hP4hEOAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993350; c=relaxed/simple;
	bh=0PEapq4BZ+HnaqPbKqJQOJJ6RUnyWxSsCsOfTXgZYgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM8sPiRARJT3FNNx63fIvc/yV6MPCcGR3RwSey9ALYtILIfbek6x7ejuP3YlXQvlfYMZ6YeSocvYJRuoBqF+yavfGkRnoKCXrnBxzHq3a1CLsYpPszXprpClNZNY4EDCyUDfN8yShG8kktQ+kJAgZnuAWEzl1uSuoQQeSSkP27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWyYsHVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWyYsHVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C1CC4CEED;
	Tue,  8 Jul 2025 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993350;
	bh=0PEapq4BZ+HnaqPbKqJQOJJ6RUnyWxSsCsOfTXgZYgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWyYsHVFHL6rPJzMK6IkKvzRdVGCV0dYT5KnzQ3K1VQPyQfz5zwFsQZz1i8VfGFeW
	 9J6rHfLGF25kM6AHoj1BO67y1HOwXVUROiX8qUJYQ8rZEdXekc7hSnfBWq6uaHeNh8
	 xTLSqBw1/DhhtzAsgtCUCoJlMmUj4dCkHAEIF52Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 013/178] net: libwx: fix the incorrect display of the queue number
Date: Tue,  8 Jul 2025 18:20:50 +0200
Message-ID: <20250708162236.891929255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 5186ff7e1d0e26aaef998ba18b31c79c28d1441f upstream.

When setting "ethtool -L eth0 combined 1", the number of RX/TX queue is
changed to be 1. RSS is disabled at this moment, and the indices of FDIR
have not be changed in wx_set_rss_queues(). So the combined count still
shows the previous value. This issue was introduced when supporting
FDIR. Fix it for those devices that support FDIR.

Fixes: 34744a7749b3 ("net: txgbe: add FDIR info to ethtool ops")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/A5C8FE56D6C04608+20250701070625.73680-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1641,6 +1641,7 @@ static void wx_set_rss_queues(struct wx
 
 	clear_bit(WX_FLAG_FDIR_HASH, wx->flags);
 
+	wx->ring_feature[RING_F_FDIR].indices = 1;
 	/* Use Flow Director in addition to RSS to ensure the best
 	 * distribution of flows across cores, even when an FDIR flow
 	 * isn't matched.


