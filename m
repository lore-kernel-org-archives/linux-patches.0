Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB5E49D584;
	Thu, 17 Sep 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665702; cv=none; b=QBgtBgf3hHtFNodQWqgGvyCLm2jcXdmrWw/VeonRaJc8CLaUKoysWLeIZLhWl3NtE3V56f4zJmITfaRyCY3VApfTRLu1OGzni/uMCQEBNkyn6ai0XRq+vJ7b8Vn62JcfQHZWz+mNya8w5sNSEDeFgdvuBKKnVahWDNml5F5iuTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665702; c=relaxed/simple;
	bh=kTqaMd2lkLiBzvrDwxwnw+3YfX3eJv2xbAQyR4ilRkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HE9miRD51jadTWJHYBEUTe9GEJKaklxRIQJozKveLGm/8nV5i5ptZL4Q3PTl+xd/5vUqxRrikY9NI4Ht9V86YJGgLNCMnqJ8/A4vAo8PXMbgctFflnmoE37hWljCzxnN3ww62G08rSUYrufzXjGGRRSPZdQZhMT7Idm3FEM0KGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J82LlCvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J82LlCvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8F21F000FF;
	Thu, 17 Sep 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665701;
	bh=uR9phbCHhKQ9h+nZFP79q6377uFyuLevOjpcdSxp2JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J82LlCvINTWJoeUddg0o4liBPzG31fxQCRdmeneITfNHfWg4q58jcvRvaBME1/QDg
	 vRpq7fEvqHlcBlTER6HL1Y/n3OQCQDlJDAttRrPsTCsc/zUtvAjrkgoHNa8yc8ZvFx
	 f2u8Z051RgWO0mWbXrgGYWi1ZwKrqAYmF48ARxAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0792/1250] eth: nfp: drop the replaced rule from the list when reprogramming fails
Date: Thu, 17 Sep 2026 16:09:47 +0100
Message-ID: <20260917151613.362280190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d6e1998e55367..2e8343e647546 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1699,8 +1699,14 @@ static int nfp_net_fs_add(struct nfp_net *nn, struct ethtool_rxnfc *cmd)
 
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



