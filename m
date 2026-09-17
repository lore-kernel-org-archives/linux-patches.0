Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445FB4C10C3;
	Thu, 17 Sep 2026 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659505; cv=none; b=STGqkVMBToTWodHMrcurqKxW06rbE+HIpcZbHdmO5+eI31Qw6WuYEyn8zRM5eKEvBOFruC44yYr/H4ovW49QFpJIwV+Ga6hCGPydR3MYjhGUjlSjS5TOkmEwOU7Bg+0BPZBKXCDe1v9MdWL9fEo7B+dMSasVdPQ3CpVAYApwRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659505; c=relaxed/simple;
	bh=d1tMnKdvx/+Aq7kMngOuTe9ItLuClDU6pZKAX4Mzl4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVH4FdQDU3L75JeFQs+384r8+LQzidza1VAeiuoHqyxZCRCsBnupk8wtc/GGc4mkhL6CT0z4Lb8p2Pj5iAFYG/sYo9ntWid+ia4UXzkrFLN18KeWoczK+lR93M1tKq7UviOYilKfTmjA1tS8K3Dhd9SktwRKSQwV+EvLnsJmLB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhdJlMIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhdJlMIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703C61F00893;
	Thu, 17 Sep 2026 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659499;
	bh=PJ0QYROXTRTSFhf3XNMSvGyocdhK6d/Uh7EY8DDkUMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhdJlMIiMcSzGz3B3Gau98IWl4HwAY3xi4JdI3F9XrZv1bA/JQgPRz5pDHMUdrZAx
	 E6wr4O/8oEEZM1bJSWOMVf5ljMY033wKP9JbBCv8ozQqPJoqXf1rRvBdxt5KRtKJrV
	 gN52iCrR0GH9MYkUy8Ne8cohNmgnJHO95bn4Ro38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 276/733] eth: nfp: drop the replaced rule from the list when reprogramming fails
Date: Thu, 17 Sep 2026 16:09:44 +0100
Message-ID: <20260917151358.239099713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 108bb2142e3a12c9ad625ad662973127a113ddc6 ]

nfp_net_fs_add() replaces an existing rule by deleting it from the
hardware, decrementing nn->fs.count and programming the new one.  If
nfp_net_fs_add_hw() fails the old entry stays on nn->fs.list - only the
success path reaches list_replace() - so the list is one longer than
nn->fs.count, and it advertises a rule whose hardware entry has already
been torn down.

nn->fs.count is what ETHTOOL_GRXCLSRLCNT reports, so userspace then sizes
its buffer one entry short of what the GRXCLSRLALL walk wants to write.
That used to overwrite one u32 past the allocation; since the walk is
bounded it is a permanent -EMSGSIZE instead, as nothing ever resyncs the
counter.

Fixes: 9eb03bb1c035 ("nfp: add ethtool flow steering callbacks")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260903032611.3000029-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 9419e1ed84661..4e83637715e03 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1703,8 +1703,14 @@ static int nfp_net_fs_add(struct nfp_net *nn, struct ethtool_rxnfc *cmd)
 
 			nn->fs.count--;
 			err = nfp_net_fs_add_hw(nn, new);
-			if (err)
+			if (err) {
+				/* mbox broken, adding the old rule back will
+				 * likely also fail.
+				 */
+				list_del(&entry->node);
+				kfree(entry);
 				goto err;
+			}
 
 			nn->fs.count++;
 			list_replace(&entry->node, &new->node);
-- 
2.53.0



