Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8A4405F7;
	Tue, 26 Aug 2025 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218416; cv=none; b=aolgXimzoX+Q5k8ULld8U+tePg2oFMY/Icq5N7ph7ZiH9QDgsLKbuiWkJl72LnfFUh+KXHS/SWHooaT36YKa4ZlqMnbcMZM18zIsjrJAj3TJmIQ7fbS3/WV+fUmVcm6GA2Jour72+OGV/umW2sgfgxBGqWhZGxfooEoYO2odiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218416; c=relaxed/simple;
	bh=IPtNJoxykuFBJU6beojYocO9xDABIMIynFuyjDKJ3Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLCstiDMCcibRpul+uVW7bqEPJuqDn7G8q319dQkKDUyCvnvYO0aMsI/2OOCLWTCnB1UDyd8tZDGHy3i4nTCaBe+xmrOZsiJCgkPuVcSKvRsABIjpxI5hwUXeLMO4e6+1qJXRHiDVE2kNxFNbkiWfcaH9wFkq1HrdlBiMCAiZyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj3TSdXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj3TSdXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F437C4CEF1;
	Tue, 26 Aug 2025 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218415;
	bh=IPtNJoxykuFBJU6beojYocO9xDABIMIynFuyjDKJ3Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj3TSdXMETyFy5Gpo1leTJUiVHCA1FngyGHgIgiwDojctr3i2eOBLlvhH6LNhOOqo
	 TGt3Ud520VC1eIkB87GFkEz62Oc+PHkArNSuw61YDp3s9QQNGP/MYOAB3rDXoQzSaf
	 COog/DlEhpFY967a6+cUEkoz0LamtAMDeIJBS3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 514/523] ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add
Date: Tue, 26 Aug 2025 13:12:04 +0200
Message-ID: <20250826110937.118715266@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 84967deee9d9870b15bc4c3acb50f1d401807902 ]

The seg6_genl_sethmac() directly uses the algorithm ID provided by the
userspace without verifying whether it is an HMAC algorithm supported
by the system.
If an unsupported HMAC algorithm ID is configured, packets using SRv6 HMAC
will be dropped during encapsulation or decapsulation.

Fixes: 4f4853dc1c9c ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250815063845.85426-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 2e2b94ae6355..4a3f7bb027ed 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -294,6 +294,9 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
+	if (!__hmac_get_algo(hinfo->alg_id))
+		return -EINVAL;
+
 	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
 
-- 
2.50.1



