Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C211034DB51;
	Fri, 21 Nov 2025 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733061; cv=none; b=WugVjU555egXNBLuBRzzux+1KKIPrgQ8onXtomv0lehtmp8IAo0fO6o6K1LI3unNGZso+kRANlEDEFDF8fJoUXIk+OnNq5mS+3hyp71LSLVSFZHCTXGpuqirQg/2Q4PYMSUYYjrvsX+db1O/1qByIWfFHzy0c90JYSI79QJHqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733061; c=relaxed/simple;
	bh=7IkW5LZdNHbfPKXbt0Prdmu7S23RVioNoiZfScUF8wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nuyb6hVzxBI0zxVqhFFRfgRHDgi7iXMZe24rTJCA/OKstop9yFGJFOuNEE65tPEKDygnRh1tPfDmeOY2xh7+b70g7OZ9I79zMB3VK0guH6USRPlM+3ZsvlU+MNthUApslgwZCqdidWnzHu/WWgG+clbhndSNPWB5Ry6+iJlM67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yaw1qDDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yaw1qDDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E77C4CEF1;
	Fri, 21 Nov 2025 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733061;
	bh=7IkW5LZdNHbfPKXbt0Prdmu7S23RVioNoiZfScUF8wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yaw1qDDd3dsHmDzn+G4Ftos0Dofbl6XsBNYszShwgxtmQ5uQ3ZW9j/uTwuoeAm2jb
	 jUnTxVmVY5WSoG3nzTDjSxYrcJxG0V2t7AswrWfR1VdCY18GvYnkRurI4lqgM+SvJN
	 At2AXC3uKngM2AYvEtGLtvgumTX5G3hdZtr8S7JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/529] Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()
Date: Fri, 21 Nov 2025 14:10:36 +0100
Message-ID: <20251121130243.021931976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 1c21cf89a66413eb04b2d22c955b7a50edc14dfa ]

The memory allocated for ptr using kvmalloc() is not freed on the last
error path. Fix that by freeing it on that error path.

Fixes: 9a24ce5e29b1 ("Bluetooth: btrtl: Firmware format v2 support")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 7f67e460f7f49..24dae5440c036 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -604,8 +604,10 @@ static int rtlbt_parse_firmware_v2(struct hci_dev *hdev,
 		len += entry->len;
 	}
 
-	if (!len)
+	if (!len) {
+		kvfree(ptr);
 		return -EPERM;
+	}
 
 	*_buf = ptr;
 	return len;
-- 
2.51.0



