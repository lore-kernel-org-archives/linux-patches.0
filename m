Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07243FD3F;
	Mon, 31 Aug 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184968; cv=none; b=UHLoC9Zq6H1nTqVvb2ICefNzHQfO9Chq+P02BhRVcA7i6olwMSUDuxfBvJE/YeRJbK4K0MqP4zrLz0fIWBf+hdHMcrxonmd2EKxgkdSspNY3o4Te52As9FIlY5P+ROy/hqqc1iLDQjozjm/UkH8XnygkyMk4OoIVhkb07wAON/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184968; c=relaxed/simple;
	bh=Q3tat8MXZwty1o7YAM+xtPI52CtpSe0lEs+tw5p1ttA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G40rh+qKAaVUvgEDOEkIfgkWd68zzH8wfSsdvlVnr+1zjWJxXIqZzlGA8Q3w7KMyCrmix/Qs1lPji2/N6KHsbBVcnVvoKmQXMVVEMPLmYqadBRHyY3qThkekGarMLki5RKdJdRhs/4XR950/SROXYnZpBNJ0q61PI3KcAlqKa74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2ciSHeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2ciSHeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E831F000E9;
	Mon, 31 Aug 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184967;
	bh=hJu/SExb0NDzHUrQaO2sbSQE6fEE2ils9N1RJKLuHrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2ciSHeJ9xt4hJQ/c7BPKJMOKuJr7r3DCKEgz5EHlxStGPei2OqNUjh3wjbzjJLVh
	 OXUQX4TTgcK2X9lMLEpbuIBnDrdu8xCHdcLf3WJ8tDMAlbasIIsVRbBAF68YTnbXJK
	 2PKYaNUur8gc40ljYVkKQ1o7jcn3NrlTAdTK1C2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/92] Bluetooth: hci_event: validate LE Set CIG Parameters response
Date: Mon, 31 Aug 2026 15:34:58 +0200
Message-ID: <20260831133402.796997302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 0acd4eeb4b225b9bebbf9ef96cc10cdd79b94899 ]

The Command Complete dispatch validates only the fixed part of the LE Set
CIG Parameters response. After that part is pulled from the skb,
hci_cc_le_set_cig_params() trusts num_handles and reads each entry in the
trailing handle array.

Matching num_handles against the command's num_cis does not guarantee
that the response contains the advertised handles. A truncated response
from a malfunctioning controller can therefore make the handler read
beyond the skb data.

Validate that the remaining skb data contains all advertised handles.
Include this in the existing response validation so malformed responses
also follow the established CIG failure handling.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3793,8 +3793,10 @@ static u8 hci_cc_le_set_cig_params(struc
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
 	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_CIG_PARAMS);
-	if (!rp->status && (!cp || rp->num_handles != cp->num_cis ||
-			    rp->cig_id != cp->cig_id)) {
+	if (!rp->status &&
+	    (!cp || rp->num_handles != cp->num_cis ||
+	     rp->cig_id != cp->cig_id ||
+	     skb->len < array_size(rp->num_handles, sizeof(*rp->handle)))) {
 		bt_dev_err(hdev, "unexpected Set CIG Parameters response data");
 		status = HCI_ERROR_UNSPECIFIED;
 	}


