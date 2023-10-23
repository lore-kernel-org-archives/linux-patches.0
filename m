Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC79620F1
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTRfRetR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52773C433C8;
	Mon, 23 Oct 2023 11:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059168;
	bh=an2cjlTFcES6t6uF7x0au4MOwAMZiZWZ3oikDF6C4e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTRfRetRDJbPU3OxnRh+UGmz+QfftdPJMpdUbQDItUYji15KP0vcAfdwjqB9DDxMQ
	 MdA03YkN50Z5Qaje4uV10C9lJjM2+61a9sVgJtkPb0X2y/cV4NAWJbZfOIVhErA/l2
	 +PNR6aaxVFma6iDX7ilGoJCFRyXbkZMRdhP0P/Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.5 060/241] wifi: cfg80211: use system_unbound_wq for wiphy work
Date: Mon, 23 Oct 2023 12:54:06 +0200
Message-ID: <20231023104835.372362063@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 91d20ab9d9ca035527af503d00e1e30d6c375f2a upstream.

Since wiphy work items can run pretty much arbitrary
code in the stack/driver, it can take longer to run
all of this, so we shouldn't be using system_wq via
schedule_work(). Also, we lock the wiphy (which is
the reason this exists), so use system_unbound_wq.

Reported-and-tested-by: Kalle Valo <kvalo@kernel.org>
Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1622,7 +1622,7 @@ void wiphy_work_queue(struct wiphy *wiph
 		list_add_tail(&work->entry, &rdev->wiphy_work_list);
 	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
 
-	schedule_work(&rdev->wiphy_work);
+	queue_work(system_unbound_wq, &rdev->wiphy_work);
 }
 EXPORT_SYMBOL_GPL(wiphy_work_queue);
 


