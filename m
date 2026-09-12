Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7293478C9C;
	Sat, 12 Sep 2026 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220600; cv=none; b=cLDTeEFk6gCVPwh/QUG2P3FcMuvkSKhzk+gM9SXhSsCRkLobmcy/BNrJ5/Awihpvk0yl2Xvr9wMvkbz6Ivvo3gNBZS+7SNswKZOh84Ee2F3jf1DN3hocNdMl8PRBhKsHWsOhiKcZWNVQY69Vnla26gCQ3g1wWOZuEBdiSaFL9I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220600; c=relaxed/simple;
	bh=WbIzJm4YW6farBBuqwxkvRdWV1HlPVqUhUfwS4IGGQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD1C1SfhSlHH5frocTEeRsNn01mX7pJRYlD3NT2gFCkg7Um6TslDjn7nD9kdjLyRVMGHzds3swWPU/9LMVehVe/J3pZgpyKbNnEVvpa7miphQzVgrU1oZShqJUvC1A1YGqX4dA/SXRKDZ5acRG78WZh/HdQgBndIVpEikxtg9sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXk5+Why; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXk5+Why"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C0A1F000FF;
	Sat, 12 Sep 2026 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220597;
	bh=mXn3M+oLRc4mwyeQPu3fYVMVCuCmDnidMPisEUK20l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXk5+WhyTAXNLc2U7+1UHIYkXGYErvM7xGtzK5GWqrQRyywXlKUJix3UJVnDyZhZ/
	 UtcAJmllQhxUo0KK0W4G51Mb36C0mEEeX0OsNZ9iLTz7IChdR4uHjkvLXFDm9dwWds
	 IwQfEf2F6dnNL1pTVVZko8/nOQ8a3+eUCTyzsYQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunkai Deng <chunkai.deng@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 0167/1424] rpmsg: glink: smem: order FIFO read after availability check
Date: Sat, 12 Sep 2026 08:43:19 +0200
Message-ID: <20260912065611.032329524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunkai Deng <chunkai.deng@oss.qualcomm.com>

commit 786439ad58763e04b91bc2ec5f590e463939f197 upstream.

glink_smem_rx_peek() reads the RX FIFO payload after the caller has
determined data is available via glink_smem_rx_avail(), which reads the
remote-updated head index. A control dependency between the head read
and the subsequent payload read does not order the two loads, so the
CPU may speculatively read the FIFO before observing the head update
and consume stale data the remote has not yet published.

Add rmb() in glink_smem_rx_peek() before the memcpy_fromio() so the
availability (head) read is ordered ahead of the FIFO payload read,
matching the consumer pattern in
Documentation/core-api/circular-buffers.rst.

Fixes: caf989c350e8 ("rpmsg: glink: Introduce glink smem based transport")
Cc: stable@vger.kernel.org
Signed-off-by: Chunkai Deng <chunkai.deng@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260618-rpmsg-glink-smem-mb-v1-1-68a026453a69@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_smem.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -103,6 +103,13 @@ static void glink_smem_rx_peek(struct qc
 	if (tail >= pipe->native.length)
 		tail -= pipe->native.length;
 
+	/*
+	 * Order the availability (head) read in glink_smem_rx_avail()
+	 * against the FIFO payload read below, so APPS never consumes
+	 * stale data the remote has not yet published.
+	 */
+	rmb();
+
 	len = min_t(size_t, count, pipe->native.length - tail);
 	if (len)
 		memcpy_fromio(data, pipe->fifo + tail, len);


