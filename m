Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D959178381;
	Tue,  2 Jul 2024 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940030; cv=none; b=F4OuIerD5XyIF2u4nX/vv1lzAKaBJlY2/98rhrA2MGhTAa0jHE9hHbZu5Wz3k9b0HLWJ/vnUAoKu2MLR+Y0nrZsWzQXLF6suXxVQJmgYN2s5fo2ZRlgYe7pP/iES3S6hK5junlSvLZmBuDwY8Y2B4VJT5hE5RFZPIDjmTlY1jis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940030; c=relaxed/simple;
	bh=RIlrVx70uNlV4kgDa3/bV4yG1+RuSWOpRGt4ZU6jL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDRu5vL+0J+RCbepyOvEw23t/weQXkq9jW2Jbl5oMTTNvQG+Lxw1hWJI+B062XgvO0L0jAfn1evB379ukChleorEKcmRCoagbuKqU894A2WcDKpaB2bpuuHT9fn80O1Ew0JECRrxoYR6pEjd1w4jU6VrjlgJXHM1s0fMfqq2vn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlIFCku8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlIFCku8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0393FC116B1;
	Tue,  2 Jul 2024 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940029;
	bh=RIlrVx70uNlV4kgDa3/bV4yG1+RuSWOpRGt4ZU6jL6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlIFCku8DWOJ7P/wXgYtE13DOdIW8+34nArVa2BdzmBwMc5Olubqd2hAcb+mPymZU
	 0ZhLy1JLG72zTiVGlzwsSkt57hOb7eDi8gn48LjpiSzv8NfnjLIGbBLrdBxnUzEK4t
	 oBWjyHv5A6H4HY+dKnHhZAQq0V4OKrGiNvifRaNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 031/222] openvswitch: get related ct labels from its master if it is not confirmed
Date: Tue,  2 Jul 2024 19:01:09 +0200
Message-ID: <20240702170245.167676010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



