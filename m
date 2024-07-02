Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD0E1BE223;
	Tue,  2 Jul 2024 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940765; cv=none; b=j8Wti33aZLlX00jdbO4ZcSn29m0pUpX3tGrZ7vs6Wa2bI4/trbccNGOoj/Al9y+DQSd9H7Fs2BeEEGxKu4z5UyvyRixeJldt2TSjPp31W3xi3kAcFaO1BGdZowcejbTtkrqsNk5QIcyWtMCWLmY92qGPL04E1/5QkN620pnNuZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940765; c=relaxed/simple;
	bh=sFTV9vs1dKSLnCnuoDA09l/ICyQKvXoOvft3b79T/X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViJbVFPrbitRN0HODWEAuTWcjQKAm/dTAlvf38F7k2TRRj+9ZCwYQTtPWcFMiNAycavUsuTwgEKZtDjtzUTFhwUSjjqhLGd9w5JqX/8u2lZMOyS38kjvKeiu0B9CIk8NpC8ujnr0RelYrdkcvxJvI6tfTEQJzYeFS3dVVpyUgUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7pok8OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7pok8OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D517C116B1;
	Tue,  2 Jul 2024 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940764;
	bh=sFTV9vs1dKSLnCnuoDA09l/ICyQKvXoOvft3b79T/X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7pok8OL2GV2/JUSIvv+fv7n8zCh4UGsdp7a++8o+IB+abBo0SWEBsfhUR5uSs2Zq
	 79t9QP75/oBdWmNR4oNHXiFYRE2O2/9mrYpunK+1YNYT+RMBSNCXCYimeUnQszShL+
	 a5cvwy5IjVQmQgNMq5GW+zXaJgWoe4SzXf8xv2Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/163] openvswitch: get related ct labels from its master if it is not confirmed
Date: Tue,  2 Jul 2024 19:02:23 +0200
Message-ID: <20240702170234.162423035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a23ac973f67f37e77b3c634e8b1ad5b0164fcc1f ]

Ilya found a failure in running check-kernel tests with at_groups=144
(144: conntrack - FTP SNAT orig tuple) in OVS repo. After his further
investigation, the root cause is that the labels sent to userspace
for related ct are incorrect.

The labels for unconfirmed related ct should use its master's labels.
However, the changes made in commit 8c8b73320805 ("openvswitch: set
IPS_CONFIRMED in tmpl status only when commit is set in conntrack")
led to getting labels from this related ct.

So fix it in ovs_ct_get_labels() by changing to copy labels from its
master ct if it is a unconfirmed related ct. Note that there is no
fix needed for ct->mark, as it was already copied from its master
ct for related ct in init_conntrack().

Fixes: 8c8b73320805 ("openvswitch: set IPS_CONFIRMED in tmpl status only when commit is set in conntrack")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Tested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2928c142a2ddb..3b980bf2770bb 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -168,8 +168,13 @@ static u32 ovs_ct_get_mark(const struct nf_conn *ct)
 static void ovs_ct_get_labels(const struct nf_conn *ct,
 			      struct ovs_key_ct_labels *labels)
 {
-	struct nf_conn_labels *cl = ct ? nf_ct_labels_find(ct) : NULL;
+	struct nf_conn_labels *cl = NULL;
 
+	if (ct) {
+		if (ct->master && !nf_ct_is_confirmed(ct))
+			ct = ct->master;
+		cl = nf_ct_labels_find(ct);
+	}
 	if (cl)
 		memcpy(labels, cl->bits, OVS_CT_LABELS_LEN);
 	else
-- 
2.43.0



