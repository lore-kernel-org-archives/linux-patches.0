Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645BE4219F1;
	Wed,  4 Feb 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217391; cv=none; b=jvp4F0n4BOdje8yw2lweTSEoSRvuuaJHRsohyZ0xqTTHS3TGdRcpZ96D8T5QS3kjYBPbvwyS7PFrqzSWESxo31FYybKpfcpUvNvlRQPZJuW/5Pz1kiOWJ8ZbwUZ83XreBFT7zfvm0GurIxlrT3l4vNYpho27QW96l4bOwvUpJlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217391; c=relaxed/simple;
	bh=WAOF+j0vKhJwZWj1qPpKdfvrqD8G2qBkkpEQlB/8StU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWC/nCzfbKpI+k50wfZwznRqjbBunXXW8j9xE6k7EWEn3zeDaYR/IrKBeYsFRwl7ObKulPV+dS9H3EBct0EHG8rZa0PL9nQtTjBNXQdyVcmDhcNp1yFSlmYgyhcqgCTw53bhfj5w14RBS6XUR94bhHxRE473RHnaiVKWvOU6RTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MH/Y6uOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH/Y6uOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B87C4AF0D;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217391;
	bh=WAOF+j0vKhJwZWj1qPpKdfvrqD8G2qBkkpEQlB/8StU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MH/Y6uOWSQSNhHC4KdBz77nv0acE52Jbi6HCf6hSdKSvPpIvU5j/CkhBSjh5NrO+N
	 eFejiRnjasFuBSgG/j2+iFP+fIlFj3RtNVRL5gfGHnd5w+sewv1rOz4Koheww1n3S5
	 ukxam8RvkzI9N6SU+h14jbCVakipfJpCt4cyx+9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 202/206] wifi: cfg80211: use system_unbound_wq for wiphy work
Date: Wed,  4 Feb 2026 15:40:33 +0100
Message-ID: <20260204143905.505759051@linuxfoundation.org>
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
@@ -1593,7 +1593,7 @@ void wiphy_work_queue(struct wiphy *wiph
 		list_add_tail(&work->entry, &rdev->wiphy_work_list);
 	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
 
-	schedule_work(&rdev->wiphy_work);
+	queue_work(system_unbound_wq, &rdev->wiphy_work);
 }
 EXPORT_SYMBOL_GPL(wiphy_work_queue);
 


