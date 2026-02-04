Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B072542846A;
	Wed,  4 Feb 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217398; cv=none; b=BxlkNpgjuigRyFAcVugeboC3CX/4nIpjbzvIk8kpW9IbOiRL9z2jViSImEoaeZFOCerQzLcSQvdRXUsS4hztwpv88HsX4YZlwbh92K1ic793jPRblURaD0pXptQsNTIMVDQBA7sFy9S5/3zI4czgag+G1otzg7lse33kQbQy0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217398; c=relaxed/simple;
	bh=10aQA4eNKQDndC12SyANmqGbzmbf6VowRTVwa8hkWH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8WtcsRTbHJ5MMawvTQAxc7nkoK2VsdDp6G3S61a/kHDluvUmB2nejLFUYCXHuw8AJYsd7CweKFWv3UQLM2f3Wwe5KPnd/pCfWL3NSrt/IInSR4cQ2FnfNicnBAza9EJLaxW34A6zfdDwu2ianjX/cJ+PehC4aNjuQlcmCkVpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYZhPDEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYZhPDEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28EBC19425;
	Wed,  4 Feb 2026 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217398;
	bh=10aQA4eNKQDndC12SyANmqGbzmbf6VowRTVwa8hkWH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYZhPDEKW55IwZwmzQWKY0/O5mbjkUG8GlaZBYr4MtOI4eS3jmXKzW+7cf1LcusTX
	 gBnGf/DyfP6sXIqNugNKUQz5vmGSDob1aGkefsNGIPRMSoRgCaTqDkrrCz66jJnUc+
	 M5K25MU8v6oI376cCMfAEOhvlncc8AtYf4GB+Kzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 204/206] wifi: cfg80211: cancel wiphy_work before freeing wiphy
Date: Wed,  4 Feb 2026 15:40:35 +0100
Message-ID: <20260204143905.576349040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

commit 72d520476a2fab6f3489e8388ab524985d6c4b90 upstream.

A wiphy_work can be queued from the moment the wiphy is allocated and
initialized (i.e. wiphy_new_nm). When a wiphy_work is queued, the
rdev::wiphy_work is getting queued.

If wiphy_free is called before the rdev::wiphy_work had a chance to run,
the wiphy memory will be freed, and then when it eventally gets to run
it'll use invalid memory.

Fix this by canceling the work before freeing the wiphy.

Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250306123626.efd1d19f6e07.I48229f96f4067ef73f5b87302335e2fd750136c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1127,6 +1127,13 @@ void cfg80211_dev_free(struct cfg80211_r
 {
 	struct cfg80211_internal_bss *scan, *tmp;
 	struct cfg80211_beacon_registration *reg, *treg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
+	WARN_ON(!list_empty(&rdev->wiphy_work_list));
+	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
+	cancel_work_sync(&rdev->wiphy_work);
+
 	rfkill_destroy(rdev->wiphy.rfkill);
 	list_for_each_entry_safe(reg, treg, &rdev->beacon_registrations, list) {
 		list_del(&reg->list);


