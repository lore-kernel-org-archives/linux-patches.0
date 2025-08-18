Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A98C30F52C;
	Mon, 18 Aug 2025 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523534; cv=none; b=BAbseStZdENMAKQ448n1MpnWjXoyo7kyrZb25Id6gtx0DAWhfbcDUNh1sZcIzTgWgFMmkctAhcmBqJEgDKGgYTfbwa+5YeW5Jt8+045HkNuZ0r53xUdje/8XNGsgY3aqMGKlyW89OEqjkKfi+9lPe+zXqyQejbk2/UHp1tfhKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523534; c=relaxed/simple;
	bh=E9/au9TPWFUsp3ZG+avTBXTC1cdwuTyPYmGjDA6PaEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmMqAT1vkhfqMtZUqz2iTvVxy+2vwWp7QCwz+HgYyrQmdvc5ptt44HUFDo6aZK1rhOq9sRlJur6+7wst6S85zO+OXbrv6FJAyh307TxpdbpGOOgJG9KUApVh9eXN2UkTKWHw1GLolhka4Dh/I6xO10pCMHmaSMtzBv/Q60OLRh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfEKUVqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfEKUVqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD231C4CEEB;
	Mon, 18 Aug 2025 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523534;
	bh=E9/au9TPWFUsp3ZG+avTBXTC1cdwuTyPYmGjDA6PaEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfEKUVqOZv1IIdqTWq4cRzlgQC7xjR3lWJIt07qCrlPbIxX4stp5UxuKWYYm+qgcp
	 KIGSCxkWGcjQcU7luR74kU3xj5WIoNWWFZ8cKGHgo2F8nBzj29cHPX8LpAX/9KX4IF
	 q4n80j0vMTNXN9SRxPqPq7LOOFqARSmL9K024MdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 201/515] wifi: iwlwifi: mvm: avoid outdated reorder buffer head_sn
Date: Mon, 18 Aug 2025 14:43:07 +0200
Message-ID: <20250818124506.101744566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 422850b29e05e67c9145895bfe559940caa0caa8 ]

If no frames are received on a queue for a while, the reorder buffer
head_sn may be an old one. When the next frame that is received on
that queue and buffered is a subframe of an AMSDU but not the last
subframe, it will not update the buffer's head_sn. When the frame
release notification arrives, it will not release the buffered frame
because it will look like the notification's NSSN is lower than the
buffer's head_sn (because of a wraparound).
Fix it by updating the head_sn when the first frame is buffered.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250723094230.795ec0cb8817.I9ec9a3508e7935e8d1833ea3e086066fdefee644@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 14ea89f931bb..ff59a322fbcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -854,10 +854,15 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	 * already ahead and it will be dropped.
 	 * If the last sub-frame is not on this queue - we will get frame
 	 * release notification with up to date NSSN.
+	 * If this is the first frame that is stored in the buffer, the head_sn
+	 * may be outdated. Update it based on the last NSSN to make sure it
+	 * will be released when the frame release notification arrives.
 	 */
 	if (!amsdu || last_subframe)
 		iwl_mvm_release_frames(mvm, sta, napi, baid_data,
 				       buffer, nssn);
+	else if (buffer->num_stored == 1)
+		buffer->head_sn = nssn;
 
 	spin_unlock_bh(&buffer->lock);
 	return true;
-- 
2.39.5



