Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8C320CAB;
	Mon, 18 Aug 2025 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523530; cv=none; b=k+XJVvp0wDLfaNkWZ4g/bWLr6fLWxzeJUKd92MBD2xclzkYmc351PYcjwJjszfUuoVO/NuMdvdgI/vbObNFr5MOYv9ZOuWP1oiSxCJ/Wb6vnryv/8CXMaiEhksG1oeRmKcGAdAuvohXv84nnhYZU76KO+NOUU4IQAL+e6ZBZKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523530; c=relaxed/simple;
	bh=OL9Y2WKrBvGnoRDISHh9XyyuBIo+J53jqm78Pl4oZyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1+cuh+EIEB/aypyqmrFFPfG5OoF8vQb14anqnPzlyugxO6Q3msnI/azfxcEvWYwkcqE5iNVa/D51edKrgaE1v/minP+SsVwTyoRdZZ+8+1fRNLkyD10ycHQMZIvr1FRDdncpbGatgfZT8pxSXMot/Sf2Tp/d149lqpehhtB2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9qzJZOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9qzJZOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38B1C4CEEB;
	Mon, 18 Aug 2025 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523530;
	bh=OL9Y2WKrBvGnoRDISHh9XyyuBIo+J53jqm78Pl4oZyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9qzJZOePFdsNGQJ9vjRhCJeiHLhdKda/qSakCkowne5e99nUjUtJqgTYfNp5ugMq
	 HEUMv9OEPcQs7ouDjcZ02gNcG7E5cwypWRze1Ts5ije3/c3gZ8dkohHL+H4qNqAK2D
	 lnwc+3wf+1Kd4PAHLsEedh3hkeyjveU916SW2eOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 200/515] wifi: iwlwifi: mld: avoid outdated reorder buffer head_sn
Date: Mon, 18 Aug 2025 14:43:06 +0200
Message-ID: <20250818124506.063717737@linuxfoundation.org>
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

[ Upstream commit 666357bf3e57c6a68be128825775aee14f9a24f7 ]

If no frames are received on a queue for a while, the reorder buffer
head_sn may be an old one. When the next frame that is received on
that queue and buffered is a subframe of an AMSDU but not the last
subframe, it will not update the buffer's head_sn. When the frame
release notification arrives, it will not release the buffered frame
because it will look like the notification's NSSN is lower than the
buffer's head_sn (because of a wraparound).
Fix it by updating the head_sn when the first frame is buffered.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250723094230.e1f62a9a603c.I7b57a481122074b1f40d39cd31db2e5262668eb2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index 687a9450ac98..aab11c61a82d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -303,10 +303,15 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 	 * already ahead and it will be dropped.
 	 * If the last sub-frame is not on this queue - we will get frame
 	 * release notification with up to date NSSN.
+	 * If this is the first frame that is stored in the buffer, the head_sn
+	 * may be outdated. Update it based on the last NSSN to make sure it
+	 * will be released when the frame release notification arrives.
 	 */
 	if (!amsdu || last_subframe)
 		iwl_mld_reorder_release_frames(mld, sta, napi, baid_data,
 					       buffer, nssn);
+	else if (buffer->num_stored == 1)
+		buffer->head_sn = nssn;
 
 	return IWL_MLD_BUFFERED_SKB;
 }
-- 
2.39.5



