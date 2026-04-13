Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66C426CE32;
	Mon, 13 Apr 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097602; cv=none; b=VIFtEonHsRmhhias8EN8kfqMFKWK3e3RgmApQDmAENocyWJEdSokF/K1W79yqhZEcoeSBIukTaGkcyI/tDOfOg1YT/rQxCs0QxVc3qsmzGiL0qH4ToDTmXnxuWk4LsjirLKI9DY0J641+4MwTVYmhIp9Dkp3a4b3NVfCd/u+2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097602; c=relaxed/simple;
	bh=B2Zzqkzrhi7SWiVW8VcvXd25UOQ1OHxHMFjqGZSsXXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E8AIqlAUBf+5/5t1Y0ES3f+cI6xZt/ZXyw6qft1huT52ESvOep7Ba1ikmwOWwg7gdQUm0GBqgXF5vQ9dGd/SHae8UnZM5w+z3dw7wZwJDKidhCrmMY2GctBazsyqthYgYVWygHlqB/toi21Zg0J+FC+Sp+05SnWemMcu2zJV4yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pJR3ccV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pJR3ccV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B95EC2BCAF;
	Mon, 13 Apr 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097602;
	bh=B2Zzqkzrhi7SWiVW8VcvXd25UOQ1OHxHMFjqGZSsXXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pJR3ccV1lGpnJz7jCwUrPO9Y0B8bgqm0tfCm8c485yP+URnVntKBZHCS53anqE7l
	 vZfoQiA2VbNadfzZc+vFoyc1Rn6cThUx0jUsn5f3FfvoT45vOH8qmd4YUmtW30Diae
	 i1jwbHfFiipHnH5mWyzCclMsLcywEK14sOAhnabs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 201/570] Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()
Date: Mon, 13 Apr 2026 17:55:32 +0200
Message-ID: <20260413155837.987857141@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Johannes Möller <research@johannes-moeller.dev>

commit 15145675690cab2de1056e7ed68e59cbd0452529 upstream.

l2cap_ecred_reconf_rsp() casts the incoming data to struct
l2cap_ecred_conn_rsp (the ECRED *connection* response, 8 bytes with
result at offset 6) instead of struct l2cap_ecred_reconf_rsp (2 bytes
with result at offset 0).

This causes two problems:

 - The sizeof(*rsp) length check requires 8 bytes instead of the
   correct 2, so valid L2CAP_ECRED_RECONF_RSP packets are rejected
   with -EPROTO.

 - rsp->result reads from offset 6 instead of offset 0, returning
   wrong data when the packet is large enough to pass the check.

Fix by using the correct type.  Also pass the already byte-swapped
result variable to BT_DBG instead of the raw __le16 field.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Cc: stable@vger.kernel.org
Signed-off-by: Lukas Johannes Möller <research@johannes-moeller.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6397,7 +6397,7 @@ static inline int l2cap_ecred_reconf_rsp
 					 u8 *data)
 {
 	struct l2cap_chan *chan, *tmp;
-	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
+	struct l2cap_ecred_reconf_rsp *rsp = (void *)data;
 	u16 result;
 
 	if (cmd_len < sizeof(*rsp))
@@ -6405,7 +6405,7 @@ static inline int l2cap_ecred_reconf_rsp
 
 	result = __le16_to_cpu(rsp->result);
 
-	BT_DBG("result 0x%4.4x", rsp->result);
+	BT_DBG("result 0x%4.4x", result);
 
 	if (!result)
 		return 0;


